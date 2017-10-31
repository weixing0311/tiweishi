//
//  JFABaseTableViewController.h
//  zhijiangjun
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFASubNetWorkErrorView.h"
#import "ServiceResultErrorView.h"
#import "JFANetWorkServiceItem.h"
#import "AppDelegate.h"
#import "EmptyView.h"

@interface JFABaseTableViewController : UIViewController<subNetWorkDelegate>

@property(nonatomic,strong)NSMutableArray* requestArray;
@property(nonatomic,strong)UIView * loadingView;
@property(nonatomic,strong)ServiceResultErrorView * errorView;
@property(nonatomic,strong)JFASubNetWorkErrorView* networkErrorView;
@property (nonatomic,strong)NSURLSessionTask * currentTasks;
@property (nonatomic,strong) EmptyView * emptyView;
-(void)refreshForNetworkError;
-(UIImage*)backImage;
- (void)back;
-(void)BrokenNetworkReconnection;
-(void)doloign;
#pragma mark-NetService
-(void)loadNewData;
-(JFANetWorkServiceItem *)getServiceItem;
-(void)startService;
-(void)startServiceWithItem:(JFANetWorkServiceItem*)item isShowLoading:(BOOL)isShowLoading;
-(void)serviceSucceededWithResult:(id)result operation:(NSURLSessionTask*)operation;
-(void)serviceFailedWithError:(NSError*)error operation:(NSURLSessionTask*)operation;
-(BOOL)isEqualUrl:(NSString*)url forOperation:(NSURLSessionTask*)operation;
-(void)showNetworkError;
-(void)showError;
/*！添加mjrefresh*/
-(void)setRefrshWithTableView:(UITableView *)tb;
/**
 *下拉刷新方法
 */
-(void)headerRereshing;
/*! 上拉加载方法 */
-(void)footerRereshing;

/*! 加载xibview  */
-(id)getXibCellWithTitle:(NSString *)title;
/*!  隐藏tableview内容下方下划线*/
-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb;

/*! 设置navigaionbar 和title的颜色 */
-(void)setNbColor;
-(void)setTBRedColor;
-(void)setTBWhiteColor;

-(void)showError:(NSString *)text;

/**
 * 设置segment的样式为白色背景只修改字体颜色
 */
-(void)ChangeMySegmentStyle:(UISegmentedControl*)segment;

-(NSString*)DataTOjsonString:(id)object;
-(void)showEmptyViewWithTitle:(NSString *)title;

-(void)hiddenEmptyView;

@end
