//
//  BaseWebViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BaseWebViewController.h"
#import "LoignViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface BaseWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)WKWebView * webView;
@end

@implementation BaseWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];

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

    
    
    
    configuration.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-20) configuration:configuration];
    
    
    
    NSString  * urlss = [kMyBaseUrl stringByAppendingString:self.urlStr];
    NSURL * url  =[NSURL URLWithString:urlss];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    DLog(@"webUrl = %@",url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]] ;
    
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view from its nib.
    

}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    DLog(@"%ld",(long)((NSHTTPURLResponse *)navigationResponse.response).statusCode);
    if (((NSHTTPURLResponse *)navigationResponse.response).statusCode == 200) {
        self.navigationController.navigationBarHidden =YES;
        decisionHandler (WKNavigationResponsePolicyAllow);

    }else {
        self.navigationController.navigationBarHidden =NO;
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
    //发送付款信息
    else if ([message.name isEqualToString:@"getPayInfo"])
    {
        [self sendPayInfo];
    }
    //付款回调
    else if ([message.name isEqualToString:@"payCallBack"])
    {
        [self payCallBack];
    }


}



// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
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


-(void)exit
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) alert:(NSString * )message{
    [[UserModel shareInstance] showInfoWithStatus:message];
 
}

-(void) loading:(NSString * )message{
    [SVProgressHUD showWithStatus:message];

}


-(void)hideLoad
{
    [SVProgressHUD dismiss];
}


-(void)exitToLogin
{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyloignInfo];
        [[UserModel shareInstance]removeAllObject];
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController = lo;
}


-(void)sendPayInfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:[UserModel shareInstance].userId forKey:@"userid"];
    [dic safeSetObject:[UserModel shareInstance].token forKey:@"token"];
    [dic safeSetObject:[UserModel shareInstance].userType forKey:@"userType"];
    [dic safeSetObject:self.orderNo forKey:@"orderNo"];
    [dic safeSetObject:self.payableAmount forKey:@"payableAmount"];
    [dic safeSetObject:@(self.payType) forKey:@"orderType"];
    [dic safeSetObject:@"1" forKey:@"opt"];
    
    
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

-(void)payCallBack
{
    //payCode 1 取消(返回)  2 失败(暂无)  3 余额不足(不管) 4 成功（）
    //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
    
    
    
    
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
