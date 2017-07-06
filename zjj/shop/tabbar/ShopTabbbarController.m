//
//  ShopTabbbarController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShopTabbbarController.h"
#import "HomePageViewController.h"
#import "InfomationViewController.h"
#import "ShopCarViewController.h"
#import "MineViewController.h"
@interface ShopTabbbarController ()

@end

@implementation ShopTabbbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectSuperTabbar) name:@"changeOtherItem" object:nil];
    HomePageViewController *news = [[HomePageViewController alloc]init];
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:news];
    nav1.navigationBar.barTintColor = [UIColor redColor];

    news.title = @"首页";
    
    InfomationViewController *found = [[InfomationViewController alloc]init];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:found];
    nav2.navigationBar.barTintColor = [UIColor redColor];
    found.title = @"知识";
    
    ShopCarViewController *shop = [[ShopCarViewController alloc]init];
    shop.title = @"购物车";
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:shop];
    nav3.navigationBar.barTintColor = [UIColor redColor];

    MineViewController *user = [[MineViewController alloc]init];
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:user];
    user.title = @"我的";
    
    self.viewControllers = @[nav1,nav2,nav3,nav4];

    UITabBarItem * item1 =[self.tabBar.items objectAtIndex:0];
    UITabBarItem * item2 =[self.tabBar.items objectAtIndex:1];
    UITabBarItem * item3 =[self.tabBar.items objectAtIndex:2];
    UITabBarItem * item4 =[self.tabBar.items objectAtIndex:3];
  
    item1.image = [UIImage imageNamed:@"footer-ShoppingMall"];
    item1.selectedImage = [UIImage imageNamed:@"footer-ShoppingMall-red"];
    
    item2.image = [UIImage imageNamed:@"footer-knowledge"];
    item2.selectedImage = [UIImage imageNamed:@"footer-knowledge-red"];

    item3.image = [UIImage imageNamed:@"footer-ShoppingCart"];
    item3.selectedImage = [UIImage imageNamed:@"footer-ShoppingCart-red"];

    item4.image = [UIImage imageNamed:@"footer-PersonalCenter"];
    item4.selectedImage = [UIImage imageNamed:@"footer-PersonalCenter-red"];

    
    // Do any additional setup after loading the view.
}
-(void)selectSuperTabbar
{
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    self.tabBarController.tabBar.hidden = NO;
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
