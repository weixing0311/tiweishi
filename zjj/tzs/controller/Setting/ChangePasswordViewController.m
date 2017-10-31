//
//  ChangePasswordViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self setNbColor];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)updata:(id)sender {
    
    if (self.passwordtf.text.length<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请填写旧密码"];
        return;
    }
    if (self.repasswordtf.text.length<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请填写新密码"];

        return;
    }
    if (self.thenewPasswordtf.text.length<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请重复填写新密码"];

        return;
    }
    
    BOOL isPassword = [self.thenewPasswordtf.text checkPassWord];
    
    if (isPassword !=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确格式密码"];
        return;
    }

    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString encryptString: self.passwordtf.text] forKey:@"oldPassword"];
    [param setObject:[NSString encryptString: self.thenewPasswordtf.text] forKey:@"password"];
    [param setObject:[NSString encryptString: self.repasswordtf.text] forKey:@"repPassword"];
    
    [SVProgressHUD show];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/changePassword.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
//        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
    }];
}
@end
