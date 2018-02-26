//
//  TzsTabbarViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TzsTabbarViewController.h"
#import "BaseWebViewController.h"
#import "JzSchoolViewController.h"
#import "SettingViewController.h"
//#import "ShopTestViewController.h"
#import "HelpViewController.h"
#import "foundViewController.h"
#import "MessageViewController.h"
#import "TZSHomePageViewController.h"
@interface TzsTabbarViewController ()

@end

@implementation TzsTabbarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HelpViewController *news = [[HelpViewController alloc]init];
    news.urlStr = @"app/fatTeacher/help.html";
    news.title = @"帮助";
    
//    JzSchoolViewController *found = [[JzSchoolViewController alloc]init];
    TZSHomePageViewController * found =[[TZSHomePageViewController alloc]init];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:found];
    nav2.navigationBar.barTintColor = [UIColor redColor];
    found.title = @"首页";
    
    MessageViewController * message =[[MessageViewController alloc]init];
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:message];
    nav3.navigationBar.barTintColor = [UIColor redColor];
    message.title = @"消息";

    
    
    
    SettingViewController *shop = [[SettingViewController alloc]init];
    shop.title = @"我的";
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:shop];
    nav4.navigationBar.barTintColor = [UIColor redColor];

    self.viewControllers = @[nav2,nav3,news,nav4];

    UITabBarItem * item1 =[self.tabBar.items objectAtIndex:0];
    UITabBarItem * item2 =[self.tabBar.items objectAtIndex:1];
    UITabBarItem * item3 =[self.tabBar.items objectAtIndex:2];
    UITabBarItem * item4 =[self.tabBar.items objectAtIndex:3];


    item1.image = [UIImage imageNamed:@"find gray_"];
    item1.selectedImage = [[UIImage imageNamed:@"find"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    item2.image = [UIImage imageNamed:@"discuss_"];
    item2.selectedImage = [UIImage imageNamed:@"discuss_"];

    item3.image = [UIImage imageNamed:@"fonter-help"];
    item3.selectedImage = [[UIImage imageNamed:@"fonter-help-red"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    item4.image = [UIImage imageNamed:@"footer-PersonalCenter"];
    item4.selectedImage = [[UIImage imageNamed:@"footer-PersonalCenter-red"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    self.selectedIndex=0;
    self.tabBar.tintColor = HEXCOLOR(0xfb0628);

    // Do any additional setup after loading the view.
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
