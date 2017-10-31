//
//  AboutUsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (nonatomic,assign)int clickNum;
@end

@implementation AboutUsViewController
{
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
    [self setTBRedColor];
    self.title = @"关于我们";
    _clickNum =0;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserOpenUpdateDebugKey"]) {
        self.DebugView.hidden = NO;
        self.logoBtn.userInteractionEnabled = NO;
    }else{
        self.DebugView.hidden = YES;
        self.logoBtn.userInteractionEnabled = YES;
    }
    self.myversionLabel.text =[NSString stringWithFormat:@"v%@",[[UserModel shareInstance] getVersion]];
    self.versionLabel.text =[NSString stringWithFormat:@"版本号：v%@",[[UserModel shareInstance] getVersion]];

}
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openDeBug:(id)sender {
    
    if (_clickNum==0) {
        DLog(@"开启倒计时");
        [self setOpenDeBugTimer];
    }
    _clickNum ++;
    if (_clickNum==3) {
        DLog(@"显示debugView");
        [self openDebugs];
        self.logoBtn.userInteractionEnabled = NO;
        [_timer invalidate];
        _clickNum =0;
    }
}
-(void)setOpenDeBugTimer
{
    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(clearNum) userInfo:nil repeats:NO];
}
-(void)clearNum
{
    _clickNum=0;
}


-(void)openDebugs
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"确定要打开DEBUG模式吗？" message:@"DEBUG模式会严重影响体测速度，调试结束后请及时关闭，确定要打开DEBUG模式吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.DebugView.hidden =NO;
        [self.Debugswitch setOn:YES];
        [[NSUserDefaults standardUserDefaults]setObject:@"open" forKey:@"UserOpenUpdateDebugKey"];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];
}


- (IBAction)didClickMobile:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006119516"]];
}
- (IBAction)SwitchChange:(UISwitch *)sender {
    if (sender.isOn) {
        DLog(@"开启debug模式");
    }else{
        DLog(@"关闭debug模式");
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserOpenUpdateDebugKey"];
        self.DebugView.hidden= YES;
        self.logoBtn.userInteractionEnabled = YES;

    }
}
- (IBAction)checkTheUpdate:(id)sender {
    
    [self getUpdateInfo];
    
}

-(void)getUpdateInfo
{
    return;
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * bundleVersion =[infoDictionary objectForKey:@"CFBundleVersion"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/isForce/judgeVersion.do" HiddenProgress:NO paramters:nil success:^(NSDictionary *dic) {
        DLog(@"dic --%@",dic);
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
        int   upDataVersion = [[dataDic safeObjectForKey:@"version"]intValue];
        int   isForce = [[dataDic safeObjectForKey:@"isForce"]intValue];
        
        NSString * updateMessage=[dataDic safeObjectForKey:@"message" ];
        
        

        if (upDataVersion>[bundleVersion intValue]) {
            UIAlertController * la =[UIAlertController alertControllerWithTitle:@"有新版本需要更新" message:updateMessage preferredStyle:UIAlertControllerStyleAlert];
            [la addAction:[UIAlertAction actionWithTitle:@"跳转到AppStore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1209417912"]];
                
            }]];
            
            if (isForce==0) {
                [la addAction:[UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [UserModel shareInstance].ignoreVerSion = [UserModel shareInstance].upDataVersion;
                    [[NSUserDefaults standardUserDefaults]setObject:@([UserModel shareInstance].ignoreVerSion) forKey:@"ignoreVerSion"];
                    
                    [UserModel shareInstance].isUpdate =NO;
                }]];
            }
            
            [self presentViewController:la animated:YES completion:nil];
            

        }else{
            UIAlertController * la =[UIAlertController alertControllerWithTitle:@"您当前版本为最新版本，无需更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [la addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:la animated:YES completion:nil];
            
        }

        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
}

@end
