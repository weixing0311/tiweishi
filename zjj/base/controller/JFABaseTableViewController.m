//
//  JFABaseTableViewController.m
//  zhijiangjun
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import "BaseSservice.h"
#import "JFASubNetWorkErrorView.h"
#import "LoignViewController.h"
#import "MJRefresh.h"
#import "PerfectInformationViewController.h"
#import "BodyFatDivisionAgreementViewController.h"
#import "TzsTabbarViewController.h"
@interface JFABaseTableViewController ()
{
    NSTimer * hiddenErrorTimer;
    UILabel * errorLabel;
}
@end

@implementation JFABaseTableViewController

@synthesize requestArray=_requestArray;
@synthesize loadingView=_loadingView;
@synthesize errorView=_errorView;
@synthesize networkErrorView=_networkErrorView;


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.currentTasks cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance]backButtonTitlePositionAdjustmentForBarMetrics: UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doloign) name:kdidReLoign object:nil];
    // Do any additional setup after loading the view.
//    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.edgesForExtendedLayout= UIRectEdgeNone;
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorForHex:@"ffffff"]];
//    }else{
//
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_background"] forBarMetrics:UIBarMetricsDefault];
//    }
    [self emptyView];
    if (!self.requestArray) {
        self.requestArray=[[NSMutableArray alloc] initWithCapacity:0];
    }

}
-(EmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [self getXibCellWithTitle:@"EmptyView"];
        _emptyView.hidden = YES;
        _emptyView.frame = self.view.bounds;
        _emptyView.backgroundColor =HEXCOLOR(0xeeeeee);
        [_emptyView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapEmptyView)]];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}


-(void)showEmptyViewWithTitle:(NSString *)title
{
    _emptyView.hidden =NO;
    _emptyView.titleLabel.text = title;
    [self.view bringSubviewToFront:_emptyView];
}
-(void)hiddenEmptyView
{
    _emptyView.hidden =YES;
}
-(void)setNbColor
{
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xfb0628);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}
-(void)setTBRedColor
{
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xfb0628);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIBarButtonItem appearance]setBackButtonBackgroundVerticalPositionAdjustment:17 forBarMetrics:UIBarMetricsDefault];

}
-(void)setTBWhiteColor
{
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0XFFFFFF);
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[UIBarButtonItem appearance]setBackButtonBackgroundVerticalPositionAdjustment:17 forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

}
-(void)doloign
{
    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController =lo;
 
    }]];
    [self presentViewController:al animated:YES completion:nil];
}
-(void)refreshForNetworkError
{
    [self startService];
}




#pragma mark-NetService

-(void)loadNewData
{
    [self startService];
}

-(JFANetWorkServiceItem*)getServiceItem
{
    return nil;
}

-(void)startService
{
    [self startServiceWithItem:[self getServiceItem] isShowLoading:NO];
}



-(void)serviceSucceededWithResult:(id)result operation:(NSURLSessionTask*)operation
{
    
}

-(void)serviceFailedWithError:(NSError*)error operation:(NSURLSessionTask*)operation
{
    [self showNetworkError];
}

-(BOOL)isEqualUrl:(NSString*)url forOperation:(NSURLSessionTask*)operation
{
    NSString* operationUrl = [operation.originalRequest.URL absoluteString];
    NSString* eUrl=[NSString stringWithFormat:@"%@%@",[BaseSservice sharedManager].JFADomin,url];
    DLog(@"eUrl==%@  operationUrl==%@",eUrl,operationUrl);
    //    return [eUrl isEqualToString:operationUrl];
    
    if ([operationUrl rangeOfString:eUrl].location != NSNotFound) {
        return YES;
    }
    return NO;
}

-(void)showNetworkError
{
    self.errorView.hidden=YES;
    self.networkErrorView.hidden=NO;
}

-(void)showError
{
    if (_errorView) {
        self.errorView.hidden=NO;
        self.networkErrorView.hidden=YES;
    }
}

-(void)didRefreshInfo
{
    [self BrokenNetworkReconnection];
}
-(void)BrokenNetworkReconnection
{
    DLog(@"看你走不走----断网刷新");
    self.networkErrorView.hidden = YES;
}



-(id)getXibCellWithTitle:(NSString *)title
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:title owner:nil options:nil];
    if (arr) {
        return [arr lastObject];

    }else{
        return nil;
    }
}

-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = HEXCOLOR(0xeeeeee);
    [tb setTableFooterView:view];
}

-(void)dealloc
{
    [self.currentTasks cancel];
}

-(void)setRefrshWithTableView:(UITableView *)tb
{
    
    tb.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [tb.mj_header beginRefreshing];

}
-(void)headerRereshing
{
    
}
-(void)footerRereshing
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showError:(NSString *)text;
{
    errorLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    errorLabel.backgroundColor = RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .5);
    errorLabel.adjustsFontSizeToFitWidth = YES;
    errorLabel.center = self.view.window.center;
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.layer.masksToBounds = YES;
    errorLabel.layer.cornerRadius =4;
    errorLabel.text = text;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view.window addSubview:errorLabel];
    hiddenErrorTimer =   [NSTimer timerWithTimeInterval:2 target:self selector:@selector(hiddenErrirLabel) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:hiddenErrorTimer forMode:NSRunLoopCommonModes];

}


-(void)hiddenErrirLabel
{
    errorLabel.hidden = YES;
    [errorLabel removeFromSuperview];
    [hiddenErrorTimer invalidate];
}


-(void)ChangeMySegmentStyle:(UISegmentedControl*)segment
{
    segment.backgroundColor = [UIColor whiteColor];
    [segment setTintColor:[UIColor whiteColor]];
    [segment setBackgroundImage:[UIImage imageNamed:@"selectImg"]
                            forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,nil];
    
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(0x666666),NSForegroundColorAttributeName,nil];
    [segment setTitleTextAttributes:dics forState:UIControlStateNormal];
    [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    

}



-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(void)refreshEmptyView
{
    
}
-(void)didTapEmptyView
{
    [self refreshEmptyView];
}

-(void)loignSuccessSetRootViewController
{
    if ([[UserModel shareInstance].isPassword isEqualToString:@"1"]||[[UserModel shareInstance].isTradePassword isEqualToString:@"1"]||[[UserModel shareInstance].isNeedParent isEqualToString:@"1"])
    {
        PerfectInformationViewController * per = [[PerfectInformationViewController alloc]init];
        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:per];
        self.view.window.rootViewController = nav;

    }
    else if (![[UserModel shareInstance].isAttest isEqualToString:@"已认证"])
    {
        BodyFatDivisionAgreementViewController * bd = [[BodyFatDivisionAgreementViewController alloc]init];
        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:bd];
        self.view.window.rootViewController = nav;
    }
    else
    {
        TzsTabbarViewController *tab = [[TzsTabbarViewController alloc]init];
        self.view.window.rootViewController = tab;

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
