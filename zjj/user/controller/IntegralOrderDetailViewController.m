//
//  IntegralOrderDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/25.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralOrderDetailViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "UpdataAddressCell.h"
#import "OrderFootBtnView.h"
#import "WXPsTitleCell.h"
#import "BaseWebViewController.h"
#import "OrderPayFootCell.h"

@interface IntegralOrderDetailViewController ()<orderFootBtnViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation IntegralOrderDetailViewController
{
    NSMutableArray * _dataArray;
    NSMutableDictionary * _infoDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setTBWhiteColor];
    self.tableview .delegate =self;
    self.tableview.dataSource = self;
    self.view.backgroundColor =HEXCOLOR(0xeeeeee);
    self.tableview.backgroundColor =[UIColor clearColor];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    _infoDict = [NSMutableDictionary dictionary ];;
    
    [self getlistInfo_IS_CONSUMERS];
}
-(void)getlistInfo_IS_CONSUMERS
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:self.orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/orderInfo/queryIntegrationOrderItem.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"][0];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:[_infoDict safeObjectForKey:@"itemJson"]];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//确认收货
-(void)ConfirmTheGoodsWithOrderNo:(NSString *)orderNo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:[UserModel shareInstance].username forKey:@"userName"];
    [param safeSetObject:orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/confirmReceipt.do" paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"确认收货成功"];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [[UserModel shareInstance]showErrorWithStatus:@"确认收货失败"];
        
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
        int status = [[_infoDict objectForKey:@"status"]intValue];
        if (status ==3) {
            return 2;
        }else{
            return 1;
        }
        
    }
    else
    {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==2) {
        return 44;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==0) {
        return 5;
    }
    else if (section==1)
    {
        return 5;
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
            return 5;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        int status = [[_infoDict objectForKey:@"status"]intValue];
        if (status==3||status ==1) {
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
    }
    else if(indexPath.section ==3)
    {
        return 44;
    }else{
        return 125;
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
        int operateStatus = [[_infoDict safeObjectForKey:@"operateStatus"]intValue];
        
        if (status==3) {
            
            OrderFootBtnView * footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
            footBtn.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 44);
            footBtn.tag = section;
            footBtn.myDelegate = self;
            [footBtn.firstBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            footBtn.secondBtn .hidden = YES;
            [view addSubview:footBtn];
            
            if (operateStatus==3) {
                footBtn.firstBtn.hidden = YES;
                footBtn.secondBtn.hidden =YES;
                footBtn.thirdBtn.hidden =YES;
            }
            else if(operateStatus==4)
            {
                footBtn.firstBtn.hidden = NO;
                footBtn.secondBtn.hidden =YES;
                footBtn.thirdBtn.hidden =YES;
                
            }
            
            
            
        }else if (status ==1)
        {
            OrderFootBtnView * footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
            footBtn.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 44);
            footBtn.tag = section;
            footBtn.myDelegate = self;
            footBtn.secondBtn .hidden =NO;
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
    int status = [[_infoDict objectForKey:@"status"]intValue];
    
    if (indexPath.section ==0) {
        
        static NSString * identifier = @"WXPsTitleCell";
        
        WXPsTitleCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        if (status==3) {
            cell.hidden =NO;
            cell.payTsView.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text  =[_infoDict safeObjectForKey:@"clientDescription"];
            cell.timeLabel.text = [_infoDict safeObjectForKey:@"operationTime"];
        }
        else if(status ==1){
            cell.hidden = NO;
            cell.payTsView.hidden =NO;
            cell.lastTime.text =[NSString stringWithFormat:@"剩余时间：%@",@"0小时0分"];
            
            cell.paypriceLabel.text = [NSString stringWithFormat:@"需付款:￥%.2f",[[_infoDict objectForKey:@"payableAmount"]floatValue]];
            NSString * finishTime =[_infoDict safeObjectForKey:@"timer"];
            [cell setTimeLabelText:finishTime];
            
        }else{
            cell.hidden = YES;
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
        cell.phonenumLabel.text =[[UserModel shareInstance]changeTelephone:[_infoDict safeObjectForKey:@"consigneePhone"]] ;
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
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic safeObjectForKey:@"normalPrice"]floatValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
        NSString * isgift = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"isGift"]];
        
        if ([isgift isEqualToString:@"1"]) {
            cell.zengimageView.hidden =NO;
        }else{
            cell.zengimageView.hidden =YES;
        }
        
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
            if (status==3) {
                cell.textLabel.text =[NSString stringWithFormat:@"支付方式：%@",[_infoDict objectForKey:@"paymentType"]];
                
            }else{
                cell.textLabel.text = @"";
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
        
        
        //商品金额= totalprice-运费（freight）
        cell.value1label.text = [NSString stringWithFormat:@"￥%.2f",[[_infoDict safeObjectForKey:@"itemTotalPrice"]floatValue]-[[_infoDict safeObjectForKey:@"freight"]floatValue]];
        cell.value2label.text =[NSString stringWithFormat:@"+￥%.2f",[[_infoDict safeObjectForKey:@"freight"]floatValue]];
        cell.value4label.text =[NSString stringWithFormat:@"-￥%.2f",[[_infoDict safeObjectForKey:@"totalPrice"]floatValue]-[[_infoDict safeObjectForKey:@"payableAmount"]floatValue]];
        cell.value3label.text =[NSString stringWithFormat:@"￥%.2f",[[_infoDict safeObjectForKey:@"payableAmount"]floatValue]];
        cell.title4label.text = @"商品优惠";
        if (status ==1) {
            cell.title3label.text = @"已付款";
        }else{
            cell.title3label.text = @"需付款";
        }
        
        return cell;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        BaseWebViewController * web =[[BaseWebViewController alloc]init];
        web.title = @"我的配送";
        NSString * orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        web.urlStr = [NSString stringWithFormat:@"app/fatTeacher/logisticsInformation.html?orderNo=%@",orderNo];
        web.payType =5;
        [self.navigationController pushViewController:web animated:YES];
    }
    
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
    if (self.delegate &&[self.delegate respondsToSelector:@selector(orderChange)]) {
        [self.delegate orderChange];
    }
    
    int status = [[_infoDict safeObjectForKey:@"status"]intValue];
    if (status==3)
    {
        [self ConfirmTheGoodsWithOrderNo:[_infoDict safeObjectForKey:@"orderNo"]];
    }
    else if (status ==1)
    {
        //去付款
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [_infoDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =5;
        web.opt =1;
        web.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
    }
}
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(orderChange)]) {
        [self.delegate orderChange];
    }
    
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
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
        [param setObject:orderId forKey:@"orderNo"];
        [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[UserModel shareInstance].username forKey:@"userName"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/order/cancelOrderDelivery.do" paramters:param success:^(NSDictionary *dic) {
            [[UserModel shareInstance] showSuccessWithStatus:@"取消成功"];
            [self getlistInfo_IS_CONSUMERS];
            
        } failure:^(NSError *error) {
            [[UserModel shareInstance] showErrorWithStatus:@"取消失败"];
        }];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];
    
    
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
