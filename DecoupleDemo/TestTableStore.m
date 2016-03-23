//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "TestTableStore.h"

@interface TestTableStore()

@property (nonatomic, strong) SMTableViewModel *viewModel;

@end

@implementation TestTableStore

- (instancetype)initWithViewModel:(SMTableViewModel *)viewModel {
    if (self = [super init]) {
        [self updateWithViewModel:viewModel];
    }
    return self;
}
- (void)updateWithViewModel:(SMTableViewModel *)viewModel {
    self.viewModel = viewModel;
    
    //KVO add observer
    [self addKVO];
}
- (void)dealloc {
    [self removeKVO];
}

- (void)refreshData {
    NSArray *arr = @[@"这是第一条数据",@"这是第二条数据",@"这是第三条数据",@"这是第四条数据",@"这是第五条数据",@"这是第六条数据",@"这是第七条数据",@"这是第八条",@"这是第九条",@"这是第十条数据",@"这是第十一条数据",@"这是第十二条",@"这是第十三条",@"这是第十四条数据",@"这是第十五条",@"这是第十六条数据",@"这是第十七条数据",@"这是第十八条数据"];
    switch (self.viewModel.type) {
        case TestTableTypeFirst:
            arr = @[@"这是第一条数据",@"这是第二条数据",@"这是第三条数据",@"这是第四条数据",@"这是第五条数据",@"这是第六条数据",@"这是第七条数据",@"这是第八条",@"这是第九条",@"这是第十条数据",@"这是第十一条数据",@"这是第十二条",@"这是第十三条",@"这是第十四条数据",@"这是第十五条",@"这是第十六条数据",@"这是第十七条数据",@"这是第十八条数据"];
            break;
        case TestTableTypeSecond:
            //
            break;
        case TestTableTypeThird:
            //
            break;
        default:
            
            break;
    }
    
    self.viewModel.dataSourceArray = [NSMutableArray arrayWithArray:arr];
    //成功
    self.viewModel.requestStatus = SMTableRequestStatusRefreshSuccess;
}
- (void)loadMoreData {
    NSArray *arr = @[@"读取更多数据开始",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据",@"读取更多数据结束"];
    NSArray *arro = [NSArray arrayWithArray:self.viewModel.dataSourceArray];
    NSMutableArray *marro = [NSMutableArray arrayWithArray:arro];
    [marro addObjectsFromArray:arr];
    self.viewModel.dataSourceArray = marro;
    
    //成功
    self.viewModel.requestStatus = SMTableRequestStatusLoadMoreSuccess;
}

#pragma mark - KVO
- (void)addKVO {
    [self.viewModel addObserver:self forKeyPath:@"dataSourceRefreshingStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}
- (void)removeKVO {
    [self.viewModel removeObserver:self forKeyPath:@"dataSourceRefreshingStatus"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dataSourceRefreshingStatus"]) {
        if (self.viewModel.dataSourceRefreshingStatus == SMTableRefreshingStatusRefresh) {
            [self refreshData];
        } else if (self.viewModel.dataSourceRefreshingStatus == SMTableRefreshingStatusRefresh) {
            [self loadMoreData];
        }
    }
    
}

@end
