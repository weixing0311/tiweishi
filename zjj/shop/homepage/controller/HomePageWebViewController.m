//
//  HomePageWebViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HomePageWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface HomePageWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)WKWebView * webView;

@end

@implementation HomePageWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章详情";
    [self setTBRedColor];
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"exit"];
    
    configuration.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT) configuration:configuration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;


    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view from its nib.
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    DLog(@"%ld",(long)((NSHTTPURLResponse *)navigationResponse.response).statusCode);
    if (((NSHTTPURLResponse *)navigationResponse.response).statusCode == 200) {
//        self.navigationController.navigationBar.hidden = YES;
        decisionHandler (WKNavigationResponsePolicyAllow);
        
    }else {
//        self.navigationController.navigationBar.hidden = YES;
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"exit"]) {
        [self exit];
    }
}
-(void)exit
{
    [self.navigationController popViewControllerAnimated:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
