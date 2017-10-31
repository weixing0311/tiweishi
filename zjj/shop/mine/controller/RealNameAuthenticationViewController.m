//
//  RealNameAuthenticationViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "RealNameAuthenticationViewController.h"
#import "TzsTabbarViewController.h"
@interface RealNameAuthenticationViewController ()

@end

@implementation RealNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTBRedColor];
    self.title = @"实名认证";
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)]];
    // Do any additional setup after loading the view from its nib.
}
-(void)hiddenKeyboard
{
    [self.nameTF resignFirstResponder];
    [self.sfzTf resignFirstResponder];
}
-(void)updataInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safeSetObject:self.sfzTf.text forKey:@""];
    [param setObject:self.nameTF.text forKey:@""];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@" " HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        if ([[dic objectForKey:@"status"]isEqualToString:@"success"]) {
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateInfo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param setObject:self.nameTF.text forKey:@"userName"];
    [param setObject:[NSString encryptString: self.sfzTf.text] forKey:@"userCode"];
    [SVProgressHUD showWithStatus: @"认证中。。"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/user/attestation.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        [[UserModel shareInstance] didAttestSuccessWithDict:dataDict];
        [[UserModel shareInstance] showSuccessWithStatus:@"认证成功"];

        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"SettingViewController")]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                return ;
            }
        }
        
        TzsTabbarViewController *tzs =[[TzsTabbarViewController alloc]init];
        self.view.window.rootViewController = tzs;
    } failure:^(NSError *error) {
    }];
}
- (IBAction)didRz:(id)sender {
    if (self.nameTF.text.length<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入姓名"];
        
        return;
    }
    if (self.sfzTf.text.length<15) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入身份证号"];
        return;
    }
    [self updateInfo];
    
    
}

@end
