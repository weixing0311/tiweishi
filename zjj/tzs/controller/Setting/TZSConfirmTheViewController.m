//
//  TZSConfirmTheViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSConfirmTheViewController.h"
#import "AddressListViewController.h"
#import "UpdataAddressCell.h"
#import "UpDateOrderCell.h"
#import "PublicCell.h"
#import "DistributionBottomCell.h"
#import "BaseWebViewController.h"
@interface TZSConfirmTheViewController ()
@property (nonatomic,copy  )NSString * warehouseNo;
@end

@implementation TZSConfirmTheViewController
{
    NSMutableDictionary * addressDict;
    NSString *weightStr;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray =[NSMutableArray array];
        self.param = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.currentTasks cancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddress:) name:kSendAddress object:nil];
    self.title = @"确认订单";
    [self setNbColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self getDefaultAddressFromNet];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark ---notifation
-(void)getAddress:(NSNotification*)noti
{
    addressDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [addressDict setDictionary:noti.userInfo];
    [self.tableview reloadData];

    [self getwarehousingWithproviceId:[addressDict objectForKey:@"provinceId"]];

}
#pragma mark --接口

//获取默认地址
-(void)getDefaultAddressFromNet
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/getDefaultAddress.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"success --%@",dic);
        
        addressDict =[NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
        [self.tableview reloadData];
        
        [self getwarehousingWithproviceId:[addressDict objectForKey:@"provinceId"]];
        
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
        
    }];
    
}
/**
 *  获取仓储
 */
-(void)getwarehousingWithproviceId:(NSString *)proviceId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self getWarehousingUpdateInfo] forKey:@"products"];
    [param setObject:proviceId forKey:@"proviceId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/warehouseno/getWarehouseNo.do" paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dict = [dic safeObjectForKey:@"data"];
        self.warehouseNo =[dict safeObjectForKey:@"warehouseNo"];
        [self getTransfortationPriceWithproviceId:proviceId warehouseNo:self.warehouseNo];
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
    }];
    
    
}


//获取运费
-(void)getTransfortationPriceWithproviceId:(NSString *)proviceId warehouseNo:(NSString*)warehouseNo
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safeSetObject:[self getufUpdatainfo] forKey:@"products"];
    [param safeSetObject:proviceId forKey:@"proviceId"];
    [param safeSetObject:warehouseNo forKey:@"warehouseNo"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/freigthCount/freigthProductCount.do" paramters:param success:^(NSDictionary *dic) {
        weightStr = [[dic objectForKey:@"data"]objectForKey:@"freight"];
        self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
    }];
    
    
}
//提交订单
-(void)updateOrder
{
}

////取消订单
//
//-(void)cancelOrder
//{
//    NSMutableDictionary * param =[NSMutableDictionary dictionary];
//    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
//    [param safeSetObject:@"" forKey:@"orderNo"];
//    
//    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/cancelOrder.do" paramters:param success:^(NSDictionary *dic) {
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 80;
    }else if (indexPath.section ==1)
    {
        return 100;
    }else if(indexPath.section ==2){
        return 40;
    }else{
        return 75;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return _dataArray.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
      static  NSString * identifier = @"UpdataAddressCell";
        UpdataAddressCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.titleLabel.text =[addressDict safeObjectForKey:@"receiver"];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[addressDict safeObjectForKey:@"provinceName"]?[addressDict safeObjectForKey:@"provinceName"]:@"",[addressDict safeObjectForKey:@"cityName"]?[addressDict safeObjectForKey:@"cityName"]:@"",[addressDict safeObjectForKey:@"countyName"]?[addressDict safeObjectForKey:@"countyName"]:@"",[addressDict safeObjectForKey:@"addr"]?[addressDict safeObjectForKey:@"addr"]:@""];
        cell.phonenumLabel.text = [[UserModel shareInstance]changeTelephone:[addressDict safeObjectForKey:@"phone"]];
        return cell;
    }else if (indexPath.section ==1)
    {
        static NSString *identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic =[_dataArray objectAtIndex:indexPath.row];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"defPicture"]]placeholderImage:[UIImage imageNamed:@"head_default"]];
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        cell.priceLabel.text = @"";
//        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"unitPrice"]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"chooseCount"]];

        
        return cell;
    }else if(indexPath.section ==2){
        static NSString * identifier = @"PublicCell";
        PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell ) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.headImageView.image = [UIImage imageNamed:@"personal-receiving"];
        cell.titleLabel.text = @"配送方式";
        cell.secondLabel.text =[NSString stringWithFormat:@"快递配送" ];
        return cell;
    }else
    {
        static NSString * identifier = @"DistributionBottomCell";
        DistributionBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell ) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.ufLabel.text =[NSString stringWithFormat:@"+￥%@",weightStr?weightStr:@"0" ];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressListViewController * address = [[AddressListViewController alloc]init];
    address.isComeFromOrder = YES;
    [self.navigationController pushViewController:address animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

- (IBAction)placeTheOrder:(id)sender {
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:weightStr forKey:@"freight"];
    [param safeSetObject:[addressDict objectForKey:@"id"] forKey:@"addressId"];
    [param safeSetObject:@"1" forKey:@"freightType"];
    [param safeSetObject:@"" forKey:@"buyerRemark"];
    [param safeSetObject:self.productStr forKey:@"productArray"];
    [param safeSetObject:self.warehouseNo forKey:@"warehouseNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/addDelivery.do" paramters:param success:^(NSDictionary *dic) {
        
        
        
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dic safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =2;
        web.opt =1;
        web.orderNo = [dic safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        /*
         {
         "message": "服务配送保存成功",
         "status": "success",
         "data": {
         "orderNo": "121706191117115119197",
         "freight": 510
         },
         "code": 200}
         
         
         */
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark--获取仓储接口上传数据
/**
 *获取仓储接口提交数据
 */
-(NSString *)getWarehousingUpdateInfo
{
    
    
    NSMutableArray * arr=[NSMutableArray array];
    
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary * dic = [self.dataArray objectAtIndex:i];
        NSString *  productNo  =[dic safeObjectForKey:@"productNo"];
        NSString *  quantity = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"quantity"] intValue]];
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict safeSetObject:productNo forKey:@"productNo"];
        [dict safeSetObject:quantity forKey:@"quantity"];
        [arr addObject:dict];
        
        
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DLog(@"仓储上传信息--%@",str);
    return str;
}

#pragma mark ----计算运费
-(NSString *)getufUpdatainfo
{
    //proviceId 省份 products
    NSMutableArray * arr =[NSMutableArray array];
    NSMutableDictionary * products1 =[NSMutableDictionary dictionary];
    NSMutableDictionary * products2 =[NSMutableDictionary dictionary];
    float weight1 =0.0;
    float weight2 = 0.0;
    
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *dic   =[self.dataArray objectAtIndex:i];
        
        int freightTemplateId  =[[dic objectForKey:@"freightTemplateId"] intValue];
        float weight = [[dic objectForKey:@"productWeight"] floatValue];
        int count = [[dic objectForKey:@"chooseCount"] intValue];
        if (freightTemplateId ==0) {
            weight1 +=weight * count;
        }else{
            weight2 +=weight * count;
        }
    }
    [products1 setObject:@(weight1) forKey:@"weight"];
    [products1 setObject:@(0) forKey:@"freightTemplateId"];
    [products2 setObject:@(weight2) forKey:@"weight"];
    [products2 setObject:@(1) forKey:@"freightTemplateId"];
    if (weight1>0) {
        [arr addObject:products1];
    }
    if (weight2>0) {
        [arr addObject:products2];
    }
    
    DLog(@"计算运费参数 arr-%@",arr);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return str;
}

-(NSString *)getCc
{
    NSMutableArray * arr =[NSMutableArray array];

    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *dic   =[self.dataArray objectAtIndex:i];
        NSString * productNo = [dic safeObjectForKey:@"productNo"];
        NSString * quantity = [dic safeObjectForKey:@"quantity"];
        NSMutableDictionary * products1 =[NSMutableDictionary dictionary];

        [products1 safeSetObject:productNo forKey:@"productNo"];
        [products1 safeSetObject:quantity forKey:@"quantity"];
        [arr addObject:products1];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return str;

}

@end
