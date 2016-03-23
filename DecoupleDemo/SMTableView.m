//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "SMTableView.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UIView+Additions.h"

static NSString *smTableViewIdentifier = @"SMTableViewCellIdentifier";

@interface SMTableView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

//View
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *headerView;
@property (nonatomic, strong) UIView      *fixedView;
@property (nonatomic, strong) UIView      *hintView;
@property (nonatomic, strong) UIView      *guideView;

//Helper
@property (nonatomic, assign) CGFloat startOffsetY;

@end

@implementation SMTableView

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [self buildTableView];
    }
    return self;
}
- (instancetype)initWithViewModel:(SMTableViewModel *)viewModel {
    if (self = [super init]) {
        [self buildTableView];
        [self updateWithViewModel:viewModel];
    }
    return self;
}

- (void)dealloc {
    [self removeKVO];
}

#pragma mark - construct

- (void)buildTableView {
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    self.backgroundColor = self.viewModel.backgroundColor;
    [self addSubview:self.headerView];
    [self addSubview:self.fixedView];
    [self addSubview:self.tableView];
    [self addSubview:self.hintView];
    [self addSubview:self.guideView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.left.right.equalTo(self);
        make.height.mas_equalTo(self.viewModel.headerViewHeight);
    }];
    [self.fixedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.width.left.right.equalTo(self);
        make.height.mas_equalTo(self.viewModel.fixedViewHeight);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fixedView.mas_bottom);
        make.width.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.left.right.equalTo(self.tableView);
        make.height.mas_equalTo(self.viewModel.hintViewHeight);
    }];
    [self hideHintView:YES];
    
    [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.left.right.bottom.equalTo(self.tableView);
    }];
    [self hideGuideView:YES];
    
}

#pragma mark - Interface
- (void)updateWithViewModel:(SMTableViewModel *)viewModel {
    //view model set
    self.viewModel = viewModel;
    
    //table view
    [self updateTableViewConstraints];
    
    //kvo
    [self addKVO];
    
    //deal with 开关
    [self judgeIfNeedRefresh];
    
    //deal with auto refreshing
    if (self.viewModel.isAutoRefreshing) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    //check if need display
    if (self.viewModel.headerViewHeight == 0) {
        self.headerView.hidden = YES;
    } else {
        self.headerView.hidden = NO;
    }
    if (self.viewModel.fixedViewHeight == 0) {
        self.fixedView.hidden = YES;
    } else {
        self.fixedView.hidden = NO;
    }
}

#pragma mark - Private
- (void)reloadData {
    [self.tableView reloadData];
}
- (void)refreshDataSource {
    self.viewModel.dataSourceRefreshingStatus = SMTableRefreshingStatusRefresh;
}
- (void)loadMoreDataSource {
    self.viewModel.dataSourceRefreshingStatus = SMTableRefreshingStatusLoadMore;
}
- (void)judgeIfNeedRefresh {
    if (self.viewModel.isCloseRefresh) {
        //
        self.tableView.mj_header = nil;
        self.tableView.mj_footer = nil;
    } else {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataSource)];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSource)];
        //设置refresh的header和footer
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.tableView.mj_header;
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
        //header
        header.lastUpdatedTimeLabel.hidden = YES;
        [header.arrowView setImage:[UIImage imageNamed:@""]];
        
        header.stateLabel.font = self.viewModel.refreshingHeaderStateLabelFont;
        header.stateLabel.textColor = self.viewModel.refreshingHeaderStateLabelColor;
        [header setTitle:self.viewModel.refreshingHeaderTitleIdleText forState:MJRefreshStateIdle];
        [header setTitle:self.viewModel.refreshingHeaderTitlePullingText forState:MJRefreshStatePulling];
        [header setTitle:self.viewModel.refreshingHeaderTitleRefreshingText forState:MJRefreshStateRefreshing];
        
        //footer
        footer.automaticallyHidden = NO;
        footer.stateLabel.font = self.viewModel.refreshingFooterStateLabelFont;
        footer.stateLabel.textColor = self.viewModel.refreshingFooterStateLabelColor;
        [footer setTitle:self.viewModel.refreshingFooterTitleIdleText forState:MJRefreshStateIdle];
        [footer setTitle:self.viewModel.refreshingFooterTitleRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:self.viewModel.refreshingFooterTitleNoMoreDataText forState:MJRefreshStateNoMoreData];
        
    }
    
}
- (void)updateTableViewConstraints {
    //deal with headerView
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.viewModel.headerViewHeight);
    }];
    if (self.viewModel.headerView) {
        [self.headerView addSubview:self.viewModel.headerView];
        [self.viewModel.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.headerView);
        }];
    }
    
    //deal with fixView
    [self.fixedView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.viewModel.fixedViewHeight);
    }];
    if (self.viewModel.fixedView) {
        [self.fixedView addSubview:self.viewModel.fixedView];
        [self.viewModel.fixedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.fixedView);
        }];
    }
    
    //deal with hintView
    [self.hintView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.viewModel.hintViewHeight);
    }];
    if (self.viewModel.hintView) {
        [self.hintView addSubview:self.viewModel.hintView];
        [self.viewModel.hintView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.hintView);
        }];
    }
    
    //deal with guideView
    if (self.viewModel.guideView) {
        [self.guideView addSubview:self.viewModel.guideView];
        [self.viewModel.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.guideView);
        }];
    }
}

- (void)hideGuideView:(BOOL)isHide {
    self.guideView.hidden = isHide;
    self.tableView.scrollEnabled = isHide;
}
- (void)hideHintView:(BOOL)isHide {
    self.hintView.hidden = isHide;
}
- (void)endRefreshRefreshing {
    [self reloadData];
    if (!self.viewModel.isCloseRefresh) {
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)endLoadMoreRefreshing {
    [self reloadData];
    if (!self.viewModel.isCloseRefresh) {
        [self.tableView.mj_footer endRefreshing];
    }
}


#pragma mark - Delegate
#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.cellHeightIndexPath = indexPath;
    return self.viewModel.cellHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.tableViewIdentifier = smTableViewIdentifier;
    self.viewModel.tableView = tableView;
    self.viewModel.cellIndexPath = indexPath;
    return self.viewModel.cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        self.startOffsetY = scrollView.contentOffset.y;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (self.viewModel.headerViewHeight > 0) {
            if (offsetY < self.viewModel.headerViewHeight && offsetY > 0) {
                [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(-self.viewModel.headerViewHeight);
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self layoutIfNeeded];
                }];
            }
            if (offsetY > -self.viewModel.headerViewHeight && offsetY < 0) {
                [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self);
                }];
                [UIView animateWithDuration:0.5 animations:^ {
                    [self layoutIfNeeded];
                }];
            }
        } //end header view
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableView) {
        [self dealWithScrollViewMovingEndWithMovingOffsetY:scrollView.contentOffset.y - self.startOffsetY];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.tableView) {
        [self dealWithScrollViewMovingEndWithMovingOffsetY:scrollView.contentOffset.y - self.startOffsetY];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self dealWithScrollViewMovingEndWithMovingOffsetY:scrollView.contentOffset.y - self.startOffsetY];
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self dealWithScrollViewMovingEndWithMovingOffsetY:-1];
    }
}

- (void)dealWithScrollViewMovingEndWithMovingOffsetY:(CGFloat)movingOffsetY {
    if (self.viewModel.headerViewHeight > 0) {
        if (self.headerView.top > - self.viewModel.headerViewHeight && self.headerView.top < 0) {
            if (movingOffsetY > 0) {
                [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(-self.viewModel.headerViewHeight);
                }];
                [UIView animateWithDuration:0.3 animations:^ {
                    [self layoutIfNeeded];
                }];
            } else {
                [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self);
                }];
                [UIView animateWithDuration:0.3 animations:^ {
                    [self layoutIfNeeded];
                }];
            }
        }
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self judgeIfNeedRefresh];
    }
    return _tableView;
}
- (SMTableViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SMTableViewModel alloc] initWithDefaultValue];
    }
    return _viewModel;
}
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

#pragma mark - KVO
- (void)addKVO {
    //KVO addObserver
    [self.viewModel addObserver:self forKeyPath:@"isHideGuideView" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.viewModel addObserver:self forKeyPath:@"isHideHintView" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.viewModel addObserver:self forKeyPath:@"requestStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}
- (void)removeKVO {
    [self.viewModel removeObserver:self forKeyPath:@"isHideGuideView"];
    [self.viewModel removeObserver:self forKeyPath:@"isHideHintView"];
    [self.viewModel removeObserver:self forKeyPath:@"requestStatus"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //guide view
    if ([keyPath isEqualToString:@"isHideGuideView"]) {
        [self hideGuideView:self.viewModel.isHideGuideView];
    }
    //hint view
    else if ([keyPath isEqualToString:@"isHideHintView"]) {
        [self hideHintView:self.viewModel.isHideHintView];
    }
    //end refresh refreshing
    else if ([keyPath isEqualToString:@"requestStatus"]) {
        switch (self.viewModel.requestStatus) {
            case SMTableRequestStatusLoadMoreSuccess:
            case SMTableRequestStatusLoadMoreFailed:
                [self endLoadMoreRefreshing];
                break;
            case SMTableRequestStatusRefreshSuccess:
            case SMTableRequestStatusRefreshFailed:
                [self endRefreshRefreshing];
                break;
        }
    }
    
}

@end
