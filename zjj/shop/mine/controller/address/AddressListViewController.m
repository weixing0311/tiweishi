//
//  AddressListViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressDetailViewController.h"
#import "AddressListCell.h"
@interface AddressListViewController ()<AddressListCellDelegate>
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation AddressListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSelfInfo) name:@"refreshAddressListTableView" object:nil];
    
    [self setNbColor];
    self.dataArray =[NSMutableArray array];

    [self setExtraCellLineHiddenWithTb:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    
    [self getAddressList];
    // Do any additional setup after loading the view from its nib.
}
-(void)refreshSelfInfo
{
    [self getAddressList];
}
//获取地址信息
-(void)getAddressList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userAddress/addressList.do" paramters:param success:^(NSDictionary *dic) {
        
            self.dataArray =[NSMutableArray arrayWithCapacity:0];
            [self.dataArray addObjectsFromArray:[[dic safeObjectForKey:@"data"]objectForKey:@"array"]];
            [self.tableview reloadData];

        
    } failure:^(NSError *error) {
        
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"AddressListCell";
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dic safeObjectForKey:@"receiver"];
    cell.mobileLabel.text = [dic safeObjectForKey:@"phone"];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[dic safeObjectForKey:@"province"],[dic safeObjectForKey:@"city"],[dic safeObjectForKey:@"county"],[dic safeObjectForKey:@"addr"]];
    NSString * defaultStr = [dic safeObjectForKey:@"isDefault"];
    if ([defaultStr isEqualToString:@"1"]) {
        cell.defaultBtn.selected = YES;
    }else{
        cell.defaultBtn.selected = NO;
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isComeFromOrder) {
        NSDictionary * dic =[_dataArray objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:kSendAddress object:nil userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)didClickEditWithCell:(AddressListCell*)cell
{
    AddressDetailViewController *ad =[[AddressDetailViewController alloc]init];
    ad.isEdit = YES;
    ad.defaultDict = [self.dataArray objectAtIndex:cell.tag];
    [self.navigationController pushViewController:ad animated:YES];
}
-(void)didClickDeleteWithCell:(AddressListCell*)cell
{
    NSDictionary *dict = [self.dataArray objectAtIndex:cell.tag];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[dict safeObjectForKey:@"id"] forKey:@"id"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userAddress/deleteAddress.do" paramters:param success:^(NSDictionary *dic) {
        [self.dataArray removeObject:dict];
        
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];

}
-(void)didClickChangeDefaultWithCell:(AddressListCell*)cell
{
    [SVProgressHUD showWithStatus:@"修改中。。"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *dict = [self.dataArray objectAtIndex:cell.tag];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[dict safeObjectForKey:@"id"] forKey:@"id"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userAddress/setDefaultAddress.do" paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        
        NSString * status = [dic objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            
        cell.defaultBtn.selected = YES;
        
        for ( int i =0; i<self.dataArray.count; i++) {
            NSDictionary *dic =[self.dataArray objectAtIndex:i];
            NSString * isDefault = [dic objectForKey:@"isDefault"];
                isDefault  =@"0";
            if (i==cell.tag) {
                isDefault=@"1";
            }
        }
        
        [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        cell.defaultBtn.selected = NO;

        [SVProgressHUD dismiss];
    }];

}

- (IBAction)didAdd:(id)sender {
    AddressDetailViewController *ad =[[AddressDetailViewController alloc]init];
    [self.navigationController pushViewController:ad animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // Dispose of any resources that can be recreated.
}

@end
