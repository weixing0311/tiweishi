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
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString encryptString: self.passwordtf.text] forKey:@"oldPassword"];
    [param setObject:[NSString encryptString: self.thenewPasswordtf.text] forKey:@"password"];
    [param setObject:[NSString encryptString: self.repasswordtf.text] forKey:@"repPassword"];
    
    [SVProgressHUD show];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/changePassword.do" paramters:param success:^(NSDictionary *dic) {
//        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
    }];
}
@end
