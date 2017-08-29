//
//  ContactUsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation ContactUsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    [self setTBRedColor];
    _addressLabel.adjustsFontSizeToFitWidth = YES;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)didClickMobile:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006119516"]];
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
