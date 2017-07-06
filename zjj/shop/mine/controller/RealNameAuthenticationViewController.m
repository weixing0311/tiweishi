//
//  RealNameAuthenticationViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "RealNameAuthenticationViewController.h"
#import "TzsTabbarViewController.h"
@interface RealNameAuthenticationViewController ()

@end

@implementation RealNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)]];
    // Do any additional setup after loading the view from its nib.
}
-(void)hiddenKeyboard
{
    [self.nameTF resignFirstResponder];
    [self.sfzTf resignFirstResponder];
}
-(void)updataInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safeSetObject:self.sfzTf.text forKey:@""];
    [param setObject:self.nameTF.text forKey:@""];
    
    [[BaseSservice sharedManager]post1:@"" paramters:param success:^(NSDictionary *dic) {
        
        if ([[dic objectForKey:@"status"]isEqualToString:@"success"]) {
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateInfo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param setObject:self.nameTF.text forKey:@"userName"];
    [param setObject:self.sfzTf.text forKey:@"userCode"];
    [self showHUD:hotwheels message:nil detai:@"认证中。。" Hdden:NO];
    [[BaseSservice sharedManager]post1:@"/app/user/attestation.do" paramters:param success:^(NSDictionary *dic) {
        TzsTabbarViewController *tzs =[[TzsTabbarViewController alloc]init];
        [self hiddenHUD];
        
        [self showHUD:onlyMsg message:@"认证成功.." detai:nil Hdden:YES];
        self.view.window.rootViewController = tzs;
    } failure:^(NSError *error) {
         [self hiddenHUD];
    }];
}
- (IBAction)didRz:(id)sender {
    if (self.nameTF.text.length<1) {
        return;
    }
    if (self.sfzTf.text.length<15) {
        return;
    }
    [self updateInfo];
    
    
}

-(void)showHUD:(HUDType)type message:(NSString *)message detai:(NSString *)detailMsg Hdden:(BOOL)hidden
{
    [super showHUD:type message:message detai:detailMsg Hdden:hidden];
}
-(void)hiddenHUD
{
    [super hiddenHUD];
}
@end
