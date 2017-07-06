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
#import "MBProgressHUD.h"
@interface LoignViewController ()

@end

@implementation LoignViewController
{
    BOOL isupView;
    NSTimer * _timer;
    NSInteger timeNumber;
    MBProgressHUD * progressHUD;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showkeyboard) name:UIKeyboardWillShowNotification object:nil];
    
    isupView = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)]];
    self.mobileTf.delegate = self;
    self.mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTf.returnKeyType = UIReturnKeyNext;
    
    self.verTF.delegate = self;
    self.verTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verTF.returnKeyType = UIReturnKeyGo;
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

-(void)hiddenKeyBoard
{
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];
    [self bgViewDown];

}

- (IBAction)didLoign:(id)sender {
    
    DLog(@"点击登录");
    [self bgViewDown];
    
    if ([self.mobileTf.text isEqualToString:@""]||[self.mobileTf.text isEqualToString:@" "]||!self.mobileTf.text) {
        [self showHUD:onlyMsg message:@"请输入手机号" detai:nil Hdden:YES];
        return;
    }
    if ([self.verTF.text isEqualToString:@""]||[self.verTF.text isEqualToString:@" "]||!self.verTF.text) {
        [self showHUD:onlyMsg message:@"请输入验证码" detai:nil Hdden:YES];
        return;
    }
    [self showHUD:hotwheels message:@"登录中。。。" detai:nil Hdden:NO];
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:[NSString encryptString:self.mobileTf.text] forKey:@"mobilePhone"];
    [param setObject:self.verTF.text forKey:@"vcode"];
    DLog(@"param--%@",param);
    [[BaseSservice sharedManager]post1:kLoignWithVerUrl paramters:param success:^(NSDictionary *dic) {
        [self hiddenHUD];

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
        [self hiddenHUD];

        NSDictionary *dic = error.userInfo;
        NSString * message ;
        if ([[dic allKeys]containsObject:@"message"]) {
            message =[dic objectForKey:@"message"];
        }else{
         message =@"获取失败";
        }
        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_timer invalidate];
            [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.verbtn.enabled = YES;
            
        }]];
        [self presentViewController:al animated:YES completion:nil];

    }];

    
    
    
}
-(void)showHUD:(HUDType)type message:(NSString*)message detai:(NSString*)detailMsg Hdden:(BOOL)hidden
{
    [super showHUD:type message:message detai:detailMsg Hdden:hidden];
}
-(void)hiddenHUD
{
    [super hiddenHUD];
}


- (IBAction)vxLoign:(id)sender {
    
    DLog(@"点击微信登录");
    [self bgViewDown];
}

- (IBAction)QQloign:(id)sender {
    
    DLog(@"点击QQ登录");
    [self bgViewDown];
}

- (IBAction)getVer:(UIButton *)sender {
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.verbtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.mobileTf.text forKey:@"mobilePhone"];
    [param setObject:@"2" forKey:@"msgType"];
    
    [[BaseSservice sharedManager]post1:kSendMobileVerUrl paramters:param success:^(NSDictionary *dic) {
        
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
        [self showHUD:onlyMsg message:msg detai:nil Hdden:YES];

        
        
    } failure:^(NSError * error) {
        NSLog(@"faile--%@",error);
        NSDictionary *dic = error.userInfo;
        if ([[dic allKeys]containsObject:@"message"]) {
            UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [_timer invalidate];
                [self.verbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.verbtn.enabled = YES;
                
            }]];
            [self presentViewController:al animated:YES completion:nil];
            
        }else{
            [self showHUD:onlyMsg message:@"登录失败" detai:nil Hdden:YES];
            
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
        [UIView animateWithDuration:0.25 animations:^{
            self.bgview.contentOffset = CGPointMake(0, 100);
        }];
    }

}

-(void)bgViewDown
{
    isupView = YES;
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgview.contentOffset = CGPointMake(0, 0);
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField ==self.mobileTf) {
        [self.mobileTf resignFirstResponder];
        [self.verTF becomeFirstResponder];
    }else{
        [self.verTF resignFirstResponder];
        [self didLoign:nil];
    }
    return YES;
}

@end
