//
//  SMCallTraceTimeCostModel.h
//  DecoupleDemo
//
//  Created by DaiMing on 2017/7/15.
//  Copyright © 2017年 Starming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCallTraceTimeCostModel : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, assign) BOOL isClassMethod;
@property (nonatomic, assign) NSTimeInterval timeCost;
@property (nonatomic, assign) NSUInteger callDepth;
@property (nonatomic, strong) NSArray <SMCallTraceTimeCostModel *> *subCosts;

- (NSString *)des;

@end
