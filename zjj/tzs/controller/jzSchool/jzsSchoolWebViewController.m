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
    if (self.islike ==1) {
        self.zanBtn.selected = YES;
    }else
    {
        self.zanBtn.selected = NO;
    }
    
    if (self.iscollection ==1) {
        self.collectionBtn.selected =YES;
    }
    else
    {
        self.collectionBtn.selected =NO;
  
    }
    self.webView.delegate = self;
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
      col = @"1";
    }else{
        col =@"2";
    }
    [self didCollectionWithNetWithCollection:col];
}

- (IBAction)didZan:(id)sender {
    NSString * islike;
    if (self.zanBtn.selected ==YES) {
        islike =@"1";
    }else{
        islike=@"2";
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/changeIsLike.do" paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:nil];
        DLog(@"dic--%@",dic);
        if (self.zanBtn.selected ==YES) {
            self.zanBtn.selected =NO;
        }else{
            self.zanBtn.selected =YES;
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

    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/changeIsCollection.do" paramters:param success:^(NSDictionary *dic) {
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/changeReadNum.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
    
}

@end
