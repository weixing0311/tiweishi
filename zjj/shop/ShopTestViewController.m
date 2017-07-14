//
//  ShopTestViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShopTestViewController.h"
@interface ShopTestViewController ()

@end

@implementation ShopTestViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UserModel shareInstance]showInfoWithStatus:@"该功能暂未开放"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
