//
//  IntegralOrderViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralOrderViewController.h"
#import "IntegralOrderCell.h"
#import "UpDateOrderCell.h"
#import "OrderFooter.h"
#import "OrderFootBtnView.h"
#import "OrderDetailViewController.h"
#import "UpdataOrderViewController.h"
#import "OrderHeader.h"
#import "BaseWebViewController.h"
#import "IntegralOrderDetailViewController.h"
@interface IntegralOrderViewController ()<UITableViewDelegate,UITableViewDataSource,orderFootBtnViewDelegate,orderDetailViewDelegate>

@end

@implementation IntegralOrderViewController
{
    NSMutableArray * _dataArray;
    NSMutableArray * _infoArray;
    int page;
    int pageSize;
    OrderFootBtnView * footBtn;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    [self setTBRedColor];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self ChangeMySegmentStyle:self.segment];
    
    _dataArray =[NSMutableArray array];
    _infoArray =[NSMutableArray array];
    
    self.segment.selectedSegmentIndex = self.getOrderType;
    
    [self setRefrshWithTableView:self.tableview];
    [self.tableview headerBeginRefreshing];

    // Do any additional setup after loading the view from its nib.
}
-(void)headerRereshing
{
    [super headerRereshing];
    page =1;
    pageSize =30;
    
    [self getListInfo];
    
}
-(void)footerRereshing
{
    [super footerRereshing];
    page ++;
    [self getListInfo];
    
}
-(void)getListInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(pageSize) forKey:@"pageSize"];
    [param setObject:@"" forKey:@"status"];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/orderInfo/queryIntegrationOrderInfo.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        [self.tableview headerEndRefreshing];
        [self.tableview footerEndRefreshing];
        if (page ==1) {
            [_infoArray removeAllObjects];
            [self.tableview setFooterHidden:NO];
            
        }
        
        [_infoArray addObjectsFromArray:[[dic objectForKey:@"data"]objectForKey:@"array"]];
        if (_infoArray.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        [self getinfoWithStatus:self.segment.selectedSegmentIndex];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [self.tableview headerEndRefreshing];
        [self.tableview footerEndRefreshing];
        
    }];
}


/**
 *  取消订单接口
 */
-(void)cancelOrderWithOrderId:(NSString *)orderId
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消此订单？" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * param =[NSMutableDictionary dictionary];
        [param setObject:orderId forKey:@"orderNo"];
        [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[UserModel shareInstance].username forKey:@"userName"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/order/cancelOrderDelivery.do" paramters:param success:^(NSDictionary *dic) {
            [[UserModel shareInstance] showSuccessWithStatus:@"取消成功"];
            [self.tableview headerBeginRefreshing];
            
        } failure:^(NSError *error) {
            [[UserModel shareInstance] showErrorWithStatus:@"取消失败"];
        }];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];
    
    
    
}
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
        for (NSString * str in [error.userInfo allKeys]) {
            if ([str isEqualToString:@"message"]) {
                [[UserModel shareInstance]showErrorWithStatus:str];
                return ;
            }
        }
        [[UserModel shareInstance]showErrorWithStatus:@"确认收货失败"];
        
        
    }];
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];
    view.backgroundColor =HEXCOLOR(0xf0f2f5);
    
    OrderHeader *header = [self getXibCellWithTitle:@"OrderHeader"];
    header.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50);
    header.backgroundColor =[UIColor whiteColor];
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    header.orderNumLabel.text = [dic objectForKey:@"orderNo"];
    
    int status = [[dic objectForKey:@"status"]intValue];
    if (status ==0) {
        header.statusLabel.text = @"已取消";
        header.statusLabel.textColor =HEXCOLOR(0x666666);
    }else if (status ==10)
    {
        header.statusLabel .text= @"已完成";
        header.statusLabel.textColor =HEXCOLOR(0x666666);
        
    }else if(status ==1){
        header.statusLabel .text = @"待付款";
        header.statusLabel.textColor =[UIColor redColor];
        
    }
    else if (status ==3)
    {
        header.statusLabel .text = @"待收货";
        header.statusLabel.textColor =[UIColor redColor];
        
    }
    [view addSubview:header];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"status"]intValue];
    int operateStatus = [[dic safeObjectForKey:@"operateStatus"]intValue];
    
    float height = 0.0f;
    if (status==1||(status==3&&operateStatus ==4)) {
        height =87;
    }else{
        height =41;
    }
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, height)];
    view.backgroundColor =HEXCOLOR(0xf0f2f5);
    
    OrderFooter *footer = [self getXibCellWithTitle:@"OrderFooter"];
    footer.frame = CGRectMake(0, 1, JFA_SCREEN_WIDTH, 30);
    footer.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"payableAmount"]floatValue]];
    
    NSString * payStr =@"";
    if (status ==10||status ==3) {
        payStr =@"已付款";
    }else{
        payStr =@"需付款";
    }
    
    footer.countLabel.text = [NSString stringWithFormat:@"共计%@项服务，%@：",[dic objectForKey:@"quantitySum"],payStr];
    [view addSubview:footer];
    
    
    
    
    if (status ==1) {
        footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
        footBtn.frame = CGRectMake(0, 32, JFA_SCREEN_WIDTH, 44);
        footBtn.myDelegate =self;
        footBtn.tag = section;
        [view addSubview:footBtn];
        footBtn.secondBtn .hidden =NO;
        [footBtn.firstBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [footBtn.secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
    }
    else if (status ==3&&operateStatus==4)
    {
        footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
        footBtn.frame = CGRectMake(0, 32, JFA_SCREEN_WIDTH, 44);
        footBtn.myDelegate =self;
        footBtn.tag = section;
        [view addSubview:footBtn];
        
        footBtn.firstBtn.hidden = NO;
        footBtn.secondBtn.hidden =YES;
        footBtn.thirdBtn.hidden =YES;
        
        //        [footBtn.secondBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        
    }
    
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *dic =[_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"status"]intValue];
    int operateStatus = [[dic safeObjectForKey:@"operateStatus"]intValue];
    
    if (status==1||(status==3&&operateStatus ==4)) {
        
        return 41+46;
    }else
        return 41;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [_dataArray[section] objectForKey:@"itemJson"];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"UpDateOrderCell";
    UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    NSArray * arr = [dic objectForKey:@"itemJson"];
    NSDictionary * infoDic = [arr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [infoDic safeObjectForKey:@"productName"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
    
    NSString * priceStr = [infoDic safeObjectForKey:@"payableAmount"];
    
    NSString * integral = [infoDic safeObjectForKey:@"integral"];
    if (integral.intValue>0&&priceStr.intValue>0) {
        cell.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f+%@积分",[priceStr floatValue],integral];
        
        
    }else{
        if (integral.intValue>0) {
            cell.priceLabel.text =[NSString stringWithFormat:@"实付款：%@分",integral];
            
        }else{
            cell.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[priceStr floatValue]];
        }
        
    }

    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[infoDic safeObjectForKey:@"normalPrice"]floatValue]];
    cell.countLabel.text = [NSString stringWithFormat:@"x%@",[infoDic safeObjectForKey:@"quantity"]];
    NSString * isgift = [NSString stringWithFormat:@"%@",[infoDic safeObjectForKey:@"isGift"]];
    if ([isgift isEqualToString:@"1"]) {
        cell.zengimageView.hidden =NO;
    }else{
        cell.zengimageView.hidden =YES;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    IntegralOrderDetailViewController *or =[[IntegralOrderDetailViewController alloc]init];
    or.orderNo = [dic objectForKey:@"orderNo"];
    or.delegate =self;
    [self.navigationController pushViewController:or animated:YES];
    
}
-(void)getinfoWithStatus:(NSInteger)segmentIndex
{
    int type = 0;
    if (segmentIndex ==0) {
        type =100;
    }else if(segmentIndex ==1){
        type =1;
    }else if(segmentIndex ==2){
        type =3;
    }else if(segmentIndex ==3){
        type =10;
    }else if(segmentIndex ==3){
        type =0;
    }
    
    
    [_dataArray removeAllObjects];
    
    if (type==100) {
        [_dataArray  addObjectsFromArray:_infoArray];
        return;
    }
    
    for (int i =0; i<_infoArray.count; i++) {
        NSDictionary * dic =[_infoArray objectAtIndex:i];
        int allType = [[dic objectForKey:@"status"]intValue];
        if (allType ==type) {
            [_dataArray addObject:dic];
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
