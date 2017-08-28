//
//  BodyFatDivisionAgreementViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BodyFatDivisionAgreementViewController.h"
#import "RealNameAuthenticationViewController.h"
#import "HomePageWebViewController.h"
@interface BodyFatDivisionAgreementViewController ()

@end

@implementation BodyFatDivisionAgreementViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    self.title = @"脂将军体脂师合作协议";
    // Do any additional setup after loading the view from its nib.
}
//行为规范
- (IBAction)xwgf:(id)sender {
    HomePageWebViewController * web =[[HomePageWebViewController alloc]init];
    web.title = @"脂将军体脂管理师服务行为规范";
    web.urlStr = [NSString stringWithFormat:@"%@app/protocolGuiFan.html",kMyBaseUrl];
    [self.navigationController pushViewController:web animated:YES];
}
//退换规范
- (IBAction)thgf:(id)sender {
    HomePageWebViewController * web =[[HomePageWebViewController alloc]init];
    web.title = @"脂将军体脂管理辅助用品退换规则";
    web.urlStr = [NSString stringWithFormat:@"%@app/protocolTuiHuan.html",kMyBaseUrl];
    [self.navigationController pushViewController:web animated:YES];

}




- (IBAction)IAgree:(id)sender {
//    if (self.readBtn.selected ==NO) {
//        [[UserModel shareInstance] showInfoWithStatus:@"请阅读协议"];
//        return;
//    }
    RealNameAuthenticationViewController *rn = [[RealNameAuthenticationViewController alloc]init];
    [self.navigationController pushViewController:rn animated:YES];
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
