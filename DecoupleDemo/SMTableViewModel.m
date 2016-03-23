//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "SMTableViewModel.h"

@implementation SMTableViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self buildDefalutValue];
    }
    return self;
}

- (instancetype)initWithDefaultValue {
    if (self = [super init]) {
        [self buildDefalutValue];
    }
    return self;
}

- (void)buildDefalutValue {
    NSMutableArray *rowArray = [NSMutableArray array];
    self.dataSourceArray = rowArray;
    
    self.backgroundColor = [UIColor whiteColor];
    self.cellBackgroundColor = [UIColor whiteColor];
    
    self.headerViewHeight = 0;
    self.fixedViewHeight = 0;
    self.hintViewHeight = 0;
    
    //下拉上拉刷新
    self.refreshingHeaderStateLabelFont = [UIFont systemFontOfSize:14];
    self.refreshingHeaderStateLabelColor = [UIColor grayColor];
    self.refreshingHeaderTitleIdleText = @"下拉可以刷新";
    self.refreshingHeaderTitlePullingText = @"松开立即刷新";
    self.refreshingHeaderTitleRefreshingText = @"正在刷新数据中...";
    self.refreshingFooterStateLabelFont = [UIFont systemFontOfSize:14];
    self.refreshingFooterStateLabelColor = [UIColor grayColor];
    self.refreshingFooterTitleIdleText = @"上拉加载更多";
    self.refreshingFooterTitleRefreshingText = @"正在加载...";
    self.refreshingFooterTitleNoMoreDataText = @"没有更多了";
}

#pragma mark - Getter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}
- (UIView *)fixedView {
    if (!_fixedView) {
        _fixedView = [[UIView alloc] init];
    }
    return _fixedView;
}
- (UIView *)hintView {
    if (!_hintView) {
        _hintView = [[UIView alloc] init];
    }
    return _hintView;
}
- (UIView *)guideView {
    if (!_guideView) {
        _guideView = [[UIView alloc] init];
    }
    return _guideView;
}

@end
