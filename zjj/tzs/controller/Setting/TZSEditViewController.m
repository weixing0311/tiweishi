//
//  TZSEditViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSEditViewController.h"
#import "HeadImageCell.h"
#import "ChangePasswordViewController.h"
#import "ChangeJYpasswordViewController.h"
#import "ForgetJYpasswordViewController.h"
#import "TZSChangeMobileViewController.h"
#import "ImageViewController.h"
@interface TZSEditViewController ()

@end

@implementation TZSEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    
    [self setNbColor];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfoView) name:kRefreshInfo object:nil];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    [self addFootView];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)refreshMyInfoView
{
    [self.tableview reloadData];
}
-(void)addFootView
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 60)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH-40, 40)];
    button.center = view.center;
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loignout) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor redColor]];
    [view addSubview:button];
    self.tableview.tableFooterView = view;
}
//退出登录
-(void)loignout
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==2) {
        return 2;
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row ==0) {
        static NSString * identifier = @"HeadImageCell";
        HeadImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        return cell;
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        
                        break;
                    case 1:
                        cell.textLabel.text = @"姓名";
                        cell.detailTextLabel.text = [UserModel shareInstance].nickName;
                        break;
                    case 2:
                        cell.textLabel.text = @"手机号";
                        cell.detailTextLabel.text = [UserModel shareInstance].phoneNum;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    default:
                        break;
                }

                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"修改登录密码";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    case 1:
                        cell.textLabel.text = @"修改交易密码";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    case 2:
                        cell.textLabel.text = @"忘记交易密码";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    default:
                        break;
                }
                
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"客服电话";
                        cell.detailTextLabel.text = @"4008-123-123";
                        break;
                    case 1:
                        cell.textLabel.text = @"公司简介";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    default:
                        break;
                }
                
                break;
               
            default:
                break;
        }
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==0) {
        if (indexPath.row ==0)
        {
            ImageViewController *imageVC =[[ImageViewController alloc]init];
            [self.navigationController pushViewController:imageVC animated:YES];
        }
        
        else if (indexPath.row ==1)
        {
            
        }
        else
        {
            TZSChangeMobileViewController *cg =[[TZSChangeMobileViewController alloc]init];
            [self.navigationController pushViewController:cg animated:YES];
        }
    }
    else if (indexPath.section ==1) {
        if (indexPath.row ==0) {
            ChangePasswordViewController *cp = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:cp animated:YES];
            
        }
        else if (indexPath.row ==1)
        {
            ChangeJYpasswordViewController *cj =[[ChangeJYpasswordViewController alloc]init];
            [self.navigationController pushViewController:cj animated:YES];
        }
        else
        {
            ForgetJYpasswordViewController *fj = [[ForgetJYpasswordViewController alloc]init];
            [self.navigationController pushViewController:fj animated:YES];
        }
    }
    else
    {
        if (indexPath.row ==1)
        {
            
        }
    }
}



-(void)showHUD:(HUDType)type message:(NSString *)message detai:(NSString *)detailMsg Hdden:(BOOL)hidden
{
    [super showHUD:type message:message detai:detailMsg Hdden:hidden];
    
}
-(void)hiddenHUD
{
    [super hiddenHUD];
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
