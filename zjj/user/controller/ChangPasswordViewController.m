//
//  ChangPasswordViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ChangPasswordViewController.h"

@interface ChangPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *getverbtn;
@property (weak, nonatomic) IBOutlet UITextField *oldpstf;
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;
@property (weak, nonatomic) IBOutlet UITextField *repasswordtf;

@end

@implementation ChangPasswordViewController
{
    int timeNumber;
    NSTimer * _timer;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    [self setTBRedColor];
    self.passwordtf.keyboardType = UIKeyboardTypeDefault;
    self.repasswordtf.keyboardType = UIKeyboardTypeDefault;
    self.passwordtf.returnKeyType = UIReturnKeyDone;
    self.repasswordtf.returnKeyType = UIReturnKeyDone;
    self.oldpstf.returnKeyType = UIReturnKeyDone;
    
    self.repasswordtf.secureTextEntry = YES;
    self.passwordtf.secureTextEntry = YES;
    self.oldpstf.secureTextEntry = YES;

    
    self.passwordtf.delegate = self;
    self.repasswordtf.delegate = self;

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)didUpdata:(id)sender {
    
    if (self.oldpstf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入旧密码"];
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
    [param safeSetObject:[NSString encryptString:self.oldpstf.text] forKey:@"oldPassword"];
    [param safeSetObject:[NSString encryptString:self.passwordtf.text] forKey:@"password"];
    [param safeSetObject:[NSString encryptString:self.repasswordtf.text] forKey:@"repPassword"];
    
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/user/changePassword.do" paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
