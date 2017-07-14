//
//  SMCallTrace.m
//  HomePageTest
//
//  Created by DaiMing on 2017/7/8.
//  Copyright © 2017年 DiDi. All rights reserved.
//

#import "SMCallTrace.h"
#import "SMCallLib.h"

#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <stddef.h>
#import <stdint.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <sys/time.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <dispatch/dispatch.h>

static bool _smCallRecordEnable = true;

struct rebindingsEntry {
    struct smRebinding *rebindings;
    size_t rebindingsNel;
    struct rebindingsEntry *next;
};

static struct rebindingsEntry *_smRebindingsHead;

@implementation SMCallTrace

#pragma mark - Trace



#pragma mark - Rebinding
#pragma mark - Interface
//替换接口
int smRebindSymbols(struct smRebinding rebindings[], size_t rebindingsNel) {
    int retval = prependRebindings(&_smRebindingsHead, rebindings, rebindingsNel);
    if (retval < 0) {
        return retval;
    }
    //第一次call 就注册 _rebindSymbolsForImage，后面就直接作用在image上
    if (!_smRebindingsHead->next) {
        _dyld_register_func_for_add_image(_rebindSymbolsForImage);
    } else {
        uint32_t c = _dyld_image_count();
        for (uint32_t i = 0; i < c; i++) {
            _rebindSymbolsForImage(_dyld_get_image_header(i), _dyld_get_image_vmaddr_slide(i));
        }
    }
    return retval;
}

//通过Image header 指定某个 Image
int rebindSymbolsImage(void *header, intptr_t slide, struct smRebinding rebindings[], size_t rebindingsNel) {
    struct rebindingsEntry *rebindingsHead = NULL;
    int retval = prependRebindings(&rebindingsHead, rebindings, rebindingsNel);
    rebindSymbolsForImage(rebindingsHead, (const struct mach_header *)header, slide);
    free(rebindingsHead);
    return retval;
}

//rebindingsEntry 结构体里添加 rebindingsEntry 的方法。
static int prependRebindings(struct rebindingsEntry **_rebindingsHead, struct smRebinding rebindings[], size_t nel) {
    struct rebindingsEntry *newEntry = (struct rebindingsEntry*)malloc(sizeof(struct rebindingsEntry));
    if (!newEntry) {
        return -1;
    }
    newEntry->rebindings = (struct smRebinding *)malloc(sizeof(struct smRebinding) * nel);
    if (!newEntry->rebindings) {
        free(newEntry);
        return -1;
    }
    memcpy(newEntry->rebindings, rebindings, sizeof(struct smRebinding) * nel);
    newEntry->rebindingsNel = nel;
    newEntry->next = *_rebindingsHead;
    *_rebindingsHead = newEntry;
    return 0;
}

static void performRebindingWithSection(struct rebindingsEntry *rebindings, sectionByCPU *section, intptr_t slide, nlistByCPU *symtab, char *strTab, uint32_t *indirectSymtab) {
    //在indirect symbol表里获取到地址
    uint32_t *indirectSymbolIndices = indirectSymtab + section->reserved1;
    void **indirectSymbolBindings = (void **)((uintptr_t)slide + section->addr);
    //获取一个一个字。section->size 是一个section的长度，sizeof(void*) 是单个字符的长度
    for (uint i = 0; i < section->size / sizeof(void *); i++) {
        uint32_t symtabIndex = indirectSymbolIndices[i];
        if (symtabIndex == INDIRECT_SYMBOL_ABS || symtabIndex == INDIRECT_SYMBOL_LOCAL || symtabIndex == (INDIRECT_SYMBOL_LOCAL | INDIRECT_SYMBOL_ABS)) {
            continue;
        }
        uint32_t strTabOffset = symtab[symtabIndex].n_un.n_strx;
        char *symbolName = strTab + strTabOffset;
        if (strnlen(symbolName, 2) < 2) {
            continue;
        }
        struct rebindingsEntry *cur = rebindings;
        while (cur) {
            for (uint j = 0; j < cur->rebindingsNel; j++) {
                if (strcmp(&symbolName[1], cur->rebindings[j].name) == 0) {
                    if (cur->rebindings[j].replaced != NULL && indirectSymbolBindings[i] != cur->rebindings[j].replacement) {
                        *(cur->rebindings[j].replaced) = indirectSymbolBindings[i];
                    }
                    indirectSymbolBindings[i] = cur->rebindings[j].replacement;
                    goto symbol_loop;
                }
            }
            cur = cur->next;
        }
    symbol_loop:;
    }
}

static void rebindSymbolsForImage(struct rebindingsEntry *rebindings, const struct mach_header *header, intptr_t slide) {
    Dl_info info;
    if (dladdr(header, &info) == 0) {
        return;
    }
    
    segmentComandByCPU *curSegCmd;
    segmentComandByCPU *linkeditSegment = NULL;
    struct symtab_command* symTabCmd = NULL;
    struct dysymtab_command* dysymTabCmd = NULL;
    
    uintptr_t cur = (uintptr_t)header + sizeof(machHeaderByCPU);
    //遍历 header 里的 cmd 找出 linkedit ，symtab 和 dysymtab 的segment command 出来。
    for (uint i = 0; i < header->ncmds; i++, cur += curSegCmd->cmdsize) {
        curSegCmd = (segmentComandByCPU *)cur;
        if (curSegCmd->cmd == LC_SEGMENT_ARCH_DEPENDENT) {
            if (strcmp(curSegCmd->segname, SEG_LINKEDIT) == 0) {
                linkeditSegment = curSegCmd;
            }
        } else if (curSegCmd->cmd == LC_SYMTAB) {
            symTabCmd = (struct symtab_command*)curSegCmd;
        } else if (curSegCmd->cmd == LC_DYSYMTAB) {
            dysymTabCmd = (struct dysymtab_command*)curSegCmd;
        }
    }
    
    if (!symTabCmd || !dysymTabCmd || !linkeditSegment || !dysymTabCmd->nindirectsyms) {
        return;
    }
    
    //找 base symbol/string table 的地址
    uintptr_t linkeditBase = (uintptr_t)slide + linkeditSegment->vmaddr - linkeditSegment->fileoff;
    nlistByCPU *symTab = (nlistByCPU *)(linkeditBase + symTabCmd->symoff);
    char *strTab = (char *)(linkeditBase + symTabCmd->stroff);
    
    //获得 indirect symbol table，由一些 uint32_t 数字组成的 symbol table
    uint32_t *indirectSymTab = (uint32_t *)(linkeditBase + dysymTabCmd->indirectsymoff);
    
    cur = (uintptr_t)header + sizeof(machHeaderByCPU);
    for (uint i = 0; i < header->ncmds; i++, cur += curSegCmd->cmdsize) {
        curSegCmd = (segmentComandByCPU *)cur;
        if (curSegCmd->cmd == LC_SEGMENT_ARCH_DEPENDENT) {
            //segment 需要是 __DATA 或者是 __DATA_CONST
            if (strcmp(curSegCmd->segname, SEG_DATA) != 0 && strcmp(curSegCmd->segname, SEG_DATA_CONST)) {
                continue;
            }
            //遍历 segment里的section。 nsects 表示里面 section 的数量。
            for (uint j = 0; j < curSegCmd->nsects; j++) {
                sectionByCPU *sect = (sectionByCPU *)(cur + sizeof(segmentComandByCPU)) + j;
                //flag 表示 section的类型和属性
                if ((sect->flags & SECTION_TYPE) == S_LAZY_SYMBOL_POINTERS) {
                    performRebindingWithSection(rebindings, sect, slide, symTab, strTab, indirectSymTab);
                }
                if ((sect->flags & SECTION_TYPE) == S_NON_LAZY_SYMBOL_POINTERS) {
                    performRebindingWithSection(rebindings, sect, slide, symTab, strTab, indirectSymTab);
                }
            } //end for of section in segment
        } //end if LC_SEGMENT_ARCH_DEPENDENT
    } //end for of command in header
}

static void _rebindSymbolsForImage(const struct mach_header *header, intptr_t slide) {
    rebindSymbolsForImage(_smRebindingsHead, header, slide);
}












@end
