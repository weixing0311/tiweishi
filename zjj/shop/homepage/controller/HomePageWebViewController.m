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

@interface HomePageWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;

@end

@implementation HomePageWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    
    
    if (self.isShare==YES) {
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_"] style:UIBarButtonItemStylePlain target:self action:@selector(didShare)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"exit"];
    
    configuration.userContentController = userContentController;
    
    

    
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
//    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT) configuration:configuration];
//    self.webView.UIDelegate = self;
//    self.webView.navigationDelegate = self;
//    self.webView.allowsBackForwardNavigationGestures = YES;
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT)];

    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.delegate = self;
    self.webView.delegate = self;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view from its nib.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
-(void)didShare
{
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"分享" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline ];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession ];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ ];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];
}
-(void) shareWithType:(SSDKPlatformType)type
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    if (type ==SSDKPlatformSubTypeWechatTimeline||type==SSDKPlatformSubTypeWechatSession) {
        [shareParams SSDKSetupWeChatParamsByText:self.contentStr title:self.titleStr url:[NSURL URLWithString:self.urlStr] thumbImage:_imageUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        
    }else if (type==SSDKPlatformTypeQQ)
    {
        [shareParams SSDKSetupShareParamsByText:self.contentStr
                                         images:_imageUrl
                                            url:[NSURL URLWithString:self.urlStr]
                                          title:self.titleStr
                                           type:SSDKContentTypeWebPage];

    }
    
    
    
    [shareParams SSDKEnableUseClientShare];
    [SVProgressHUD showWithStatus:@"开始分享"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                 DLog(@"error-%@",error);
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                 break;
             }
             default:
                 break;
         }
     }];
    
}

#pragma  mark ---uiwebview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [_webView stringByEvaluatingJavaScriptFromString:js];
    [_webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UserModel shareInstance]showInfoWithStatus:@"页面加载失败"];
}




#pragma mark ---wkwebviewdelegate

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
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];

    
    [ webView evaluateJavaScript:@"var script = document.createElement('script');"
     
     "script.type = 'text/javascript';"
     
     "script.text = \"function ResizeImages() { "
     
     "var myimg,oldwidth;"
     
     "var maxwidth = 300;" // UIWebView中显示的图片宽度
     
     "for(i=1;i <document.images.length;i++){"
     
     "myimg = document.images[i];"
     
     "oldwidth = myimg.width;"
     
     "myimg.width = maxwidth;"
     
     "}"
     
     "}\";"
     
     "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();" completionHandler:nil];
    
    
    [self remoViewCookies];
    
    
}// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [[UserModel shareInstance]showInfoWithStatus:@"加载失败"];
    [self.navigationController popViewControllerAnimated:YES];
}

//清除WK缓存，否则H5界面跟新，这边不会更新
-(void)remoViewCookies{
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=9.0) {
        //        - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation 中就成功了 。
        //    然而我们等到了iOS9！！！没错！WKWebView的缓存清除API出来了！代码如下：这是删除所有缓存和cookie的
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }else{
        //iOS8清除缓存
        NSString * libraryPath =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString * cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
