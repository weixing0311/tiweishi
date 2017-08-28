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
#import "WXPsTitleCell.h"
#import "UpdataAddressCell.h"
#import "BaseWebViewController.h"
#import "OrderFootBtnView.h"
#import "OrderPayFootCell.h"
@interface TZSOrderDetailViewController ()<orderFootBtnViewDelegate>

@end

@implementation TZSOrderDetailViewController
{
    NSMutableArray * _dataArray;
    NSMutableDictionary * _infoDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订购详情";
    [self setNbColor];
    self.tableview .delegate =self;
    self.tableview.dataSource = self;
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
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }
     if (section ==1)
    {
        return _dataArray.count;
        
    }
    else if(section ==2)
    {
        int status =    [[_infoDict objectForKey:@"status"]intValue];
        if ( status ==1||status ==0)
        {
            return 1;
            
        }
        else{
        return 2;
        }
        
    }
    else
    {

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
    
    }
    else
    {
    return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3) {
        return 50;
    }
    else
    {
    return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==3) {
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];
     int status =    [[_infoDict objectForKey:@"status"]intValue];
        if (status ==1) {
            
           OrderFootBtnView * footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
            footBtn.frame = CGRectMake(0, 32, JFA_SCREEN_WIDTH, 44);
            footBtn.tag = section;
            footBtn.myDelegate = self;
            [footBtn.firstBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [footBtn.secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [view addSubview:footBtn];

        }
        
        return view;
  
    }
    return nil;
 }


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        int status =    [[_infoDict objectForKey:@"status"]intValue];
        if (status ==1) {

        return 80;
        }else{
            return 0;
        }
    }
    else if (indexPath.section ==1)
    {
        return 100;
    }
    else if(indexPath.section ==2){
        return 44;
    }else{
        return 110;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int status =    [[_infoDict objectForKey:@"status"]intValue];
    
    
    if (indexPath.section ==0) {
        static NSString * identifier = @"WXPsTitleCell";
        
        WXPsTitleCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        int status =    [[_infoDict objectForKey:@"status"]intValue];
        if (status ==1) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        cell.payTsView.hidden =NO;
        cell.lastTime.text =[NSString stringWithFormat:@"剩余时间：%@",@"0小时0分"];
        cell.paypriceLabel.text = [NSString stringWithFormat:@"需付款:￥%@",[NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"payableAmount"]floatValue]]];
        NSString * finishTime =[_infoDict safeObjectForKey:@"remainingTime"];
        if (finishTime.length<1) {
            cell.lastTime.text = @"支付已超时";
            
        }else{
        [cell setTimeLabelText:finishTime];
        }
        return cell;
    }

    
    
     else if (indexPath.section ==1) {
        static NSString * identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic safeObjectForKey:@"unitPrice"] floatValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
        return cell;
    }
    else if (indexPath.section ==2)
    {
        static NSString * identifier = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row ==0) {
            cell.textLabel.text =[NSString stringWithFormat:@"下单时间：%@",[_infoDict objectForKey:@"createTime"]];
        }else{
            if (status==10) {
                cell.textLabel.text =[NSString stringWithFormat:@"支付方式：%@",[_infoDict safeObjectForKey:@"paymentTypeId"]];

            }else{
                cell.textLabel.text =@"";
            }
        }
        return cell;
        
    }
    else
    {
        static NSString * identifier = @"OrderPayFootCell";
        OrderPayFootCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.value1label.text = [NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]];
        cell.title2label.text = @"商品优惠";
        cell.value2label.text =[NSString stringWithFormat:@"-￥%.2f",[[_infoDict objectForKey:@"totalPrice"]floatValue]-[[_infoDict objectForKey:@"payableAmount"]floatValue]];
        cell.value3label.text =[NSString stringWithFormat:@"￥%.2f",[[_infoDict objectForKey:@"payableAmount"]floatValue]];
        cell.value2label.textColor = HEXCOLOR(0x238B66);
        if (status ==10) {
            cell.title3label.text = @"实付款";

        }else{
            cell.title3label.text = @"应付款";
        }
        cell.title4label.text = @"";
        cell.value4label.text = @"";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
//    if (indexPath.section ==0) {
//        BaseWebViewController * web =[[BaseWebViewController alloc]init];
//        web.title = @"我的配送";
//        NSString * orderNo = [dic safeObjectForKey:@"orderNo"];
//        web.urlStr = [NSString stringWithFormat:@"app/fatTeacher/logisticsInformation.html?%@",orderNo];
//        [self.navigationController pushViewController:web animated:YES];
//    }
}
-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view
{
    //去支付
    
    int status = [[_infoDict safeObjectForKey:@"status"]intValue];
    if (status==1) {
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [_infoDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =3;
        web.opt =1;
        web.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
 
    }
    
}
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view
{
    //取消
    
    int status = [[_infoDict safeObjectForKey:@"status"]intValue];
    if (status==1) {

    //    取消订单
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:[_infoDict safeObjectForKey:@"orderNo"] forKey:@"orderNo"];
    [param safeSetObject:[UserModel shareInstance].nickName  forKey:@"userName"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/serviceOrder/cancelOrder.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"删除订单成功--%@",dic);
        [[UserModel shareInstance]showSuccessWithStatus:@"取消订单成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        DLog(@"删除订单失败--%@",error);
    }];
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
