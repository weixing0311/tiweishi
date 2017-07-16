//
//  ForgetPasswordViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobiletf;
@property (weak, nonatomic) IBOutlet UITextField *vertf;
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;
@property (weak, nonatomic) IBOutlet UITextField *repasswordtf;
@property (weak, nonatomic) IBOutlet UIButton *getVerBtn;

@end

@implementation ForgetPasswordViewController
{
    int timeNumber;
    NSTimer * _timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self setTBRedColor];
    self.mobiletf.keyboardType = UIKeyboardTypeNumberPad;
    self.vertf.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordtf.keyboardType = UIKeyboardTypeDefault;
    self.repasswordtf.keyboardType = UIKeyboardTypeDefault;
    
    self.passwordtf.returnKeyType = UIReturnKeyDone;
    self.passwordtf.secureTextEntry = YES;

    self.repasswordtf.returnKeyType = UIReturnKeyDone;
    self.repasswordtf.secureTextEntry = YES;

    
    self.mobiletf.delegate = self;
    self.vertf.delegate = self;
    self.passwordtf.delegate = self;
    self.repasswordtf.delegate = self;
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)ddClickBack:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didGetVer:(id)sender {
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.getVerBtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.mobiletf.text forKey:@"mobilePhone"];
    [param setObject:@"1" forKey:@"msgType"];
//    短信类型 0注册 1找回密码 2登录 3修改手机号 4 修改交易密码  5 找回交易密码
    self.currentTasks = [[BaseSservice sharedManager]post1:kSendMobileVerUrl paramters:param success:^(NSDictionary *dic) {
        
        NSDictionary *dict = dic;
        NSString * status = [dict objectForKey:@"status"];
        NSString * msg ;
        if (![status isEqualToString:@"success"]) {
            msg =[dic objectForKey:@"message"];
            [_timer invalidate];
            [self.getVerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.getVerBtn.enabled = YES;
            
        }else{
            msg = @"已发送";
        }
        DLog(@"%@",msg);
        [[UserModel shareInstance] showSuccessWithStatus:msg];
        
        
    } failure:^(NSError * error) {
        NSLog(@"faile--%@",error);
        [_timer invalidate];
        [self.getVerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVerBtn.enabled = YES;
        
        NSDictionary *dic = error.userInfo;
        if ([[dic allKeys]containsObject:@"message"]) {
            UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:al animated:YES completion:nil];
            
        }else{
            [[UserModel shareInstance] showErrorWithStatus:@"发送失败"];
        }
        
    }];
    
    DLog(@"点击获取验证码");
}

-(void)refreshTime
{
    if (timeNumber ==0) {
        [_timer invalidate];
        [self.getVerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVerBtn.enabled = YES;
        return;
    }
    NSLog(@"%d",timeNumber);
    [self.getVerBtn setTitle:[NSString stringWithFormat: @"%ld秒后可重新获取",(long)timeNumber] forState:UIControlStateNormal];
    timeNumber --;
}

- (IBAction)didClickUpdate:(id)sender {
    if (self.mobiletf.text.length<11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    
    if (self.vertf.text.length<4) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        return;
    }
    if (self.passwordtf.text.length<6) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入新密码"];
        return;
    }
    if (self.repasswordtf.text.length<6||![self.passwordtf.text isEqualToString:self.repasswordtf.text]) {
        [[UserModel shareInstance] showInfoWithStatus:@"两次密码不一致"];
        return;
    }
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    [param safeSetObject:[NSString encryptString:self.mobiletf.text] forKey:@"mobilePhone"];
    [param safeSetObject:[NSString encryptString:self.passwordtf.text] forKey:@"password"];
    [param safeSetObject:[NSString encryptString:self.repasswordtf.text] forKey:@"repPassword"];
    [param safeSetObject:self.vertf.text forKey:@"vcode"];
    
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/user/findPassword.do" paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
    }];
    
    
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField ==self.passwordtf) {
        [self.passwordtf resignFirstResponder];
        
    }
    
    if (textField ==self.repasswordtf) {
        [self.repasswordtf resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
