//
//  UserViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserViewController.h"
#import "ChangeUserInfoViewController.h"
#import "MyCollectionViewController.h"
#import "bdAccountViewController.h"
#import "setUpViewController.h"
#import "LoignViewController.h"
@interface UserViewController ()

@end

@implementation UserViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self refreshMyInfoView];
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.headerImage setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl]];
    self.nickNameLabel.text = [UserModel shareInstance].nickName;

    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:254/255.0 green:86/255.0 blue:0/255.0 alpha:1];

    [self setNavigationBarType];
}
-(void)refreshMyInfoView
{
    [self.headerImage setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head-default"]];
    self.nickNameLabel.text = [SubUserItem shareInstance].nickname;
}
-(void)setNavigationBarType
{
//    self.navigationController.navigationBar.translucent =YES;
//    UIColor *color = [UIColor clearColor];
//    CGRect rect = CGRectMake(0, 0,JFA_SCREEN_WIDTH, 64);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.clipsToBounds = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"修改资料";
            cell.imageView.image = [UIImage imageNamed:@"write_"];
            break;
        case 1:
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"collect_"];
            break;
        case 2:
            cell.textLabel.text = @"账号绑定";
            cell.imageView.image = [UIImage imageNamed:@"user_"];
            break;
        case 3:
            cell.textLabel.text = @"设置";
            cell.imageView.image = [UIImage imageNamed:@"settings_"];
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChangeUserInfoViewController *cv =[[ChangeUserInfoViewController alloc]init];
    MyCollectionViewController *mc =[[MyCollectionViewController alloc]init];
    bdAccountViewController *bd =[[bdAccountViewController alloc]init];
    setUpViewController *su =[[setUpViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;

    switch (indexPath.row) {
        case 0:
            if ([[UserModel shareInstance].healthId isEqualToString:[UserModel shareInstance].subId]) {
                cv.changeType =2;
            }else{
                cv.changeType =4;
            }
            [self.navigationController pushViewController:cv animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:mc animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:bd animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:su animated:YES];
            break;
            
        default:
            break;
    
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

- (IBAction)loignout:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyloignInfo];
    [[UserModel shareInstance]removeAllObject];
    LoignViewController *lo = [[LoignViewController alloc]init];
    self.view.window.rootViewController = lo;

    
    
}
@end
