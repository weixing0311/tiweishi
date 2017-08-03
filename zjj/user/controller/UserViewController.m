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
#import "AboutUsViewController.h"
#import "LoignViewController.h"
#import "CharViewController.h"
#import "ChangPasswordViewController.h"
@interface UserViewController ()

@end

@implementation UserViewController
{
    
    __weak IBOutlet UIButton *rightLoignOut;
    __weak IBOutlet UIButton *loignOutBtn;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self refreshMyUserInfoView];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
//    [self addFootView];
    self.headerImage.layer.borderWidth= 2;
    self.headerImage.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;

    [self.headerImage setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl]placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.nickNameLabel.text = [UserModel shareInstance].nickName;

    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:254/255.0 green:86/255.0 blue:0/255.0 alpha:1];

    [self setNavigationBarType];
    CGRect rect = loignOutBtn.frame;
    if (rect.origin.y+rect.size.height>JFA_SCREEN_HEIGHT-64) {
        loignOutBtn.hidden = YES;
        rightLoignOut.hidden = NO;
    }else{
        loignOutBtn.hidden = NO;
        rightLoignOut.hidden = YES;
    }
    
    
}
//-(void)addFootView
//{
//    UIView * footv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 70)];
//    UIButton * loignOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH-120, 45)];
//    [loignOutBtn setBackgroundColor:HEXCOLOR(0xEE0A3B)];
//    [loignOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    [loignOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    loignOutBtn.center = footv.center;
//    loignOutBtn.layer.cornerRadius = 5;
//    loignOutBtn.layer.masksToBounds=  YES;
//    [loignOutBtn addTarget:self action:@selector(loignout:) forControlEvents:UIControlEventTouchUpInside];
//    [footv addSubview:loignOutBtn];
//    self.tableview.tableFooterView = footv;
//}
-(void)refreshMyUserInfoView
{
    [self.headerImage setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    cell.textLabel.font = [UIFont systemFontOfSize:17];
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
            cell.textLabel.text = @"修改登录密码";
            cell.imageView.image = [UIImage imageNamed:@"pwd"];
            break;

        case 3:
            cell.textLabel.text = @"关于我们";
            cell.imageView.image = [UIImage imageNamed:@"aboutUs"];
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (indexPath.row ==0) {
        ChangeUserInfoViewController *cv =[[ChangeUserInfoViewController alloc]init];
        cv.hidesBottomBarWhenPushed=YES;
        if ([[UserModel shareInstance].healthId isEqualToString:[UserModel shareInstance].subId]) {
            cv.changeType =2;
        }else{
            cv.changeType =4;
        }
        [self.navigationController pushViewController:cv animated:YES];
   
    }else if (indexPath.row ==1)
    {
        MyCollectionViewController *mc =[[MyCollectionViewController alloc]init];
        mc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mc animated:YES];

    }else if (indexPath.row==2)
    {
        ChangPasswordViewController *vc =[ [ChangPasswordViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    else{
        AboutUsViewController *su =[[AboutUsViewController alloc]init];
        su.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:su animated:YES];
  
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
    
    UIAlertController * la =[UIAlertController alertControllerWithTitle:@"是否确认退出登录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [la addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyloignInfo];
        [[UserModel shareInstance]removeAllObject];
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController = lo;
    }]];
    [la addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
 
    [self presentViewController:la animated:YES completion:nil];
    
    
}
- (IBAction)enterChangeUserInfoVC:(id)sender {
    ChangeUserInfoViewController *cv =[[ChangeUserInfoViewController alloc]init];
    cv.hidesBottomBarWhenPushed=YES;
    if ([[UserModel shareInstance].healthId isEqualToString:[UserModel shareInstance].subId]) {
        cv.changeType =2;
    }else{
        cv.changeType =4;
    }
    [self.navigationController pushViewController:cv animated:YES];
    

}
- (IBAction)EnterCharVC:(UIButton *)sender {
    CharViewController * cv = [[CharViewController alloc]init];
    cv.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:cv animated:YES];
}
@end
