//
//  ResignViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ResignViewController.h"
#import "QRCodeResignViewController.h"
#import "TzsTabbarViewController.h"
@interface ResignViewController ()<qrcodeDelegate,UITextFieldDelegate>
{
    NSTimer   * _timer;
    int         timeNumber;
    BOOL        isupView;

    NSString  * qrCodeInfoStr;//二维码信息
    NSString  * tjrStr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *bgView;

@end

@implementation ResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setNbColor];
    isupView = YES;


    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showkeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)]];


    
    [self.mobiletf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.mobiletf.delegate = self;
    self.mobiletf.returnKeyType = UIReturnKeyGo;
    self.mobiletf.clearButtonMode=UITextFieldViewModeAlways;
    
    self.mobiletf.keyboardType = UIKeyboardTypeNumberPad;
    [self.mobiletf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.vertf.delegate = self;
    self.vertf.keyboardType = UIKeyboardTypeNumberPad;
    self.vertf.returnKeyType = UIReturnKeyGo;
    [self.vertf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.cardTf.delegate = self;
    self.cardTf.clearButtonMode=UITextFieldViewModeAlways;
    self.cardTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.cardTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.passwordtf.delegate = self;
    self.passwordtf.clearButtonMode=UITextFieldViewModeAlways;
    self.passwordtf.keyboardType = UIKeyboardTypeDefault;
    self.passwordtf.returnKeyType = UIReturnKeyDone;
    self.passwordtf.secureTextEntry = YES;

    
}
//返回

- (IBAction)didClickBackToLoign:(id)sender {
    [self bgViewDown];
    [self dismissViewControllerAnimated:YES completion:nil];

}
//跳转扫描二维码
- (IBAction)ScanQrCode:(id)sender {
    [self bgViewDown];
    QRCodeResignViewController * qr = [[QRCodeResignViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:qr];
    qr.delegate = self;
    [self presentViewController:nav animated:YES  completion:nil];
}

#pragma  mark --- 网路请求
- (IBAction)updata:(id)sender {
    [self bgViewDown];
    if (qrCodeInfoStr.length<1&&tjrStr.length!=11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写推荐人"];
        return;
    }
    
    
    if (self.mobiletf.text.length!=11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    if (self.vertf.text.length!=4) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        return;
    }
    if (self.passwordtf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入密码"];
        return;
    }
    
    BOOL isPassword = [self.passwordtf.text checkPassWord];
    
    if (isPassword !=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确格式密码"];
        return;
    }

    
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSString encryptString: self.mobiletf.text] forKey:@"mobilePhone"];
    [param setObject:self.cardTf.text forKey:@"parentId"];
    [param setObject:[NSString encryptString: self.passwordtf.text] forKey:@"password"];
    [param setObject:self.vertf.text forKey:@"vcode"];
    
    [SVProgressHUD show];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/appuser/regsiter.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        
        [[UserModel shareInstance] showSuccessWithStatus:@"注册成功"];
        
        
        [self loIgnWithPassword];
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showErrorWithStatus:@"注册失败"];
    }];
    
}
-(void)loIgnWithPassword
{
    [self bgViewDown];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    [param safeSetObject:[NSString encryptString:self.mobiletf.text] forKey:@"mobilePhone"];
    [param safeSetObject:[NSString encryptString:self.passwordtf.text] forKey:@"password"];
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/loginPwd.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        [SVProgressHUD dismiss];
        //设置Jpush---别名
        [JPUSHService setTags:nil alias:[UserModel shareInstance].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            DLog(@"设置jpush用户id为%@--是否成功-%d",[UserModel shareInstance].userId,iResCode);
        }];
        
        DLog(@"昵称--%@",[[dic objectForKey:@"data"] objectForKey:@"nickName"]);
        [[UserModel shareInstance] showSuccessWithStatus:@"登录成功"];
        [[UserModel shareInstance]setInfoWithDic:[dic objectForKey:@"data"]];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"]objectForKey:@"userId"] forKey:kMyloignInfo];
        
        
        [self loignSuccessSetRootViewController];

//            TzsTabbarViewController *tab = [[TzsTabbarViewController alloc]init];
//            [UserModel shareInstance].tabbarStyle = @"health";
//            self.view.window.rootViewController = tab;
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)getVer:(id)sender {
    
    [self bgViewDown];
    if (self.mobiletf.text.length<11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入正确手机号"];
        return;
    }
    
    
    timeNumber = 59;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.verBtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.mobiletf.text forKey:@"mobilePhone"];
    [param setObject:@"0" forKey:@"msgType"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kSendMobileVerUrl HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
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


-(void)getQrCodeInfo:(NSString * )infoStr
{
    qrCodeInfoStr = infoStr;
    
    
    NSDictionary * dic = [[UserModel shareInstance] getURLParameters:infoStr];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[dic safeObjectForKey:@"recid"] forKey:@"recid"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/appuser/getPhoneByUserId.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        [[UserModel shareInstance]showSuccessWithStatus:@"获取推荐人手机号成功"];
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
        NSString * phone = [dataDic safeObjectForKey:@"phone"];
        self.cardTf .text = phone;
        tjrStr = phone;
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark ------textField ---DELEGATE ----OBJECT------

-(void)showkeyboard:(NSNotification*)noti
{
    if (isupView) {
        isupView = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.contentOffset = CGPointMake(0, 240);
        }];
    }
    
}
-(void)hiddenKeyBoard
{
    [self.mobiletf resignFirstResponder];
    [self.vertf resignFirstResponder];
    [self.cardTf resignFirstResponder];
    [self.passwordtf resignFirstResponder];
    [self.vertf resignFirstResponder];
    
    [self bgViewDown];
    
}
-(void)bgViewDown
{
    isupView = YES;
    [self.mobiletf resignFirstResponder];
    [self.vertf resignFirstResponder];
    [self.cardTf resignFirstResponder];
    [self.passwordtf resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.contentOffset = CGPointMake(0, 0);
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField ==self.mobiletf) {
    }else if(textField==self.passwordtf){
        [self.passwordtf resignFirstResponder];
        [self bgViewDown];

    }else if (textField ==self.cardTf)
    {
        [self.cardTf resignFirstResponder];
        [self bgViewDown];

    }
    return YES;
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.vertf) {
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            [self.vertf resignFirstResponder];
            [self bgViewDown];

        }
    }
    if (textField ==self.mobiletf) {
        if (self.mobiletf.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
            
            [self.mobiletf resignFirstResponder];
            [self bgViewDown];

        }
    }
    if (textField ==self.cardTf) {
        if (self.cardTf.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
            tjrStr = textField.text;
            [self.cardTf resignFirstResponder];
            [self bgViewDown];

        }
    }

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
    
    if (textField ==self.mobiletf||textField ==self.vertf) {
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

@end
