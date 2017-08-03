//
//  WXAlipayController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WXAlipayController.h"

@interface WXAlipayController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation WXAlipayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-64)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[kMyBaseUrl stringByAppendingString:self.urlStr]]]];
    // Do any additional setup after loading the view.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [webView.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlStr containsString:@"alipays://"]) {
        
        NSRange range = [urlStr rangeOfString:@"alipays://"]; //截取的字符串起始位置
        NSString * resultStr = [urlStr substringFromIndex:range.location]; //截取字符串
        
        NSURL *alipayURL = [NSURL URLWithString:resultStr];
        
        [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
            
        }];
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
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
