//
//  jzsSchoolWebViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "jzsSchoolWebViewController.h"
@interface jzsSchoolWebViewController ()

@end

@implementation jzsSchoolWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getReadNum];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章详情";
    [self setNbColor];
    
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_"] style:UIBarButtonItemStylePlain target:self action:@selector(didShare)];
    self.navigationItem.rightBarButtonItem = item;

    
    
    
    
    [self.zanBtn setTitle:[NSString stringWithFormat:@"点赞(%@)",self.isLikeNum?self.isLikeNum:@""] forState:UIControlStateNormal];
    if ([self.islike isEqualToString:@"1" ]) {
        self.zanBtn.selected = YES;
    }else
    {
        self.zanBtn.selected = NO;
    }
    
    if ([self.iscollection isEqualToString:@"1"]) {
        self.collectionBtn.selected =YES;
    }
    else
    {
        self.collectionBtn.selected =NO;
  
    }
    self.webView.delegate = self;
    _webView.scrollView.bouncesZoom = NO;
    _webView.scrollView.bounces = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];

    [SVProgressHUD showWithStatus:@"加载中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    // Do any additional setup after loading the view from its nib.
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
        [shareParams SSDKSetupWeChatParamsByText:@"" title:self.shareTitle url:[NSURL URLWithString:self.urlStr] thumbImage:self.shareImage image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        
    }else if (type==SSDKPlatformTypeQQ)
    {
        [shareParams SSDKSetupShareParamsByText:@""
                                         images:self.shareImage
                                            url:[NSURL URLWithString:self.urlStr]
                                          title:self.shareTitle
                                           type:SSDKContentTypeWebPage];
        
        //        [shareParams SSDKSetupQQParamsByText:self.contentStr title:self.titleStr url:[NSURL URLWithString:self.urlStr] thumbImage:_imageUrl image:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
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

- (IBAction)didCollection:(id)sender {
    
    NSString * col ;
    if (self.collectionBtn.selected==YES) {
      col = @"0";
    }else{
        col =@"1";
    }
    [self didCollectionWithNetWithCollection:col];
}

- (IBAction)didZan:(id)sender {
    NSString * islike;
    if (self.zanBtn.selected ==YES) {
        islike =@"0";
    }else{
        islike=@"1";
    }
    [self didZanWithNetWithLike:islike];
}
/**
 *  上传点赞/取消点赞
 */
-(void)didZanWithNetWithLike:(NSString *)like
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:@(self.informateId) forKey:@"informateId"];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:like forKey:@"isLike"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/changeIsLike.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:nil];
        DLog(@"dic--%@",dic);
        if (self.zanBtn.selected ==YES) {
            self.zanBtn.selected =NO;
            [self.zanBtn setTitle:[NSString stringWithFormat:@"点赞(%@)",self.isLikeNum?@([self.isLikeNum intValue]-1):@""] forState:UIControlStateNormal];
            self.isLikeNum =[NSString stringWithFormat:@"%d",[self.isLikeNum intValue]-1];
        }else{
            self.zanBtn.selected =YES;
            [self.zanBtn setTitle:[NSString stringWithFormat:@"点赞(%@)",self.isLikeNum?@([self.isLikeNum intValue]+1):@""] forState:UIControlStateNormal];
            self.isLikeNum =[NSString stringWithFormat:@"%d",[self.isLikeNum intValue]+1];

        }
    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:nil];
        DLog(@"error--%@",error);
    }];
    

}
/**
 * 上传收藏/取消收藏
 */
-(void)didCollectionWithNetWithCollection:(NSString *)col
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:@(self.informateId) forKey:@"informateId"];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:col forKey:@"isCollection"];

    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/changeIsCollection.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);
        [[UserModel shareInstance] showSuccessWithStatus:nil];
        if (self.collectionBtn.selected ==YES) {
            self.collectionBtn.selected =NO;
        }else{
            self.collectionBtn.selected =YES;
        }

    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:nil];
        DLog(@"error--%@",error);
    }];
    
 
}
/*
 !- 上传文章阅读数量
 */
-(void)getReadNum
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:@(self.informateId) forKey:@"informateId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/changeReadNum.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
    
}

@end
