//
//  EidtViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "EidtViewController.h"
#import "PublicCell.h"
#import "BaseWebViewController.h"
#import "AddressListViewController.h"
#import "ChangePasswordViewController.h"
@interface EidtViewController ()

@end

@implementation EidtViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    [self setNbColor];
    // Do any additional setup after loading the view from its nib.
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 3;
    }else if (section ==1)
    {
        return 1;
    }else if (section ==2)
    {
        return 1;
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text =@"头像";
                    cell.detailTextLabel.text = @"";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    cell.textLabel.text =@"姓名";
                    cell.detailTextLabel.text = @"张三";
                    
                    break;
                case 2:
                    cell.textLabel.text =@"手机号";
                    cell.detailTextLabel.text = @"12312312312";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            cell.textLabel.text =@"收货地址";
            cell.detailTextLabel.text = @"未设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text =@"登录密码管理";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text =@"客服电话";
                    cell.detailTextLabel.text = @"4008-123-123";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    cell.textLabel.text =@"公司简介";
                    cell.detailTextLabel.text = @"";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==0) {
        if (indexPath.row ==0)
        {
            UIAlertController *la = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [la addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [la addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];

            [la addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:la animated:YES completion:nil];
        }
        else if (indexPath.row==1)
        {
            BaseWebViewController *bw = [[BaseWebViewController alloc]init];
            bw.title = @"修改昵称";
            [self.navigationController pushViewController:bw animated:YES];
   
        }
        else
        {
            BaseWebViewController *bw = [[BaseWebViewController alloc]init];
            bw.title = @"修改手机号";
            [self.navigationController pushViewController:bw animated:YES];
        }
    }
    else if (indexPath.section ==1)
    {
        AddressListViewController *ls =[[AddressListViewController alloc]init];
        [self.navigationController pushViewController:ls animated:YES];
    }
    else if (indexPath.section ==2)
    {
        BaseWebViewController *bw = [[BaseWebViewController alloc]init];
        bw.title = @"登录密码管理";
        [self.navigationController pushViewController:bw animated:YES];

    }
    else
    {
        if (indexPath.row ==0) {
            BaseWebViewController *bw = [[BaseWebViewController alloc]init];
            bw.title = @"联系我们";
            [self.navigationController pushViewController:bw animated:YES];
        }
        else
        {
            BaseWebViewController *bw = [[BaseWebViewController alloc]init];
            bw.title = @"公司简介";
            [self.navigationController pushViewController:bw animated:YES];
  
        }
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
