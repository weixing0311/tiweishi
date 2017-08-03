//
//  BaseWebViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BaseWebViewController.h"
#import "LoignViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "OrderViewController.h"
#import "TZSDistributionViewController.h"
#import "TZSMyDingGouViewController.h"
#import "TZSDingGouViewController.h"
#import "TZSOrderDetailViewController.h"
#import "TZSDistributionDetailViewController.h"
#import "WXAlipayController.h"
@interface BaseWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIGestureRecognizerDelegate,UIScrollViewDelegate>
@end

@implementation BaseWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.webView stopLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    if (self.rightBtnUrl.length>0) {
        UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithTitle:self.rightBtnTitle style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
        self.navigationItem.rightBarButtonItem = rightitem;
     
    }
    
    
    
    //禁止右划返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
    
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"getHeader"];
    [userContentController addScriptMessageHandler:self name:@"exit"];
    [userContentController addScriptMessageHandler:self name:@"hideLoad"];
    [userContentController addScriptMessageHandler:self name:@"exitToLogin"];
    [userContentController addScriptMessageHandler:self name:@"alert"];
    [userContentController addScriptMessageHandler:self name:@"loading"];
    [userContentController addScriptMessageHandler:self name:@"getSource"];
    [userContentController addScriptMessageHandler:self name:@"getPayInfo"];
    [userContentController addScriptMessageHandler:self name:@"setPayInfo"];
    [userContentController addScriptMessageHandler:self name:@"payCallBack"];
    [userContentController addScriptMessageHandler:self name:@"toReorder"];
    [userContentController addScriptMessageHandler:self name:@"toMyOrderDetail"];
    [userContentController addScriptMessageHandler:self name:@"toForward"];
    
    
    configuration.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-20) configuration:configuration];
    
//    -webkit-overflow-scrolling: touch
    NSString  * urlss = [kMyBaseUrl stringByAppendingString:self.urlStr];
    NSURL * url  =[NSURL URLWithString:urlss];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    DLog(@"webUrl = %@",url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]] ;
    
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view from its nib.
    

}


-(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
 
    
    DLog(@"%ld",(long)((NSHTTPURLResponse *)navigationResponse.response).statusCode);
    if (((NSHTTPURLResponse *)navigationResponse.response).statusCode == 200) {
        decisionHandler (WKNavigationResponsePolicyAllow);

    }else {
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@--%@",message.body,message);
    DLog(@"name--%@",message.name);
    //发送头信息
    if ([message.name isEqualToString:@"getHeader"]) {
        [self getHeader];
        //退出页面
    } else if ([message.name isEqualToString:@"exit"]) {
        [self exit];
    }
    //隐藏Loading
    else if ([message.name isEqualToString:@"hideLoad"]) {
        
        [self hideLoad];
    }
    //退出登录
    else if ([message.name isEqualToString:@"exitToLogin"]) {
        
        [self exitToLogin];
    }
    //显示弹窗
    else if ([message.name isEqualToString:@"alert"]) {
        
        [self alert:message.body];
    }
    //显示loading
    else if ([message.name isEqualToString:@"loading"]) {
        
        [self loading:message.body];
    }
    //发送来源 app web
    else if ([message.name isEqualToString:@"getSource"])
    {
        [self getSource];
    }
    else if ([message.name isEqualToString:@"setPayInfo"]){
        [self setPayInfoWithMessage:message.body];
    }
    //发送付款信息po
    else if ([message.name isEqualToString:@"getPayInfo"])
    {
        [self sendPayInfo];
    }
    //付款回调
    else if ([message.name isEqualToString:@"payCallBack"])
    {
        [self payCallBackWithDict:message.body];
    }
    //跳转订购页面
    else if ([message.name isEqualToString:@"toReorder"])
    {
        [self toReorder];
    }
    //跳转我的订购详情页面
    else if ([message.name isEqualToString:@"toMyOrderDetail"])
    {
        [self toMyOrderDetailWithBody:message.body];
    }
    //跳转页面
    else if ([message.name isEqualToString:@"toForward"])
    {
        [self loadUrlWithDict:message.body];
    }

}


-(void)loadUrlWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        [[UserModel shareInstance]showInfoWithStatus:@"后台参数错误"];
        return;
    }

    if ([[dict objectForKey:@"title"]isEqualToString:@"支付宝支付"]) {
        WXAlipayController  *alipayVC = [[WXAlipayController alloc]init];
        alipayVC.title = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"title"]];
        alipayVC.urlStr = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"url"]];
        [self.navigationController pushViewController:alipayVC animated:YES];
        return;
    }

    
    
    BaseWebViewController * web = [[BaseWebViewController alloc]init];
    web.title  = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"title"]];
    web.urlStr = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"url"]];
    NSString *rightUrl = [dict safeObjectForKey:@"preUrl"];
    NSString * rightTitle =[dict safeObjectForKey:@"preTitle"];
    if (rightUrl.length>0) {
        web.rightBtnUrl =rightUrl;
        web.rightBtnTitle =rightTitle;
    }
    [self.navigationController pushViewController:web animated:YES];
}
-(void)enterRightPage
{
    BaseWebViewController * web = [[BaseWebViewController alloc]init];
    web.title  = self.rightBtnTitle;
    web.urlStr = self.rightBtnUrl;
    [self.navigationController pushViewController:web animated:YES];
}


#pragma mark ----已购服务跳转
/**
 *跳转订购页面
 */
-(void)toReorder
{
    TZSDingGouViewController * td = [[TZSDingGouViewController alloc]init];
    [self.navigationController pushViewController:td animated:YES];
}
-(void)toMyOrderDetailWithBody:(NSDictionary *)body
{
    if (![body isKindOfClass:[NSDictionary class]]) {
        [[UserModel shareInstance]showInfoWithStatus:@"后台参数错误"];
        return;
    }
    int orderType = [[body safeObjectForKey:@"orderType"]intValue];
    NSString * orderNo = [body safeObjectForKey:@"orderNo"];
    
    if (orderType ==1) {
        TZSOrderDetailViewController * md = [[TZSOrderDetailViewController alloc]init];
        md.orderNo = orderNo;
        [self.navigationController pushViewController:md animated:YES];
    }else{
        TZSDistributionDetailViewController * tr = [[TZSDistributionDetailViewController alloc]init];
        tr.orderNo = orderNo;
        [self.navigationController pushViewController:tr animated:YES];
    }
    
    
}



// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSString* reqUrl = webView.URL.absoluteString;
//    DLog(@"%@",reqUrl);
//    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:reqUrl]];
        //bSucc是否成功调起支付宝
//    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [[UserModel shareInstance]showInfoWithStatus:@"加载失败"];
    [self.navigationController popViewControllerAnimated:YES];
}






/**
 * 请求头
 */

-(void) getHeader{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:[UserModel shareInstance].userId forKey:@"userid"];
    [dic safeSetObject:[UserModel shareInstance].token forKey:@"token"];
    [dic safeSetObject:[UserModel shareInstance].userType forKey:@"userType"];
    

    NSString * jsonValue = [self DataTOjsonString:dic];
    NSString *JSResult = [NSString stringWithFormat:@"getUser('%@')",jsonValue];
    
    DLog(@"JSResult ===%@",JSResult);
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@----%@",user, error);
    }];

    
//    return dic;
}

-(void)didClickBack
{
    if ([self.title isEqualToString:@"收银台"]) {
        UIAlertController * al = [ UIAlertController alertControllerWithTitle:@"确认要离开收银台？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleCancel handler:nil]];
        [al addAction: [UIAlertAction actionWithTitle:@"确认离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self backWithPayType];
        }]];
        
        [self presentViewController:al animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 * 退出web页面
 */
-(void)exit
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *弹窗 alert
 */
-(void) alert:(NSString * )message{
    [[UserModel shareInstance] showInfoWithStatus:message];
 
}
/**
 *弹loading
 */
-(void) loading:(NSString * )message{
    [SVProgressHUD showWithStatus:message];

}

/**
 *隐藏loading
 */
-(void)hideLoad
{
    [SVProgressHUD dismiss];
}

/**
 *退出登录
 */
-(void)exitToLogin
{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyloignInfo];
        [[UserModel shareInstance]removeAllObject];
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController = lo;
}
/**
 * 充值
 */
-(void)setPayInfoWithMessage:(NSDictionary *)message
{
    if (![message isKindOfClass:[NSDictionary class]]) {
        [[UserModel shareInstance]showInfoWithStatus:@"后台参数错误"];
        return;
    }

    
    BaseWebViewController * web =[[BaseWebViewController alloc]init];
    web.payType =4;
    web.urlStr=@"app/checkstand.html";
    web.opt =0;
    web.orderNo = [message safeObjectForKey:@"orderNo"];
    web.payableAmount =[message safeObjectForKey:@"payableAmount"];
    [self.navigationController pushViewController:web animated:YES];
    
    
//    NSString  * urlss = [kMyBaseUrl stringByAppendingString:@"app/checkstand.html"];
//    NSURL * url  =[NSURL URLWithString:urlss];
//    DLog(@"webUrl = %@",url);
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]] ;

    

    
}
/**
 *支付上传数据
 */
-(void)sendPayInfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:[UserModel shareInstance].userId forKey:@"userid"];
    [dic safeSetObject:[UserModel shareInstance].token forKey:@"token"];
    [dic safeSetObject:[UserModel shareInstance].userType forKey:@"userType"];
    [dic safeSetObject:self.orderNo forKey:@"orderNo"];
    [dic safeSetObject:self.payableAmount forKey:@"payableAmount"];
    [dic safeSetObject:@(self.payType) forKey:@"orderType"];
    [dic safeSetObject:@(self.opt) forKey:@"opt"];
    
    
    NSString * jsonValue = [self DataTOjsonString:dic];
    NSString * JSResult = [NSString stringWithFormat:@"getOrderInfo('%@')",jsonValue];
    
    DLog(@"JSResult ===%@",JSResult);
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@----%@",user, error);
    }];

}

-(void)getSource
{
    NSString *JSResult = [NSString stringWithFormat:@"getUserSource('app')"];
    
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@----%@",user, error);
    }];

}
/**
 *支付回调
 */
-(void)payCallBackWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        [[UserModel shareInstance]showInfoWithStatus:@"后台参数错误"];
        return;
    }

    //payCode 1 取消(返回)  2 失败(暂无)  3 余额不足(不管) 4 成功（）
    //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
//    orderType = 3;
//    payCode = 4;
    int payCode =[[dict safeObjectForKey:@"payCode"]intValue];

    if (payCode==1) {
        //取消
        [self alert: @"支付取消"];
    }
    else if (payCode ==2)
    {
        [self alert:@"支付失败"];
    }
    else if (payCode ==3)
    {
        [self alert:@"余额不足"];
    }
    else if (payCode ==4)
    {
        [self backWithPayType];
    }
    
}

//支付页面返回方法
-(void)backWithPayType
{
    if (self.payType ==1) {
        for (UIViewController * controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[OrderViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                DLog(@"我曹草草草");
                return ;
            }
        }
        OrderViewController * ordVC = [[OrderViewController alloc]init];
        
        NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arr removeLastObject];
        [arr removeLastObject];
        [arr addObject:ordVC];
        [self.navigationController setViewControllers:arr];
        
    }
    else if (self.payType ==2) {
        for (UIViewController * controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[TZSDistributionViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                DLog(@"我曹草草草");
                return ;
            }
        }
        TZSDistributionViewController * disVC =[[TZSDistributionViewController alloc]init];
        
        NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arr removeLastObject];
        [arr removeLastObject];
        [arr addObject:disVC];
        [self.navigationController setViewControllers:arr];
    }
    else if (self.payType ==3) {
        for (UIViewController * controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[TZSMyDingGouViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                DLog(@"我曹草草草");
                return ;
            }
        }
        TZSMyDingGouViewController * mdVC = [[TZSMyDingGouViewController alloc]init];
        
        NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arr removeLastObject];
        [arr removeLastObject];
        [arr addObject:mdVC];
        [self.navigationController setViewControllers:arr];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
