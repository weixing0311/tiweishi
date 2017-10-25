//
//  ForgetJYpasswordViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ForgetJYpasswordViewController.h"

@interface ForgetJYpasswordViewController ()

@end

@implementation ForgetJYpasswordViewController
{
    NSTimer   * _timer;
    int timeNumber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记交易密码";
    [self setNbColor];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)updata:(id)sender {
    if (self.cardTf.text.length <1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入银行卡号"];
        return;
    }
    if (self.mobiletf.text.length<11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    if (self.vertf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        return;
    }
    if (self.passwordtf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入密码"];
        return;
    }
    if (self.repasswordtf.text.length<1||![self.repasswordtf.text isEqualToString:self.passwordtf.text]) {
        [[UserModel shareInstance] showInfoWithStatus:@"两次密码不一致"];
        return;
    }
    
    BOOL isPassword = [self.passwordtf.text checkPassWord];
    
    if (isPassword !=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确格式密码"];
        return;
    }

    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString encryptString:self.mobiletf.text] forKey:@"mobilePhone"];
    [param setObject:self.cardTf.text forKey:@"accountNo"];
    [param setObject:[NSString encryptString: self.passwordtf.text] forKey:@"password"];
    [param setObject:[NSString encryptString: self.repasswordtf.text] forKey:@"repPassword"];
    [param setObject:self.vertf.text forKey:@"vcode"];
    
    [SVProgressHUD show];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/findTradePassword.do" paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        
        [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
    }];
    
}

- (IBAction)getVer:(id)sender {
    
    if (self.mobiletf.text.length<11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.verBtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.mobiletf.text forKey:@"mobilePhone"];
    [param setObject:@"5" forKey:@"msgType"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kSendMobileVerUrl paramters:param success:^(NSDictionary *dic) {
        
        [[UserModel shareInstance] showSuccessWithStatus:@"已发送"];
    } failure:^(NSError * error) {
        [_timer invalidate];
        [self.verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verBtn.enabled = YES;
    }];
    
}
-(void)refreshTime
{
    if (timeNumber ==0) {
        [_timer invalidate];
        [self.verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verBtn.enabled = YES;
        return;
    }
    NSLog(@"%d",timeNumber);
    [self.verBtn setTitle:[NSString stringWithFormat: @"%ld秒后可重新获取",(long)timeNumber] forState:UIControlStateNormal];
    timeNumber --;
}

@end
