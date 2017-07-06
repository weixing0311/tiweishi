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
@interface TZSConfirmTheViewController ()
@property (nonatomic,assign)float freight;
@property (nonatomic,copy  )NSString * address;
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
}
#pragma mark --接口

//获取默认地址
-(void)getDefaultAddressFromNet
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    [[BaseSservice sharedManager]post1:@"app/orderList/getDefaultAddress.do" paramters:param success:^(NSDictionary *dic) {
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
    [[BaseSservice sharedManager]post1:@"app/warehouseno/getWarehouseNo.do" paramters:param success:^(NSDictionary *dic) {
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
    [[BaseSservice sharedManager]post1:@"app/freigthCount/freigthProductCount.do" paramters:param success:^(NSDictionary *dic) {
        weightStr = [[dic objectForKey:@"data"]objectForKey:@"freight"];
        self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.0f",[[self.param objectForKey:@"payableAmount"]floatValue]+[weightStr floatValue]];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
    }];
    
    
}
//提交订单
-(void)updateOrder
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:@(self.freight) forKey:@"freight"];
    [param safeSetObject:self.address forKey:@"addressId"];
    [param safeSetObject:@"" forKey:@"freightType"];
    [param safeSetObject:@"" forKey:@"buyerRemark"];
    [param safeSetObject:self.productStr forKey:@"productArray"];
    
    
    [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/addDelivery.do" paramters:param success:^(NSDictionary *dic) {
        
        
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


////取消订单
//
//-(void)cancelOrder
//{
//    NSMutableDictionary * param =[NSMutableDictionary dictionary];
//    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
//    [param safeSetObject:@"" forKey:@"orderNo"];
//    
//    [[BaseSservice sharedManager]post1:@"app/orderList/cancelOrder.do" paramters:param success:^(NSDictionary *dic) {
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
    }else{
        return 40;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[addressDict safeObjectForKey:@"provinceName"],[addressDict safeObjectForKey:@"cityName"],[addressDict safeObjectForKey:@"countyName"],[addressDict safeObjectForKey:@"addr"]];
        cell.phonenumLabel.text = [addressDict safeObjectForKey:@"phone"];
        return cell;
    }else if (indexPath.section ==1)
    {
        static NSString *identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic =[_dataArray objectAtIndex:indexPath.row];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:@"defPicture"]];
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"unitPrice"]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];

        
        return cell;
    }else{
        static NSString * identifier = @"PublicCell";
        PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell ) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.headImageView.image = [UIImage imageNamed:@"personal-receiving"];
        cell.titleLabel.text = @"配送方式";
//        cell.secondLabel.text =[NSString stringWithFormat:@"￥%@",weightStr ];
        return cell;
    }
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
        int count = [[dic objectForKey:@"quantity"] intValue];
        if (freightTemplateId ==0) {
            weight1 +=weight*count;
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
