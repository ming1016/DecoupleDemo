//
//  SMLagMonitor.h
//
//  Created by DaiMing on 16/3/28.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMLagMonitor : NSObject

+ (instancetype)shareInstance;

- (void)beginMonitor; //开始监视卡顿
- (void)endMonitor;   //停止监视卡顿

@end
