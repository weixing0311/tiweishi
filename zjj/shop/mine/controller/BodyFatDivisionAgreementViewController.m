//
//  BodyFatDivisionAgreementViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BodyFatDivisionAgreementViewController.h"
#import "RealNameAuthenticationViewController.h"
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
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)alredyRead:(id)sender {
    if (self.readBtn.selected ==YES) {
        self.readBtn.selected = NO;
    }else{
        self.readBtn.selected = YES;
    }
    
}

- (IBAction)IAgree:(id)sender {
    if (self.readBtn.selected ==NO) {
        [[UserModel shareInstance] showInfoWithStatus:@"请阅读协议"];
        return;
    }
    RealNameAuthenticationViewController *rn = [[RealNameAuthenticationViewController alloc]init];
    [self.navigationController pushViewController:rn animated:YES];
}
@end
