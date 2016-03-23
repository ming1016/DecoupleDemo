//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "testTableViewController.h"
#import "Masonry.h"
#import "TestTableView.h"
#import "SMTableView.h"
#import "TestTableStore.h"

@interface testTableViewController ()

@property (nonatomic, strong) TestTableView *tbView;
@property (nonatomic, strong) TestTableStore *tbStore;

@end

@implementation testTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addKVO];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tbView];
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(22);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.tbStore = [[TestTableStore alloc] initWithViewModel:self.tbView.viewModel];
    
}
- (void)dealloc {
    [self removeKVO];
}



#pragma mark - Getter
- (TestTableView *)tbView {
    if (!_tbView) {
        _tbView = [[TestTableView alloc] init];
        NSArray *arr = @[@"这是第一条数据",@"这是第二条数据",@"这是第三条数据",@"这是第四条数据",@"这是第五条数据",@"这是第六条数据",@"这是第七条数据",@"这是第八条",@"这是第九条",@"这是第十条数据",@"这是第十一条数据",@"这是第十二条",@"这是第十三条",@"这是第十四条数据",@"这是第十五条",@"这是第十六条数据",@"这是第十七条数据",@"这是第十八条数据"];
        NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
        _tbView.viewModel.dataSourceArray = marr;
    }
    return _tbView;
}

#pragma mark - KVO
- (void)addKVO {
    [self.tbView.viewModel addObserver:self forKeyPath:@"requestStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.tbView.viewModel addObserver:self forKeyPath:@"cellIndexPath" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.tbView.viewModel addObserver:self forKeyPath:@"cellHeightIndexPath" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}
- (void)removeKVO {
    [self.tbView.viewModel removeObserver:self forKeyPath:@"requestStatus"];
    [self.tbView.viewModel removeObserver:self forKeyPath:@"cellIndexPath"];
    [self.tbView.viewModel removeObserver:self forKeyPath:@"cellHeightIndexPath"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"requestStatus"]) {
        switch (self.tbView.viewModel.requestStatus) {
            case SMTableRequestStatusRefreshSuccess:
            case SMTableRequestStatusRefreshFailed:
            case SMTableRequestStatusLoadMoreFailed:
            case SMTableRequestStatusLoadMoreSuccess:
                self.tbView.viewModel.isHideGuideView = YES;
                self.tbView.viewModel.isHideHintView = NO;
                break;
        }
    } else if ([keyPath isEqualToString:@"cellIndexPath"]) {
        [self.tbView configCell];
    } else if ([keyPath isEqualToString:@"cellHeightIndexPath"]) {
        [self.tbView configCellHeight];
    }
}

@end


