//
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/4.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import <UIKit/UIKit.h>
//刷新状态
typedef NS_ENUM(NSUInteger, SMTableRefreshingStatus) {
    SMTableRefreshingStatusRefresh, //下拉刷新
    SMTableRefreshingStatusLoadMore //加载更多
};
//请求状态
typedef NS_ENUM(NSUInteger, SMTableRequestStatus) {
    SMTableRequestStatusRefreshSuccess,  //下拉刷新成功
    SMTableRequestStatusRefreshFailed,   //下拉刷新失败
    SMTableRequestStatusLoadMoreSuccess, //加载更多成功
    SMTableRequestStatusLoadMoreFailed   //加载更多失败
};

@interface SMTableViewModel : NSObject
//---------------------------
//            通用
//---------------------------
@property (nonatomic, assign) NSUInteger type;

//---------------------------
//         建议Store里设置
//---------------------------
@property (nonatomic, strong) NSMutableArray *dataSourceArray;  //数据

//---------------------------
//      建议视图tableview里设置
//---------------------------
@property (nonatomic, strong) UIColor *backgroundColor;         //背景颜色
@property (nonatomic, strong) UIColor *cellBackgroundColor;     //cell的背景颜色

//自定义附加视图
@property (nonatomic, strong) UIView *headerView;               //可随拖动消失的视图
@property (nonatomic, assign) CGFloat headerViewHeight;         //可随拖动消失的视图的高
@property (nonatomic, strong) UIView *fixedView;                //固定不动的视图
@property (nonatomic, assign) CGFloat fixedViewHeight;          //固定不动的视图高
@property (nonatomic, strong) UIView *hintView;                 //提示视图
@property (nonatomic, assign) CGFloat hintViewHeight;           //提示视图的高
@property (nonatomic, strong) UIView *guideView;                //覆盖在tableView上方的引导说明视图

//---------------------------
//           KVO View Side
//---------------------------
@property (nonatomic, assign) BOOL isHideGuideView;             //是否显示guide view
@property (nonatomic, assign) BOOL isHideHintView;              //是否显示hint view
//下拉刷新上拉加载更多
@property (nonatomic, assign) SMTableRequestStatus requestStatus; //刷新状态
//TableView Delegate
//通用
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *tableViewIdentifier;
//Cell
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, strong) UITableViewCell *cell;
//CellHeight
@property (nonatomic, strong) NSIndexPath *cellHeightIndexPath;
@property (nonatomic, assign) CGFloat cellHeight;


//---------------------------
//          KVO Data Side
//---------------------------
@property (nonatomic, assign) SMTableRefreshingStatus dataSourceRefreshingStatus; //请求状态

//---------------------------
//           开关
//---------------------------
@property (nonatomic, assign) BOOL isCloseRefresh;              //是否关闭下拉刷新，上拉加载更多
@property (nonatomic, assign) BOOL isAutoRefreshing;            //是否自动刷新

//---------------------------
//      下拉刷新上拉加载更多样式
//---------------------------
@property (nonatomic, strong) UIFont *refreshingHeaderStateLabelFont;         //刷新组件下拉刷新文本字体
@property (nonatomic, strong) UIColor *refreshingHeaderStateLabelColor;       //刷新组件下拉刷新文本颜色
@property (nonatomic, copy) NSString *refreshingHeaderTitleIdleText;          //刷新组件下拉静态文字
@property (nonatomic, copy) NSString *refreshingHeaderTitlePullingText;       //刷新组件下拉时的文字
@property (nonatomic, copy) NSString *refreshingHeaderTitleRefreshingText;    //刷新组件下拉刷新时显示文字

@property (nonatomic, strong) UIFont *refreshingFooterStateLabelFont;         //刷新组件加载更多文本字体
@property (nonatomic, strong) UIColor *refreshingFooterStateLabelColor;       //刷新组件加载更多文本颜色
@property (nonatomic, copy) NSString *refreshingFooterTitleIdleText;          //刷新组件加载更多静态文字
@property (nonatomic, copy) NSString *refreshingFooterTitleRefreshingText;    //刷新组件加载更多刷新时的文字
@property (nonatomic, copy) NSString *refreshingFooterTitleNoMoreDataText;    //刷新组件加载更多没有数据的文字


- (instancetype)initWithDefaultValue;

@end
