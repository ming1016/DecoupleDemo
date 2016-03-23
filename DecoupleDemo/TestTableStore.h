//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTableViewModel.h"

typedef NS_ENUM (NSUInteger, TestTableType) {
    TestTableTypeFirst,
    TestTableTypeSecond,
    TestTableTypeThird
};

@interface TestTableStore : NSObject

- (instancetype)initWithViewModel:(SMTableViewModel *)viewModel;
- (void)updateWithViewModel:(SMTableViewModel *)viewModel;

@end

