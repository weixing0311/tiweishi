//
//  PerfectInformationViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/1/15.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PerfectInformationViewController.h"
#import "QRCodeResignViewController.h"
#import "TzsTabbarViewController.h"
#import "BodyFatDivisionAgreementViewController.h"
#import "LoignViewController.h"
@interface PerfectInformationViewController ()<qrcodeDelegate,UITextFieldDelegate>

@end

@implementation PerfectInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(didLoignOut)];
    self.navigationItem.leftBarButtonItem = item;


    
    UIView * grayView =[[UIView alloc]initWithFrame:self.view.bounds];
    grayView.backgroundColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:grayView];
    [self setTBRedColor];
    
    [self buildSubView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)buildSubView
{
        UIView * firstView = [[UIView alloc]init];
        [self.view addSubview:firstView];
        UIView * secView = [[UIView alloc]init];
        [self.view addSubview:secView];
        UIView * thiView = [[UIView alloc]init];
        [self.view addSubview:thiView];
        UIView * forView = [[UIView alloc]init];
        [self.view addSubview:forView];
        UIView * fivView = [[UIView alloc]init];
        [self.view addSubview:fivView];

    firstView.backgroundColor = [UIColor whiteColor];
    secView.backgroundColor = [UIColor whiteColor];
    thiView.backgroundColor = [UIColor whiteColor];
    forView.backgroundColor = [UIColor whiteColor];
    fivView.backgroundColor = [UIColor whiteColor];

        
        self.mobiletf = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, JFA_SCREEN_WIDTH-70, 40)];
        self.mobiletf.placeholder = @"请添加上级";
        [firstView addSubview:self.mobiletf];
        
        self.qrBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH-70, 0, 79, 60)];
    [self.qrBtn addTarget:self action:@selector(ScanQrCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.qrBtn setImage:getImage(@"reCodeS") forState:UIControlStateNormal];
        [firstView addSubview:self.qrBtn];
        
        
        self.passwordtf = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, JFA_SCREEN_WIDTH-20, 40)];
        self.passwordtf.placeholder = @"登录密码";
        [secView addSubview:self.passwordtf];

        self.rePasswordtf = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, JFA_SCREEN_WIDTH-20, 40)];
        self.rePasswordtf.placeholder = @"重复登录密码";
        [thiView addSubview:self.rePasswordtf];

        self.secondPasswordtf = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, JFA_SCREEN_WIDTH-20, 40)];
        self.secondPasswordtf.placeholder = @"交易密码";
        [forView addSubview:self.secondPasswordtf];

        self.reSecondPasswordtf = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, JFA_SCREEN_WIDTH-20, 40)];
        self.reSecondPasswordtf.placeholder = @"重复交易密码";
        [fivView addSubview:self.reSecondPasswordtf];
    
    
    int h1 =[[UserModel shareInstance].isNeedParent isEqualToString:@"1"]?60:0;
    int h2 =[[UserModel shareInstance].isPassword isEqualToString:@"1"]?60:0;
    int h3 =[[UserModel shareInstance].isTradePassword isEqualToString:@"1"]?60:0;

    
    firstView.frame = CGRectMake(0, 70, JFA_SCREEN_WIDTH, 60);
    secView.frame =CGRectMake(0, 70+h1+1, JFA_SCREEN_WIDTH, 60);
    thiView.frame =CGRectMake(0, 70+h1+h2+2, JFA_SCREEN_WIDTH, 60);
    forView.frame =CGRectMake(0, 70+h1+h2*2+3, JFA_SCREEN_WIDTH, 60);
    fivView.frame =CGRectMake(0, 70+h1+h2*2+h3+4, JFA_SCREEN_WIDTH, 60);

    

    
    firstView.hidden =[[UserModel shareInstance].isNeedParent isEqualToString:@"1"]?NO:YES;
    secView.hidden   =[[UserModel shareInstance].isPassword   isEqualToString:@"1"]?NO:YES;
    thiView.hidden   =[[UserModel shareInstance].isPassword   isEqualToString:@"1"]?NO:YES;
    forView.hidden   =[[UserModel shareInstance].isTradePassword isEqualToString:@"1"]?NO:YES;
    fivView.hidden   =[[UserModel shareInstance].isTradePassword isEqualToString:@"1"]?NO:YES;
    _qrBtn.hidden    =[[UserModel shareInstance].isNeedParent isEqualToString:@"1"]?NO:YES;
    
    
    UIButton * updataBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, fivView.frame.origin.y+90, JFA_SCREEN_WIDTH-40, 45)];
    [updataBtn setBackgroundColor:[UIColor redColor]];
    [updataBtn setTitle:@"提交" forState:UIControlStateNormal];
    [updataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updataBtn addTarget:self action:@selector(updata:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updataBtn];
}





- (void)ScanQrCode:(id)sender {
    [self bgViewDown];
    QRCodeResignViewController * qr = [[QRCodeResignViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:qr];
    qr.delegate = self;
    [self presentViewController:nav animated:YES  completion:nil];
}

- (void)updata:(id)sender
{
    [self bgViewDown];
    if (self.mobiletf.text.length<1&&self.mobiletf.text.length!=11&&[[UserModel shareInstance].isNeedParent isEqualToString:@"1"]) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写推荐人"];
        return;
    }
    
    
    
    if (self.passwordtf.text.length<6&&[[UserModel shareInstance].isPassword isEqualToString:@"1"]) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入登录密码，密码大于6位"];
        return;
    }
    if (self.secondPasswordtf.text.length!=6&&[[UserModel shareInstance].isTradePassword isEqualToString:@"1"]) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入6位数字交易密码"];
        return;
    }
    
    BOOL isPassword = [self.passwordtf.text checkPassWord];
    
    if (isPassword !=YES&&[[UserModel shareInstance].isPassword isEqualToString:@"1"]) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确格式密码"];
        return;
    }
    
    if (![self.passwordtf.text isEqualToString:self.rePasswordtf.text]&&[[UserModel shareInstance].isPassword isEqualToString:@"1"]) {
        [[UserModel shareInstance]showInfoWithStatus:@"登录密码不一致"];
        return;
    }
    if (![self.secondPasswordtf.text isEqualToString:self.reSecondPasswordtf.text]&&[[UserModel shareInstance].isTradePassword isEqualToString:@"1"]) {
        [[UserModel shareInstance]showInfoWithStatus:@"两次交易密码不一致"];
        return;
    }

    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    if ([[UserModel shareInstance].isNeedParent isEqualToString:@"1"]) {
        [param safeSetObject:[NSString encryptString: self.mobiletf.text] forKey:@"phone"];

    }
    
    if ([[UserModel shareInstance].isPassword isEqualToString:@"1"]) {
        [param safeSetObject:[NSString encryptString: self.passwordtf.text] forKey:@"password"];
        [param safeSetObject:[NSString encryptString: self.rePasswordtf.text] forKey:@"repeatPassword"];

    }
    if ([[UserModel shareInstance].isTradePassword isEqualToString:@"1"]) {
        [param safeSetObject:[NSString encryptString: self.secondPasswordtf.text] forKey:@"tranPass"];
        [param safeSetObject:[NSString encryptString: self.reSecondPasswordtf.text] forKey:@"repeatTranPass"];
    }

    
    [SVProgressHUD show];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/newUserPerfectData.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        
        [[UserModel shareInstance] showSuccessWithStatus:@"添加成功"];
        
        
        if ([[UserModel shareInstance].isAttest isEqualToString:@"已认证"]) {
            TzsTabbarViewController * bd =[[TzsTabbarViewController alloc]init];
            [self.view.window setRootViewController:bd];

        
        }else{
            BodyFatDivisionAgreementViewController * bd =[[BodyFatDivisionAgreementViewController alloc]init];
            [self.navigationController pushViewController:bd animated:YES];
        }
        
        
        
        
    } failure:^(NSError *error) {
    }];

}
-(void)getQrCodeInfo:(NSString * )infoStr
{
    
    
    NSDictionary * dic = [[UserModel shareInstance] getURLParameters:infoStr];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[dic safeObjectForKey:@"recid"] forKey:@"recid"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/appuser/getPhoneByUserId.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        [[UserModel shareInstance]showSuccessWithStatus:@"获取推荐人手机号成功"];
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
        NSString * phone = [dataDic safeObjectForKey:@"phone"];
        self.mobiletf .text = phone;
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)bgViewDown
{
    [self.mobiletf resignFirstResponder];
    [self.passwordtf resignFirstResponder];
    [self.secondPasswordtf resignFirstResponder];
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField ==self.mobiletf) {
        if (self.mobiletf.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
            
            [self.mobiletf resignFirstResponder];
            [self bgViewDown];
            
        }
    }
    if (textField ==self.secondPasswordtf) {
        if (self.secondPasswordtf.text.length>=6) {
            textField.text = [textField.text substringToIndex:11];
            [self.secondPasswordtf resignFirstResponder];
            [self bgViewDown];
            
        }
    }
    
}
-(void)didLoignOut
{
    [[UserModel shareInstance]removeAllObject];
    LoignViewController *lo = [[LoignViewController alloc]init];
    self.view.window.rootViewController = lo;
    
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
