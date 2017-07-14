//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "TestTableView.h"
#import "Masonry.h"
#import "TestTableCellView.h"
#import "TestTableViewCell.h"

@interface TestTableView()


@property (nonatomic, strong) UILabel *cellLabel;

@end

@implementation TestTableView

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [self buildForInit];
    }
    return self;
}

- (void)buildForInit {
    [self updateWithViewModel:[self buildViewModel]];
}

#pragma mark - Interface
- (void)configCell {
    TestTableViewCell *cell = [self.viewModel.tableView dequeueReusableCellWithIdentifier:self.viewModel.tableViewIdentifier];
    
    if (!cell) {
        //
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.viewModel.tableViewIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = self.viewModel.cellBackgroundColor;
    }
    
    //这里是做卡顿监测demo用的，不测时可以注掉
    if (self.viewModel.cellIndexPath.row%10 == 0)
    {
        usleep(200*1000);
        NSLog(@"费时测试");
    }
    
    [cell.cellView buildTitle:self.viewModel.dataSourceArray[self.viewModel.cellIndexPath.row]];
    
    self.viewModel.cell = cell;
    
}
- (void)configCellHeight {
    self.viewModel.cellHeight = 80;
}

#pragma mark - Private
- (SMTableViewModel *)buildViewModel {
    SMTableViewModel *viewModel = [[SMTableViewModel alloc] init];
    
    //开关
    viewModel.isCloseRefresh = NO;
    viewModel.isAutoRefreshing = NO;
    
    
    //header view
    viewModel.headerView.backgroundColor = [UIColor grayColor];
    if (viewModel.headerViewHeight == 0) {
        viewModel.headerViewHeight = 80;
    }
    
    UILabel *text = [[UILabel alloc] init];
    text.text = @"可滚动视图";
    text.textColor = [UIColor lightGrayColor];
    [viewModel.headerView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewModel.headerView);
    }];
    
    
    //fixed view
    viewModel.fixedView.backgroundColor = [UIColor lightGrayColor];
    if (viewModel.fixedViewHeight == 0) {
        viewModel.fixedViewHeight = 30;
    }
    
    UILabel *fixText = [[UILabel alloc] init];
    fixText.text = @"固定头部视图";
    fixText.textColor = [UIColor whiteColor];
    [viewModel.fixedView addSubview:fixText];
    [fixText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewModel.fixedView);
    }];
    
    
    //hint view
    viewModel.hintView.backgroundColor = [UIColor orangeColor];
    if (viewModel.hintViewHeight == 0) {
        viewModel.hintViewHeight = 38;
    }
    UILabel *hintText = [[UILabel alloc] init];
    hintText.text = @"您有一条新消息";
    hintText.textColor = [UIColor whiteColor];
    [viewModel.hintView addSubview:hintText];
    [hintText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewModel.hintView);
    }];
    UIButton *hintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewModel.hintView addSubview:hintButton];
    [hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(viewModel.hintView);
    }];
    [hintButton addTarget:self action:@selector(hintButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //guide view
    viewModel.guideView.backgroundColor = [UIColor redColor];
    UILabel *guideText = [[UILabel alloc] init];
    [viewModel.guideView addSubview:guideText];
    guideText.text = @"Guide";
    guideText.textColor = [UIColor whiteColor];
    [guideText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewModel.guideView);
    }];
    return viewModel;
}
- (void)hintButtonClick {
    self.viewModel.isHideHintView = YES;
}

#pragma mark - Getter

- (UILabel *)cellLabel {
    if (!_cellLabel) {
        _cellLabel = [[UILabel alloc] init];
    }
    return _cellLabel;
}


@end
