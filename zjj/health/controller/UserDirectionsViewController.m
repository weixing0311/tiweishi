//
//  UserDirectionsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserDirectionsViewController.h"

@interface UserDirectionsViewController ()

@end

@implementation UserDirectionsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildScrol];
    // Do any additional setup after loading the view from its nib.
}
-(void)buildScrol
{
    UIScrollView * scr =[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scr];
    scr.pagingEnabled = YES;
    scr.contentSize = CGSizeMake(JFA_SCREEN_WIDTH*3, 0);
    for (int i =0; i<3; i++) {
        UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH*i, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-64)];
        NSString * imageName =[NSString stringWithFormat:@"UserDirections%d_",i+1];
        imageView.image = getImage(imageName);
        [scr addSubview:imageView];
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
