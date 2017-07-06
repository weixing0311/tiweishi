//
//  DidShareViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "DidShareViewController.h"
#import "ShareDetailView.h"
#import "ShareBottomView.h"
@interface DidShareViewController ()

@end

@implementation DidShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ShareDetailView * de = [self getXibCellWithTitle:@"ShareDetailView"];
    de.frame = self.view.bounds;
//    [de setInfo];
    [self.view addSubview:de];
    
    ShareBottomView * sb = [self getXibCellWithTitle:@"ShareBottomView"];
    sb.frame = CGRectMake(0, self.view.frame.size.height-50, JFA_SCREEN_WIDTH, 50);
    [self.view addSubview:sb];
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
