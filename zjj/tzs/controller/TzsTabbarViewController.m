//
//  TzsTabbarViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TzsTabbarViewController.h"
#import "HelpViewController.h"
#import "JzSchoolViewController.h"
#import "SettingViewController.h"
@interface TzsTabbarViewController ()

@end

@implementation TzsTabbarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    HelpViewController *news = [[HelpViewController alloc]init];
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:news];
    nav1.navigationBar.barTintColor = [UIColor redColor];
    
    news.title = @"帮助中心";
    
    JzSchoolViewController *found = [[JzSchoolViewController alloc]init];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:found];
    nav2.navigationBar.barTintColor = [UIColor redColor];
    found.title = @"减脂学院";
    
    SettingViewController *shop = [[SettingViewController alloc]init];
    shop.title = @"个人中心";
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:shop];
    nav3.navigationBar.barTintColor = [UIColor redColor];

    self.viewControllers = @[nav1,nav2,nav3];

    UITabBarItem * item1 =[self.tabBar.items objectAtIndex:0];
    UITabBarItem * item2 =[self.tabBar.items objectAtIndex:1];
    UITabBarItem * item3 =[self.tabBar.items objectAtIndex:2];
    
    item1.image = [UIImage imageNamed:@"fonter-help"];
    item1.selectedImage = [UIImage imageNamed:@"fonter-help-red"];
    
    item2.image = [UIImage imageNamed:@"footer-jianzhi"];
    item2.selectedImage = [UIImage imageNamed:@"footer-jianzhi-red"];
    
    item3.image = [UIImage imageNamed:@"footer-PersonalCenter"];
    item3.selectedImage = [UIImage imageNamed:@"footer-PersonalCenter-red"];
    
    self.selectedIndex=2;
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
