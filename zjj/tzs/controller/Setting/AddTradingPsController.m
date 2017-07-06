//
//  AddTradingPsController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/5.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddTradingPsController.h"

@interface AddTradingPsController ()

@end

@implementation AddTradingPsController
{
    BOOL firstSelected;
    BOOL secondSelected;
    BOOL thirdSelected;
    BOOL forthSelected;
    BOOL fiveSelected;
    BOOL sexSelected;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加交易密码";
    [self setNbColor];
//    self.passwordTf.hidden = YES;
    self.passwordTf.delegate = self;
    self.passwordTf.keyboardType =UIKeyboardTypeNumberPad;
    [self.passwordTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    ^[0-9]*$
    
    
    
    
    [self.passwordTf becomeFirstResponder];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)updateInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString * passwordStr = [NSString encryptString:self.passwordTf.text];
    [param safeSetObject:[UserModel shareInstance].userId  forKey:@"userId"];
    [param safeSetObject:passwordStr forKey:@"tradePwd"];
    [[BaseSservice sharedManager]post1:@"app/walletManagement/addUserTradePwd.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"%@",dic);
        [self showError:@"设置成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        DLog(@"%@",error);

        [self showError:@"设置失败"];
    }];
}




-(void)setimageStatus
{
    firstSelected =NO;
    secondSelected =NO;
    thirdSelected=NO;
    forthSelected=NO;
    fiveSelected=NO;
    sexSelected=NO;
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    if (self.passwordTf.text.length==6) {
        [self.passwordTf resignFirstResponder];
        [self updateInfo];
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0)
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length==6) {
        return NO;
    }
    if ([self isNumText:string]==YES) {
        [self setImageWithRange:range];
    }
    DLog(@"rang-%@",NSStringFromRange(range));
    DLog(@"string-%@",string);
    return [self isNumText:string];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

-(void)setImageWithRange:(NSRange)range
{
    if (range.location==0) {
        if (firstSelected ==YES ) {
            firstSelected =NO;
            self.fsImageView.image = [UIImage imageNamed:@"passw_kong"];
        }else{
            firstSelected = YES;
            self.fsImageView.image = [UIImage imageNamed:@"passw_have"];
        }
    }
    if (range.location==1) {
        if (secondSelected ==YES) {
            secondSelected =NO;
            self.secImageView.image = [UIImage imageNamed:@"passw_kong"];
        }else{
            secondSelected=YES;
            self.secImageView.image = [UIImage imageNamed:@"passw_have"];
        }

    }
    
    if (range.location==2) {
        if (thirdSelected ==YES ) {
            thirdSelected =NO;
            self.thiImageView.image = [UIImage imageNamed:@"passw_kong"];
        }else{
            thirdSelected=YES;
            self.thiImageView.image = [UIImage imageNamed:@"passw_have"];
        }

    }
    
    if (range.location==3) {
        if (forthSelected ==YES ) {
            forthSelected =NO;
            self.forImageView.image = [UIImage imageNamed:@"passw_kong"];
        }else{
            forthSelected=YES;
            self.forImageView.image = [UIImage imageNamed:@"passw_have"];
           
        }

    }
    
    if (range.location==4) {
        if (fiveSelected ==YES ) {
            fiveSelected=NO;
            self.fifImageView.image = [UIImage imageNamed:@"passw_kong"];
        }else{
            fiveSelected= YES;
            self.fifImageView.image = [UIImage imageNamed:@"passw_have"];
        }

    }
    if (range.location==5) {
        if (sexSelected==YES ) {
            sexSelected =NO;
            self.sexImageView.image = [UIImage imageNamed:@"passw_kong"];
        }else{
            sexSelected=YES;
            self.sexImageView.image = [UIImage imageNamed:@"passw_have"];
            
        }

    }
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
