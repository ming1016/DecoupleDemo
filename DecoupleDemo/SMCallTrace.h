//
//  SMCallTrace.h
//  HomePageTest
//
//  Created by DaiMing on 2017/7/8.
//  Copyright © 2017年 DiDi. All rights reserved.
//

#import <Foundation/Foundation.h>

//record 耗时的 struct
typedef struct {
    __unsafe_unretained Class cls;;
    SEL sel;
    uint64_t time;
    int depth;
} smCallRecord;

//hook c struct
struct smRebinding {
    const char *name;
    void *replacement;
    void **replaced;
};



@interface SMCallTrace : NSObject

int smRebindSymbols(struct smRebinding rebindings[], size_t rebindings_nel);

@end
