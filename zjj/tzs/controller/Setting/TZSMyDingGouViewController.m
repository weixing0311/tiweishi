//
//  TZSMyDingGouViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSMyDingGouViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "OrderFooter.h"
#import "OrderFootBtnView.h"
#import "TZSOrderDetailViewController.h"
#import "BaseWebViewController.h"
@interface TZSMyDingGouViewController ()<orderFootBtnViewDelegate,tzsOrderDetailDelegate>

@end

@implementation TZSMyDingGouViewController
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
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订购";
    [self setNbColor];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;

    _dataArray =[NSMutableArray array];
    _infoArray =[NSMutableArray array];

    [self ChangeMySegmentStyle:self.segment];
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
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(pageSize) forKey:@"pageSize"];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param setObject:@"1,10,0" forKey:@"status"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/serviceOrder/getUserOrder.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        [self.tableview headerEndRefreshing];
        [self.tableview footerEndRefreshing];
        if (page==1) {
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];
    view.backgroundColor =[UIColor colorWithWhite:.95 alpha:1];
    
    TZSOrderHeader *header = [self getXibCellWithTitle:@"TZSOrderHeader"];
    header.frame = CGRectMake(0, 9, JFA_SCREEN_WIDTH, 40);
    header.backgroundColor =[UIColor whiteColor];
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    header.orderNumLabel.text = [dic objectForKey:@"orderNo"];
    
    int status = [[dic objectForKey:@"status"]intValue];
    if (status ==0) {
        header.statusLabel.text = @"已取消";
    }else if (status ==10)
    {
        header.statusLabel .text= @"已完成";
    }else{
        header.statusLabel .text = @"待付款";
    }
    [view addSubview:header];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    int status = [[dic objectForKey:@"status"]intValue];
    float height = 0.0f;
    if (status==1) {
        height =87;
    }else{
        height =41;
    }
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, height)];
    view.backgroundColor =[UIColor colorWithWhite:.95 alpha:1];
    OrderFooter *footer = [self getXibCellWithTitle:@"OrderFooter"];
    footer.frame = CGRectMake(0, 1, JFA_SCREEN_WIDTH, 40);
    footer.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"payableAmount"] floatValue]];
    NSString * payStr =@"";
    if (status ==10) {
        payStr =@"已付款";
    }else{
        payStr =@"需付款";
    }

    footer.countLabel.text = [NSString stringWithFormat:@"共计%@项服务，%@：",[dic objectForKey:@"quantitySum"],payStr];
    
    if (status ==1) {
        footBtn = [self getXibCellWithTitle:@"OrderFootBtnView"];
        footBtn.frame = CGRectMake(0, 41.5, JFA_SCREEN_WIDTH, 44);
        footBtn.tag = section;
        footBtn.myDelegate = self;
        [footBtn.firstBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [footBtn.secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [view addSubview:footBtn];
        
    }
    
    [view addSubview:footer];
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
    if (status ==1) {
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
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[infoDic safeObjectForKey:@"unitPrice"]doubleValue]];
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
    NSMutableDictionary * dic =[_dataArray objectAtIndex:indexPath.section];
    TZSOrderDetailViewController * ds =[[TZSOrderDetailViewController alloc]init];
    ds.orderNo =[dic objectForKey:@"orderNo"];
    ds.delegate = self;
    [self.navigationController pushViewController:ds animated:YES];
    
}

-(void)getinfoWithStatus:(NSInteger)segmentIndex
{
    int type = 0;
    if (segmentIndex ==0) {
        type =100;
    }else if(segmentIndex ==1){
        type =1;
    }else if(segmentIndex ==2){
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

- (IBAction)didChangeStatussegment:(UISegmentedControl *)sender {
    
    [self getinfoWithStatus:sender.selectedSegmentIndex];
    
    [self.tableview reloadData];
}


-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view
{
    //去支付
    
    NSDictionary * dic = [_dataArray objectAtIndex:view.tag];
    
    BaseWebViewController *web = [[BaseWebViewController alloc]init];
    web.urlStr = @"app/checkstand.html";
    web.payableAmount = [dic safeObjectForKey:@"payableAmount"];
    //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
    web.payType =3;
    web.opt =1;
    web.orderNo = [dic safeObjectForKey:@"orderNo"];
    web.title  =@"收银台";
    [self.navigationController pushViewController:web animated:YES];
    

}
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view
{
    //取消
    NSMutableDictionary * dict =[_dataArray objectAtIndex:view.tag];
    
    
    //    取消订单
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:[dict safeObjectForKey:@"orderNo"] forKey:@"orderNo"];
    [param safeSetObject:[UserModel shareInstance].nickName  forKey:@"userName"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/serviceOrder/cancelOrder.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"删除订单成功--%@",dic);
        [[UserModel shareInstance]showSuccessWithStatus:@"取消订单成功"];
        [dict safeSetObject:@"0" forKey:@"status"];
        [self getinfoWithStatus:self.segment.selectedSegmentIndex];
        
        [self.tableview reloadData];

        
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"删除订单失败--%@",error);
    }];

    
    
}
-(void)tzsOrderChange
{
    [self.tableview headerBeginRefreshing];
}

@end
