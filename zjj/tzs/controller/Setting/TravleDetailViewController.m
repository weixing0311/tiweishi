//
//  TravleDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/1/18.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TravleDetailViewController.h"

@interface TravleDetailViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation TravleDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    //    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    self.view.backgroundColor =[UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 70, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-70)];
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@app/fatTeacher/tourismActivity.html",kMyBaseUrl]]]];
    self.webView.delegate = self;
    
    // Do any additional setup after loading the view.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
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
