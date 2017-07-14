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
#import "ShopTestViewController.h"
#import "TabbarViewController.h"
@interface TzsTabbarViewController ()

@end

@implementation TzsTabbarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ShopTestViewController *st =[[ShopTestViewController alloc]init];
    st.title = @"健康";
    
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

    self.viewControllers = @[st,nav1,nav2,nav3];

    UITabBarItem * item1 =[self.tabBar.items objectAtIndex:0];
    UITabBarItem * item2 =[self.tabBar.items objectAtIndex:1];
    UITabBarItem * item3 =[self.tabBar.items objectAtIndex:2];
    UITabBarItem * item4 =[self.tabBar.items objectAtIndex:3];
    
    item1.image = [UIImage imageNamed:@"health  gray_"];
    item1.selectedImage = [UIImage imageNamed:@"health_"];

    
    item2.image = [UIImage imageNamed:@"fonter-help"];
    item2.selectedImage = [UIImage imageNamed:@"fonter-help-red"];
    
    item3.image = [UIImage imageNamed:@"footer-jianzhi"];
    item3.selectedImage = [UIImage imageNamed:@"footer-jianzhi-red"];
    
    item4.image = [UIImage imageNamed:@"footer-PersonalCenter"];
    item4.selectedImage = [UIImage imageNamed:@"footer-PersonalCenter-red"];
    
    self.selectedIndex=3;
    // Do any additional setup after loading the view.
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"item name = %@", item.title);
    
    if ([item.title isEqualToString:@"健康"]) {
        
        TabbarViewController * tb= [[TabbarViewController alloc]init];
        self.view.window.rootViewController = tb;

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
