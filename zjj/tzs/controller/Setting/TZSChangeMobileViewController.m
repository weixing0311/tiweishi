//
//  TZSChangeMobileViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSChangeMobileViewController.h"

@interface TZSChangeMobileViewController ()<UITextFieldDelegate>

@end

@implementation TZSChangeMobileViewController
{
    int timeNumber;
    NSTimer * _timer;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    [self.currentTasks cancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    [self setNbColor];
    self.vertf.delegate = self;
    self.mobileTF.delegate = self;
    [self.mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.vertf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    // Do any additional setup after loading the view from its nib.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pushVer:(id)sender {
    
    if (self.mobileTF.text.length<11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.verBtn.enabled = NO;
 
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.mobileTF.text forKey:@"mobilePhone"];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/changePhoneMsg.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"已发送"];
    } failure:^(NSError *error) {
        [_timer invalidate];
        [self.verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verBtn.enabled = YES;
    }];
    
    
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.vertf) {
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            [self.vertf resignFirstResponder];
        }
    }
    if (textField ==self.mobileTF) {
        if (self.mobileTF.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
            
            [self.mobileTF resignFirstResponder];
        }
    }
}
- (IBAction)didUpdate:(id)sender {
    if (self.oldMobileTf.text.length <11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入注册手机号"];
        return;
    }
  
    if (self.mobileTF.text.length <11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入新手机号"];
        return;
    }
    if (self.vertf.text.length<4) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    if (self.passwordtf.text.length<6) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入密码,密码不能少于6位"];
        return;
    }

    BOOL isPassword = [self.passwordtf.text checkPassWord];
    
    if (isPassword !=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确格式密码"];
        return;
    }

    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId   forKey:@"userId"];
    [param setObject:self.mobileTF.text forKey:@"phone"];
    [param setObject:self.oldMobileTf.text forKey:@"oldPhone"];
    [param setObject:[NSString encryptString: self.passwordtf.text] forKey:@"password"];
    [param setObject:self.vertf.text forKey:@"vcode"];
    [SVProgressHUD show];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/changePhone.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
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


- (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"^[0-9]*$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField ==self.mobileTF||textField ==self.vertf) {
        if ([self isNumText:string]==YES) {
            return YES;
        }else{
            [[UserModel shareInstance]showInfoWithStatus:@"请输入数字"];
            return NO;
            
        }
        
    }
    return YES;
    DLog(@"rang-%@",NSStringFromRange(range));
}


- (void)dealloc
{
    [_timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

@end
