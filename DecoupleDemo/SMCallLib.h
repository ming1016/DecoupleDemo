//
//  SMCallLib.h
//  HomePageTest
//
//  Created by DaiMing on 2017/7/8.
//  Copyright © 2017年 DiDi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <dlfcn.h>
#import <pthread.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>

#import <mach/task.h>
#import <mach/vm_map.h>
#import <mach/mach_init.h>
#import <mach/thread_act.h>
#import <mach/thread_info.h>

// __LP64__ __arm64__ 这样的宏定义是在编译器里定义的。https://github.com/llvm-mirror/clang/blob/0e261f7c4df17c1432f9cc031ae12e3cf5a19347/lib/Frontend/InitPreprocessor.cpp

#ifdef __LP64__
typedef struct mach_header_64     machHeaderByCPU;
typedef struct segment_command_64 segmentComandByCPU;
typedef struct section_64         sectionByCPU;
typedef struct nlist_64           nlistByCPU;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT_64

#else
typedef struct mach_header        machHeaderByCPU;
typedef struct segment_command    segmentComandByCPU;
typedef struct section            sectionByCPU;
typedef struct nlist              nlistByCPU;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT
#endif

#ifndef SEG_DATA_CONST
#define SEG_DATA_CONST  "__DATA_CONST"
#endif

@interface SMCallLib : NSObject

@end
