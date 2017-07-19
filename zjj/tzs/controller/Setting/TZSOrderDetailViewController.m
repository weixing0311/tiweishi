//
//  TZSOrderDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSOrderDetailViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "UpdataAddressCell.h"
#import "DistributionBottomCell.h"
@interface TZSOrderDetailViewController ()

@end

@implementation TZSOrderDetailViewController
{
    NSMutableArray * _dataArray;
    NSMutableDictionary * _infoDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self setNbColor];
    self.tableview .delegate =self;
    self.tableview.dataSource = self;
    self.tableview.sectionHeaderHeight = 10;
    self.tableview.sectionFooterHeight = 10;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    _infoDict = [NSMutableDictionary dictionary ];;
    [self getlistInfo_is_tzs];
    // Do any additional setup after loading the view from its nib.
}
-(void)getlistInfo_is_tzs
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:self.orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/serviceOrder/queryOrderInfoOne.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"][0];
        [_dataArray addObjectsFromArray:[_infoDict safeObjectForKey:@"itemJson"]];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 if (section ==0)
    {
        return _dataArray.count;
        
    }
    else if(section ==1)
    {
        return 2;
        
    }else{

    return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 40)];

    if (section==0) {
        view.backgroundColor =HEXCOLOR(0xeeeeee);
        
        TZSOrderHeader *header = [self getXibCellWithTitle:@"TZSOrderHeader"];
        header.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 40);
        header.backgroundColor =[UIColor whiteColor];
        header.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",[_infoDict objectForKey:@"orderNo"]];
        
        int status = [[_infoDict objectForKey:@"status"]intValue];
        
        header.statusLabel .text = [self getStatusWithStatus:status];
        [view addSubview:header];
        

    }
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 40;
    
    }else
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 if (indexPath.section ==0)
    {
        return 100;
    }else if(indexPath.section ==2){
        return 44;
    }else{
        return 75;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
        
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"unitPrice"]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
        return cell;
    }
    else if (indexPath.section ==1)
    {
        static NSString * identifier = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if (indexPath.row ==0) {
            cell.textLabel.text =[NSString stringWithFormat:@"下单时间：%@",[_infoDict objectForKey:@"createTime"]];
        }else{
            cell.textLabel.text =[NSString stringWithFormat:@"支付方式：%@",[_infoDict objectForKey:@"paymentType"]];
        }
        return cell;
        
    }
    else
    {
        static NSString * identifier = @"DistributionBottomCell";

        DistributionBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.totoaPriceLabel.text = [NSString stringWithFormat:@"+￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]];
        cell.uhLabel.text =[NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]-[[_infoDict objectForKey:@"payableAmount"]floatValue]];
        cell.thirdTitleLabel.text = @"实付款";
        cell.ufLabel.text =[NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"payableAmount"]floatValue]];
        return cell;
        
    }
}
-(NSString *)getStatusWithStatus:(int)myStatus
{
    switch (myStatus) {
            //                    订单状态 1待付款   10.已完成  0已取消
        case 1:
            return @"待付款";
            break;
        case 10:
            return @"已完成";
            break;
        case 0:
            return @"已取消";
            break;
            
        default:
            break;
    }
    return nil;
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
