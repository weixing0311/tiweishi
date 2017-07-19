//
//  LoignViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "LoignViewController.h"
#import "TabbarViewController.h"
#import "ResignAgumentViewController.h"
#import "ChangeUserInfoViewController.h"
#import "TzsTabbarViewController.h"
#import "ForgetPasswordViewController.h"
@interface LoignViewController ()

@end

@implementation LoignViewController
{
    BOOL isupView;
    NSTimer * _timer;
    NSInteger timeNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showkeyboard) name:UIKeyboardWillShowNotification object:nil];
    
    isupView = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)]];
    
    
    
    self.forgetpsBtn.hidden = YES;
    
    
    self.mobileTf.delegate = self;
    self.mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTf.returnKeyType = UIReturnKeyNext;
    
    self.verTF.delegate = self;
    self.verTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verTF.returnKeyType = UIReturnKeyGo;
    [self.verTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.loignMobileTf.delegate = self;
    self.loignMobileTf.keyboardType = UIKeyboardTypeNumberPad;
    self.loignMobileTf.returnKeyType = UIReturnKeyNext;
    self.loignMobileTf.returnKeyType = UIReturnKeyDone;
    
    self.passWordTf.delegate = self;
    self.passWordTf.keyboardType = UIKeyboardTypeDefault;
    self.passWordTf.returnKeyType = UIReturnKeyDone;
    self.passWordTf.secureTextEntry = YES;
    self.verLoignBtn.selected = YES;
    self.psLoignBtn.selected = NO;
    self.passWordView.hidden = YES;
    self.verView.hidden = NO;
    
    // Do any additional setup after loading the view from its nib.
}


-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.verTF) {
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            [self.verTF resignFirstResponder];
        }
    }

}

-(void)hiddenKeyBoard
{
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];
    [self bgViewDown];
}

- (IBAction)pageChange:(UIButton *)sender {
    
    if (sender ==self.verLoignBtn) {
        if (self.verLoignBtn.selected ==YES) {
            return;
        }else{
            self.verView.hidden =NO;
            self.passWordView.hidden = YES;
            self.forgetpsBtn.hidden =YES;

            [self.mobileTf becomeFirstResponder];
            self.verLoignBtn.selected = YES;
            self.psLoignBtn.selected = NO;
        }
    }else{
        if (self.psLoignBtn.selected ==YES) {
            return;
        }else{
            self.verView.hidden =YES;
            self.passWordView.hidden = NO;
            self.forgetpsBtn.hidden =NO;
            
            [self.loignMobileTf becomeFirstResponder];
            self.verLoignBtn.selected = NO;
            self.psLoignBtn.selected = YES;
   
    }
    }
    
    
    
}

-(void)loIgnWithPassword
{
    [self bgViewDown];
    
    if ([self.loignMobileTf.text isEqualToString:@""]||[self.loignMobileTf.text isEqualToString:@" "]||!self.loignMobileTf.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.passWordTf.text isEqualToString:@""]||[self.passWordTf.text isEqualToString:@" "]||!self.passWordTf.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    [param safeSetObject:[NSString encryptString:self.loignMobileTf.text] forKey:@"mobilePhone"];
    [param safeSetObject:[NSString encryptString:self.passWordTf.text] forKey:@"password"];
        
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/loginPwd.do" paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"登录成功"];
        [[UserModel shareInstance]setInfoWithDic:[dic objectForKey:@"data"]];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"]objectForKey:@"userId"] forKey:kMyloignInfo];
        
        
        
        if ([UserModel shareInstance].nickName.length>0) {
            
            TabbarViewController *tab = [[TabbarViewController alloc]init];
            self.view.window.rootViewController = tab;
            
        }else{
            ChangeUserInfoViewController *cg =[[ChangeUserInfoViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cg];
            cg.changeType =1;
            [self presentViewController:nav animated:YES completion:nil];
        }

    } failure:^(NSError *error) {
//        [[UserModel shareInstance] showErrorWithStatus:@"登录失败"];
        [_timer invalidate];
        [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;

    }];
}
-(void)loignWithVer
{
    [self bgViewDown];
    
    if ([self.mobileTf.text isEqualToString:@""]||[self.mobileTf.text isEqualToString:@" "]||!self.mobileTf.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.verTF.text isEqualToString:@""]||[self.verTF.text isEqualToString:@" "]||!self.verTF.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        
        return;
    }
    [SVProgressHUD showWithStatus:@"登录中。。。"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:[NSString encryptString:self.mobileTf.text] forKey:@"mobilePhone"];
    [param setObject:self.verTF.text forKey:@"vcode"];
    DLog(@"param--%@",param);
    self.currentTasks = [[BaseSservice sharedManager]post1:kLoignWithVerUrl paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showSuccessWithStatus:@"登录成功"];
        
        
        [_timer invalidate];
        [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;
        
        
        
        [[UserModel shareInstance]setInfoWithDic:[dic objectForKey:@"data"]];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"]objectForKey:@"userId"] forKey:kMyloignInfo];
        
        
        
        if ([UserModel shareInstance].nickName.length>0) {
            
            TabbarViewController *tab = [[TabbarViewController alloc]init];
            self.view.window.rootViewController = tab;
            
        }else{
            ChangeUserInfoViewController *cg =[[ChangeUserInfoViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cg];
            cg.changeType =1;
            [self presentViewController:nav animated:YES completion:nil];
        }
        
        
        
    } failure:^(NSError *error) {
        
//        [[UserModel shareInstance] showErrorWithStatus:@"登录失败"];
        [_timer invalidate];
        [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;
        
    }];

}

- (IBAction)didLoign:(id)sender {
    
    DLog(@"点击登录");
    
    if (self.verLoignBtn.selected ==YES) {
        [self loignWithVer];
    }else{
        [self loIgnWithPassword];
    }
    
}
-(void)clearTextField
{
    self.mobileTf.text = @"";
    self.verTF.text =@"";
    self.loignMobileTf.text = @"";
    self.passWordTf.text = @"";
}
- (IBAction)forgetPass:(id)sender {
    
    ForgetPasswordViewController * fo = [[ForgetPasswordViewController alloc]init];
//    fo.modalTransitionStyle = UIModalTransitionStylePartialCurl;

    [self presentViewController:fo animated:YES completion:nil];
    
}



- (IBAction)getVer:(UIButton *)sender {
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.verbtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.mobileTf.text forKey:@"mobilePhone"];
    [param setObject:@"2" forKey:@"msgType"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kSendMobileVerUrl paramters:param success:^(NSDictionary *dic) {
        
        NSDictionary *dict = dic;
        NSString * status = [dict objectForKey:@"status"];
        NSString * msg ;
        if (![status isEqualToString:@"success"]) {
            msg =[dic objectForKey:@"message"];
            [_timer invalidate];
            [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.verbtn.enabled = YES;

        }else{
            msg = @"已发送";
        }
        DLog(@"%@",msg);
        [[UserModel shareInstance] showSuccessWithStatus:msg];
        
        
    } failure:^(NSError * error) {
        NSLog(@"faile--%@",error);
        [_timer invalidate];
        [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;

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
        [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;
        return;
    }
    NSLog(@"%d",timeNumber);
    [self.verbtn setTitle:[NSString stringWithFormat: @"%ld秒后可重新获取",(long)timeNumber] forState:UIControlStateNormal];
    timeNumber --;
}
- (IBAction)showResignAugement:(id)sender {
    
    DLog(@"点击查看注册协议");
    [self bgViewDown];

    ResignAgumentViewController * res = [[ResignAgumentViewController alloc]init];
    [self.navigationController pushViewController:res animated:YES];
}


-(void)showkeyboard
{
    
    if (isupView) {
        isupView = NO;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bgview.contentOffset = CGPointMake(0, 100);
//        }];
    }

}

-(void)bgViewDown
{
    isupView = YES;
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];
    [self.loignMobileTf resignFirstResponder];
    [self.passWordTf resignFirstResponder];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.bgview.contentOffset = CGPointMake(0, 0);
//    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField ==self.mobileTf) {
        [self.mobileTf resignFirstResponder];
        [self.verTF becomeFirstResponder];
    }else if(textField==self.passWordTf){
        [self.passWordTf resignFirstResponder];
    }else if (textField ==self.loignMobileTf)
    {
        [self.loignMobileTf resignFirstResponder];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
