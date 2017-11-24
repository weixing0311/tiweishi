//
//  GuidePageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GuidePageViewController.h"
#import "ADDChengUserViewController.h"
#import "LoignViewController.h"
#import "TabbarViewController.h"
@interface GuidePageViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)startUsering:(id)sender {
    
    if ([[UserModel shareInstance]isHaveUserInfo]==YES) {
        [[UserModel shareInstance]readToDoc];
        if ([UserModel shareInstance].birthday.length>2) {
            TabbarViewController * tabbar = [[TabbarViewController alloc]init];
            [UserModel shareInstance].tabbarStyle = @"health";
            [self.view.window setRootViewController:tabbar];
            
            if ([[UserModel shareInstance].userType isEqualToString:@"2"]) {
                [[UserModel shareInstance]getNotiadvertising];
            }
        }else{
            ADDChengUserViewController * cg =[[ADDChengUserViewController alloc]init];
            cg.isResignUser = YES;
            [self.view.window setRootViewController:cg];
        }
    }else{
       LoignViewController* lo = [[LoignViewController alloc]initWithNibName:@"LoignViewController" bundle:nil];
        [self.view.window setRootViewController:lo];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/JFA_SCREEN_WIDTH+1;
    if (page==4) {
        self.startBtn.hidden = NO;
    }else{
        self.startBtn.hidden = YES;
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
