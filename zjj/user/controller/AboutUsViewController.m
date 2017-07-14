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
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    self.title = @"关于我们";
    _clickNum =0;
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
    self.DebugView.hidden =NO;
}


- (IBAction)didClickMobile:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006119516"]];
}
- (IBAction)SwitchChange:(UISwitch *)sender {
    if (sender.isOn) {
        DLog(@"开启debug模式");
        [[NSUserDefaults standardUserDefaults]setObject:@"open" forKey:@"UserOpenUpdateDebugKey"];
    }else{
        DLog(@"关闭debug模式");
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserOpenUpdateDebugKey"];
        self.DebugView.hidden= YES;
        self.logoBtn.userInteractionEnabled = NO;

    }
}
@end
