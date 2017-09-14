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
#import "JPUSHService.h"
#import "ResignViewController.h"
@interface LoignViewController ()

@end

@implementation LoignViewController
{
    BOOL isupView;
    NSTimer * _timer;
    NSInteger timeNumber;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self bgViewDown];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showkeyboard) name:UIKeyboardWillShowNotification object:nil];
    
    isupView = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)]];
    
    
    
    self.forgetpsBtn.hidden = YES;
    
    
    self.mobileTf.delegate = self;
    self.mobileTf.returnKeyType = UIReturnKeyGo;
    self.mobileTf.clearButtonMode=UITextFieldViewModeAlways;

    self.mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.mobileTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.verTF.delegate = self;
    self.verTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verTF.returnKeyType = UIReturnKeyGo;
    [self.verTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.loignMobileTf.delegate = self;
    self.loignMobileTf.clearButtonMode=UITextFieldViewModeAlways;
    self.loignMobileTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.loignMobileTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.passWordTf.delegate = self;
    self.passWordTf.clearButtonMode=UITextFieldViewModeAlways;
    self.passWordTf.keyboardType = UIKeyboardTypeDefault;
    self.passWordTf.returnKeyType = UIReturnKeyDone;
    self.passWordTf.secureTextEntry = YES;
    
    
    self.verLoignBtn.selected = NO;
    self.psLoignBtn.selected = YES;
    self.passWordView.hidden = NO;
    self.verView.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
}




-(void)hiddenKeyBoard
{
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];
    [self.loignMobileTf resignFirstResponder];
    [self.passWordTf resignFirstResponder];
//    [self bgViewDown];
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
    
    
    BOOL isPassword = [self.passWordTf.text checkPassWord];
    
    if (isPassword !=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确格式密码"];
        return;
    }
    
    
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    [param safeSetObject:[NSString encryptString:self.loignMobileTf.text] forKey:@"mobilePhone"];
    [param safeSetObject:[NSString encryptString:self.passWordTf.text] forKey:@"password"];
        
    [SVProgressHUD showWithStatus:@"登录中..."];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/loginPwd.do" paramters:param success:^(NSDictionary *dic) {
        
        [SVProgressHUD dismiss];
        //设置Jpush---别名
        [JPUSHService setTags:nil alias:[UserModel shareInstance].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            DLog(@"设置jpush用户id为%@--是否成功-%d",[UserModel shareInstance].userId,iResCode);
        }];

        DLog(@"昵称--%@",[[dic objectForKey:@"data"] objectForKey:@"nickName"]);
        [[UserModel shareInstance] showSuccessWithStatus:@"登录成功"];
        [[UserModel shareInstance]setInfoWithDic:[dic objectForKey:@"data"]];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"]objectForKey:@"userId"] forKey:kMyloignInfo];
        
        
        
        if ([UserModel shareInstance].nickName.length>0) {
            
            if ([[UserModel shareInstance].userType isEqualToString:@"2"]) {
                [[UserModel shareInstance]getNotiadvertising];
            }

            TabbarViewController *tab = [[TabbarViewController alloc]init];
            self.view.window.rootViewController = tab;
            
            
        }else{
            ChangeUserInfoViewController *cg =[[ChangeUserInfoViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cg];
            cg.changeType =1;
            [self presentViewController:nav animated:YES completion:nil];
        }

    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
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
    
//    if (isupView) {
//        isupView = NO;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bgview.contentOffset = CGPointMake(0, 240);
//        }];
//    }

}

-(void)bgViewDown
{
    return;
    isupView = YES;
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];
    [self.loignMobileTf resignFirstResponder];
    [self.passWordTf resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgview.contentOffset = CGPointMake(0, 0);
    }];

}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.verTF) {
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            [self.verTF resignFirstResponder];
        }
    }
    if (textField ==self.mobileTf) {
        if (self.mobileTf.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];

            [self.mobileTf resignFirstResponder];
        }
    }
    if (textField ==self.loignMobileTf) {
        if (self.loignMobileTf.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
            
            [self.loignMobileTf resignFirstResponder];
        }
    }
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField ==self.mobileTf) {
////        [self.mobileTf resignFirstResponder];
////        [self.verTF becomeFirstResponder];
//    }else if(textField==self.passWordTf){
//        [self.passWordTf resignFirstResponder];
//    }else if (textField ==self.loignMobileTf)
//    {
//        [self.loignMobileTf resignFirstResponder];
//    }
//    return YES;
//}
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
    
    if (textField ==self.mobileTf||textField ==self.loignMobileTf||textField ==self.verTF) {
//        if (textField.text.length==11) {
//            return NO;
//        }
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


- (IBAction)didResign:(id)sender {
    ResignViewController * rl = [[ResignViewController alloc]init];
    [self presentViewController:rl animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
