//
//  AddFriendsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddFriendsViewController.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem = rightItem;

    // Do any additional setup after loading the view from its nib.
}
-(void)back
{
    [self.navigationController popViewControllerAnimated: YES];
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
