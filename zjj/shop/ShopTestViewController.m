//
//  ShopTestViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShopTestViewController.h"
#import "ShopTabbbarController.h"
@interface ShopTestViewController ()

@end

@implementation ShopTestViewController
-(void)viewWillAppear:(BOOL)animated
{
   [ super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterShop) name:@"enterShopVC" object:nil];
}
-(void)enterShop
{
    ShopTabbbarController *tb= [[ShopTabbbarController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self presentViewController:tb animated:YES completion:nil];
}

-(void)didback
{
    self.tabBarController.selectedIndex =0;
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
