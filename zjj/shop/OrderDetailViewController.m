//
//  OrderDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "UpdataAddressCell.h"
#import "OrderFootBtnView.h"
#import "WXPsTitleCell.h"
@interface OrderDetailViewController ()<orderFootBtnViewDelegate>

@end

@implementation OrderDetailViewController
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
    self.view.backgroundColor =HEXCOLOR(0xeeeeee);
    self.tableview.backgroundColor =[UIColor clearColor];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    _infoDict = [NSMutableDictionary dictionary ];;
    // Do any additional setup after loading the view from its nib.
    
    [self getlistInfo_IS_CONSUMERS];
    
    
}

-(void)getlistInfo_IS_CONSUMERS
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:self.orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/queryOrderDetail.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"][0];
        [_dataArray addObjectsFromArray:[_infoDict safeObjectForKey:@"itemJson"]];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
        
    }
    else if (section ==1)
    {
        return 1;
        
    }

    else if (section ==2)
    {
        return _dataArray.count;
        
    }
    else if(section ==3)
    {
        return 2;
        
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==2) {
        return 44;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==0) {
        return 10;
    }
    else if (section==1)
    {
        return 0;
    }
    else if (section==2)
    {
        return 10;
    }
    else if (section==3)
    {
        return 10;
    }
    else{
        int status = [[_infoDict safeObjectForKey:@"status"]intValue];
        if (status==3||status==1) {
        return 40;
        }else{
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        int status = [[_infoDict objectForKey:@"status"]intValue];
        if (status==1||status==3) {
            return 80;
            
        }else{
            return 0;
        }
    }
    else if(indexPath.section ==1)
    {
        return 80;
    }
    else if (indexPath.section ==2)
    {
        return 100;
    }else{
        return 44;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];

    if (section ==2) {
        view.backgroundColor =[UIColor colorWithWhite:1 alpha:1];
        
        TZSOrderHeader *header = [self getXibCellWithTitle:@"TZSOrderHeader"];
        header.frame = CGRectMake(0, 10, JFA_SCREEN_WIDTH, 30);
        header.backgroundColor =[UIColor whiteColor];
        header.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",[_infoDict objectForKey:@"orderNo"]];
        
        int status = [[_infoDict objectForKey:@"status"]intValue];
        
        header.statusLabel .text = [self getStatusWithStatus:status];
        [view addSubview:header];
        
    }
    return view;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    if (section ==4) {
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 44)];
        view.backgroundColor =HEXCOLOR(0xeeeeee);

        int status = [[_infoDict safeObjectForKey:@"status"]intValue];
        if (status==3) {

           OrderFootBtnView * footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
            footBtn.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 44);
            footBtn.tag = section;
            footBtn.delegate = self;
            [footBtn.firstBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [footBtn.secondBtn setTitle:@"查看物流" forState:UIControlStateNormal];

            [view addSubview:footBtn];

            
            
            
        }else if (status ==1)
        {
            OrderFootBtnView * footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
            footBtn.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 44);
            footBtn.tag = section;
            footBtn.delegate = self;
            [footBtn.firstBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [footBtn.secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
            [view addSubview:footBtn];
  
        }
        return view;

    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        static NSString * identifier = @"WXPsTitleCell";
        
        WXPsTitleCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        int status = [[_infoDict objectForKey:@"status"]intValue];
        
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        if (status==3) {
            cell.payTsView.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text  =[_infoDict safeObjectForKey:@"clientDescription"];
            cell.timeLabel.text = [_infoDict safeObjectForKey:@"operationTime"];
        }
        else if(status ==1){
            cell.payTsView.hidden =NO;
            cell.lastTime.text =[NSString stringWithFormat:@"剩余：%@",@"0小时0分"];
            cell.paypriceLabel.text = [NSString stringWithFormat:@"需付款:￥%@",[_infoDict safeObjectForKey:@"freight"]];
        }else{
            cell.payTsView.hidden = YES;
        }
        return cell;
        
        
    }
    if (indexPath.section ==1) {
        static NSString * identifier = @"UpdataAddressCell";
        UpdataAddressCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.titleLabel.text = [_infoDict safeObjectForKey:@"consigneeName"];
        cell.addressLabel.text =[_infoDict safeObjectForKey:@"consigneeAddress"];
        cell.phonenumLabel.text = [_infoDict safeObjectForKey:@"consigneePhone"];
        return cell;
    }
    else if (indexPath.section ==2) {
        static NSString * identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"unitPrice"]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
        return cell;
    }
    else if (indexPath.section ==3)
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
        static NSString * identifier = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if (indexPath.row ==0) {
            cell.textLabel.text =@"商品金额";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]];
        }else if(indexPath.row ==1){
            cell.textLabel.text =@"商品优惠";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]-[[_infoDict objectForKey:@"payableAmount"]floatValue]];
            cell.detailTextLabel.textColor =[UIColor greenColor];
        }else{
            cell.textLabel.text = @"实付款：";
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"payableAmount"]floatValue]];
            cell.detailTextLabel.textColor =[UIColor redColor];
        }
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)getStatusWithStatus:(int)myStatus
{
    switch (myStatus) {
            //                    订单状态1待付款   2付款确认中   3待收货   10.已完成  0已取消
        case 1:
            return @"待付款";
            break;
        case 2:
            return @"";
            break;
        case 3:
            return @"待收货";
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

-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view
{
    int status = [[_infoDict safeObjectForKey:@"status"]intValue];
    if (status==3)
    {
        
    }
    else if (status ==1)
    {
        //去付款
    }
}
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view
{
    int status = [[_infoDict safeObjectForKey:@"status"]intValue];
    NSString * orderNo =[_infoDict safeObjectForKey:@"orderNo"];

    if (status==3)
    {
        
    }
    else if (status ==1)
    {
        //取消订单
        [self cancelOrderWithOrderId:orderNo];
    }
}
/**
 *  取消订单接口
 */
-(void)cancelOrderWithOrderId:(NSString *)orderId
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
        [param setObject:orderId forKey:@"orderNo"];
        [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[UserModel shareInstance].username forKey:@"userName"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/cancelOrder.do" paramters:param success:^(NSDictionary *dic) {
            [[UserModel shareInstance] showSuccessWithStatus:@"取消成功"];
            [self.tableview headerBeginRefreshing];
            
        } failure:^(NSError *error) {
            [[UserModel shareInstance] showErrorWithStatus:@"取消失败"];
        }];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil]];

    
    [self presentViewController:al animated:YES completion:nil];
    
    
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
