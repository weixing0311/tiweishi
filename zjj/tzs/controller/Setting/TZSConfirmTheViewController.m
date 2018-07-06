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
#import "MyVoucthersViewController.h"
#import "PaySuccessViewController.h"
@interface TZSConfirmTheViewController ()<myVoucthersDelegate>
@property (nonatomic,copy  )NSString * warehouseNo;
@end

@implementation TZSConfirmTheViewController
{
    NSMutableDictionary * addressDict;
    NSString *weightStr;
    NSString * voucthersFaceValue;
    NSString * voucthersCouponNo;
    NSMutableDictionary * voucthersDict;
    NSString * vouchersCountStr;
    NSString * vouchersNameStr;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray =[NSMutableArray array];
        self.param =    [NSMutableDictionary dictionary];
        voucthersDict = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
-(void)getVouchersWithArrString:(NSString *)string
{
    [[VouchersModel shareInstance] getMyUseVoucthersArrayWithproductArr:string Success:^(NSArray *resultArr) {
        
        NSMutableArray * mutarr = [NSMutableArray arrayWithArray:resultArr];
        [mutarr enumerateObjectsUsingBlock:^(id key, NSUInteger value, BOOL *stop) {
            NSDictionary * dict = key;
            int type = [[dict safeObjectForKey:@"type"]intValue];
                if (type !=4&&type!=5) {
                    *stop =YES;
                    if (*stop ==YES) {
                        [mutarr removeObject:dict];
                    }
                }
        }];
        
        if (mutarr.count ==0) {
            vouchersCountStr = @"暂无优惠券";
        }else{
            vouchersCountStr = [NSString stringWithFormat:@"您有%lu张优惠券",(unsigned long)mutarr.count];
        }
        [self.tableview reloadData];

    } fail:^(NSString *errorStr) {
        vouchersCountStr = @"暂无优惠券";
        [self.tableview reloadData];

    }];
}


#pragma mark ---notifation
-(void)getAddress:(NSNotification*)noti
{
    vouchersNameStr = nil;
    voucthersDict = nil;

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
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/getDefaultAddress.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/warehouseno/getWarehouseNo.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/freigthCount/freigthProductCount.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        weightStr = [[dic objectForKey:@"data"]objectForKey:@"freight"];
        [self getVouchersWithArrString:[self getVoucthersInfo]];
        
        if (voucthersDict&&[voucthersDict allKeys].count>0) {
            int type = [[voucthersDict objectForKey:@"type"]intValue];
            float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
            
            if (type ==4) {
                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
                
            }else if (type ==5)
            {
                if ([weightStr floatValue]>amount) {
                    self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]-amount];
                }else{
                    self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
                }
            }else
            {
                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]];
            }

        }else{
            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]];
        }
        
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
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
//    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/cancelOrder.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
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
    }
    else if (indexPath.section ==1)
    {
        return 100;
    }else if(indexPath.section ==2||indexPath.section==3)
    {
        return 40;
    }
    else{
        return 80;
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
    return 5;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (!addressDict||[addressDict allKeys].count==0) {
            cell.addressLabel.text = @"您还没有收货地址，请先添加。";
        }else{
        cell.titleLabel.text =[addressDict safeObjectForKey:@"receiver"];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[addressDict safeObjectForKey:@"province"]?[addressDict safeObjectForKey:@"province"]:@"",[addressDict safeObjectForKey:@"city"]?[addressDict safeObjectForKey:@"city"]:@"",[addressDict safeObjectForKey:@"county"]?[addressDict safeObjectForKey:@"county"]:@"",[addressDict safeObjectForKey:@"addr"]?[addressDict safeObjectForKey:@"addr"]:@""];
        cell.phonenumLabel.text = [[UserModel shareInstance]changeTelephone:[addressDict safeObjectForKey:@"phone"]];
        }

        return cell;
    }else if (indexPath.section ==1)
    {
        static NSString *identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic =[_dataArray objectAtIndex:indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"defPicture"]]placeholderImage:[UIImage imageNamed:@"head_default"]options:SDWebImageRetryFailed];
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        cell.priceLabel.text = @"";
//        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"unitPrice"]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"chooseCount"]];
        NSString * isgift = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"isGift"]];
        
        if ([isgift isEqualToString:@"1"]) {
            cell.zengimageView.hidden =NO;
        }else{
            cell.zengimageView.hidden =YES;
        }

        
        return cell;
    }
    else if (indexPath.section ==2){
      
        static NSString * identifier = @"PublicCell";
        PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell ) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        cell.headImageView.image = [UIImage imageNamed:@"car_"];
        cell.titleLabel.text = @"配送方式";
        cell.secondLabel.text =[NSString stringWithFormat:@"快递配送" ];
        return cell;
    }

    else if(indexPath.section ==3){
        static NSString *identifier = @"VotchersCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"优惠券";
        cell.detailTextLabel.text = vouchersNameStr?vouchersNameStr:vouchersCountStr;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }else
    {
        static NSString * identifier = @"DistributionBottomCell";
        DistributionBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell ) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        
        cell.ufLabel.text   = [NSString stringWithFormat:@"￥%.2f",[[VouchersModel shareInstance]getPayAmountWeightWithDict:voucthersDict Weight:weightStr]];
        
        cell.uhLabel.text = [NSString stringWithFormat:@"-￥%.2f",[[VouchersModel shareInstance]getUhpriceWithDict:voucthersDict weightPrice:weightStr]];
        
        cell.totoaPriceLabel.textColor = [UIColor redColor];
        cell.ufLabel.textColor = [UIColor redColor];
        cell.uhLabel.textColor = [UIColor redColor];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        AddressListViewController * address = [[AddressListViewController alloc]init];
        address.isComeFromOrder = YES;
        [self.navigationController pushViewController:address animated:YES];
    }
    else if(indexPath.section ==3)
    {
        MyVoucthersViewController * voucther = [[MyVoucthersViewController alloc]init];
        voucther.delegate = self;
        voucther.myType = IS_FROM_CONFIRM;
        voucther.chooseDict = voucthersDict;
        voucther.productArr = [self getVoucthersInfo];
        [self.navigationController pushViewController:voucther animated:YES];
        
    }
}
-(NSString * )getVoucthersInfo
{
    NSMutableArray * vouArr = [NSMutableArray array];
    NSDictionary  *dict = [self.dataArray objectAtIndex:0];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:[dict safeObjectForKey:@"unitPrice"] forKey:@"productPrice"];
    [dic safeSetObject:[dict safeObjectForKey:@"productNo"] forKey:@"productNo"];
    [dic safeSetObject:[dict safeObjectForKey:@"productName"] forKey:@"productName"];
    [dic safeSetObject:[dict safeObjectForKey:@"chooseCount"] forKey:@"quantity"];
    [dic safeSetObject:weightStr forKey:@"itemTotalPrice"];
    [vouArr addObject:dic];
    return [self DataTOjsonString:vouArr];
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
    
    
    if (!addressDict||[addressDict allKeys].count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择地址"];
        return;
    }
    
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:[addressDict objectForKey:@"id"] forKey:@"addressId"];
    [param safeSetObject:@"2" forKey:@"freightType"];
    [param safeSetObject:@"" forKey:@"buyerRemark"];
    [param safeSetObject:self.productStr forKey:@"productArray"];
    [param safeSetObject:self.warehouseNo forKey:@"warehouseNo"];
    if (voucthersDict&&[voucthersDict allKeys].count>0) {
    [param safeSetObject:[voucthersDict safeObjectForKey:@"couponNo"] forKey:@"couponNo"];
    }
    NSString * weight = [NSString stringWithFormat:@"%.1f",[[VouchersModel shareInstance]getPayAmountWeightWithDict:voucthersDict Weight:weightStr]];
    [param safeSetObject:weight forKey:@"freight"];

    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/addDelivery.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        if (voucthersDict) {
            int type = [[voucthersDict safeObjectForKey:@"type"]intValue];
            float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
            int weightPrice = [weightStr intValue];

            if (type ==4||(type ==5&& weightPrice-amount<=0)) {
                PaySuccessViewController * paySuccess = [[PaySuccessViewController alloc]init];
                paySuccess.paySuccess = YES;
                paySuccess.orderType = 2;
                [self.navigationController pushViewController:paySuccess animated:YES];
                return ;
            }
        }
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dataDic safeObjectForKey:@"freight"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =2;
        web.opt =1;
        web.orderNo = [dataDic safeObjectForKey:@"orderNo"];
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
-(void)getVoucthersToUseWithId:(NSDictionary * )voucthersId
{
    
    if (voucthersDict&&[voucthersDict allKeys].count>0) {
        NSString * couponNo= [voucthersId safeObjectForKey:@"couponNo"];
        NSString * indexCouponNo = [voucthersDict safeObjectForKey:@"couponNo"];
        
        if ([couponNo isEqualToString:indexCouponNo]) {
            voucthersDict =nil;
            voucthersFaceValue =nil;
            voucthersCouponNo = nil;
            vouchersNameStr =nil;
            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]];

        }else{
            voucthersDict  = [NSMutableDictionary dictionaryWithDictionary:voucthersId];
            vouchersNameStr =[voucthersDict safeObjectForKey:@"grantName"];
            voucthersFaceValue =  [voucthersId safeObjectForKey:@"discountAmount"];
            voucthersCouponNo = [voucthersId safeObjectForKey:@"couponNo"];
            int type = [[voucthersDict objectForKey:@"type"]intValue];
            float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
            
            if (type ==4) {
                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
                
            }else if (type ==5)
            {
                if ([weightStr floatValue]>amount) {
                    self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]-amount];
                }else{
                    self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
                }
            }else
            {
                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]];
            }
        }
    }else{
        voucthersDict  = [NSMutableDictionary dictionaryWithDictionary:voucthersId];
        vouchersNameStr =[voucthersDict safeObjectForKey:@"grantName"];
        voucthersFaceValue =  [voucthersId safeObjectForKey:@"discountAmount"];
        voucthersCouponNo = [voucthersId safeObjectForKey:@"couponNo"];
        int type = [[voucthersDict objectForKey:@"type"]intValue];
        float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
        
        if (type ==4) {
            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
            
        }else if (type ==5)
        {
            if ([weightStr floatValue]>amount) {
                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]-amount];
            }else{
                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
            }
        }else
        {
            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[weightStr floatValue]];
        }
    }
    [self.tableview reloadData];
}
#pragma mark ----计算运费
-(NSString *)getufUpdatainfo
{
    //proviceId 省份 products
    NSMutableArray * resultArr =[NSMutableArray array];
    

    
     NSArray *titleArray = [self classifiedArray:_dataArray];
    
    
    for (int i =0; i<titleArray.count; i++) {
        NSArray  * arr = [titleArray objectAtIndex:i];
        double weight = 0.00;
        NSString * freightTemplateId ;
        for (int j =0; j<arr.count; j++) {
            
            NSDictionary * item = [arr objectAtIndex:j];
            
            int count = [[item objectForKey:@"chooseCount"] intValue];
            weight += [[item safeObjectForKey:@"productWeight"] doubleValue]*count;
            
            freightTemplateId = [item safeObjectForKey:@"freightTemplateId"];
            
        }
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:@(weight) forKey:@"weight"];
        [dic safeSetObject:freightTemplateId forKey:@"freightTemplateId"];
        if (weight>0) {
            [resultArr addObject:dic];
        }
    }

    DLog(@"计算运费参数 arr-%@",resultArr);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultArr options:NSJSONWritingPrettyPrinted error:nil];
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
//根据数组中字典中的某个参数将数组分组
-(NSArray *)classifiedArray:(NSMutableArray *)array
{
    
    NSMutableArray * classArray =[NSMutableArray array];
    NSMutableArray * currArray = [NSMutableArray array];
    NSMutableArray * perArray  = [NSMutableArray array];
    
    [perArray addObject:[array objectAtIndex:0]];
    [classArray addObject:perArray];
    
    for (int i =1; i<array.count; i++) {
        
            NSDictionary * currDic = array[i];
            BOOL isHaveSame = NO;
            for (int j = 0;j<classArray.count; j++) {
                NSMutableArray * currperArray = [classArray objectAtIndex:j];
                NSDictionary * classDict = currperArray[0];
                if ([[currDic safeObjectForKey:@"freightTemplateId"] isEqualToString:[classDict safeObjectForKey:@"freightTemplateId"]]) {
                    isHaveSame = YES;
                    [currperArray addObject:currDic];
                }
                
            }
            if (isHaveSame ==NO) {
                currArray = [NSMutableArray array];
                [currArray addObject:currDic];
                [classArray addObject:currArray];
            }
    }
    
    
 
    
    return classArray;
}

@end
