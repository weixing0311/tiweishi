//
//  IntegralOrderUpdateViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/22.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralOrderUpdateViewController.h"
#import "AddressListViewController.h"
#import "BaseWebViewController.h"
#import "UpdataAddressCell.h"
#import "UpDateOrderCell.h"
#import "PublicCell.h"
@interface IntegralOrderUpdateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation IntegralOrderUpdateViewController
{
    NSMutableDictionary * addressDict;
    NSString * warehouseNo;//仓储编号


}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoDict =[NSMutableDictionary dictionary];
        self.param = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交订单";
    [self setTBRedColor];
    
    addressDict  = [NSMutableDictionary dictionary];
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddress:) name:kSendAddress object:nil];

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self getDefaultAddressFromNet];
    NSString * priceStr = [_infoDict safeObjectForKey:@"productPrice"];

    NSString * integral = [_infoDict safeObjectForKey:@"productIntegral"];
    if (integral.intValue>0&&priceStr.intValue>0) {
        self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f+%@积分",[priceStr floatValue],integral];
        

    }else{
        if (integral.intValue>0) {
            self.priceLabel.text =[NSString stringWithFormat:@"实付款：%@分",integral];

        }else{
            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[priceStr floatValue]];
        }

    }


}
#pragma mark ---notifation
-(void)getAddress:(NSNotification*)noti
{
    [addressDict setDictionary:noti.userInfo];
    [self getwarehousingWithproviceId:[addressDict objectForKey:@"provinceId"]];

    [self.tableview reloadData];
}
#pragma mark --接口

//获取默认地址
-(void)getDefaultAddressFromNet
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/getDefaultAddress.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"success --%@",dic);
        [addressDict setDictionary:[dic objectForKey:@"data"]];
        [self.tableview reloadData];
        
        NSString * isWarehouseSend = [self.infoDict safeObjectForKey:@"isWarehouseSend"];
        if (isWarehouseSend&&![isWarehouseSend isEqualToString:@"0"]) {
            [self getwarehousingWithproviceId:[addressDict safeObjectForKey:@"provinceId"]];

        }else{
            warehouseNo =@"000000";
        }
        
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
        warehouseNo = [dict safeObjectForKey:@"warehouseNo"];
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
    }];
    
}

#pragma mark--获取仓储接口上传数据
/**
 *获取仓储接口提交数据
 */
-(NSString *)getWarehousingUpdateInfo
{
    
    
    NSMutableArray * arr=[NSMutableArray array];
    
    NSString *  productNo  =[self.infoDict objectForKey:@"productNo"] ;
    NSString * quantity = [NSString stringWithFormat:@"%d",self.goodsCount];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict safeSetObject:productNo forKey:@"productNo"];
    [dict safeSetObject:quantity forKey:@"quantity"];
    [arr addObject:dict];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DLog(@"仓储上传信息--%@",str);
    return str;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==1)
    {
        return 1;
    }
    else if (section ==3)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString *identifier = @"UpdataAddressCell";
        UpdataAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        if (!addressDict||[addressDict allKeys].count==0) {
            cell.addressLabel.text = @"您还没有收货地址，请先添加。";
        }else{
            
            cell.titleLabel.text = [addressDict safeObjectForKey:@"receiver"];
            cell.phonenumLabel.text = [[UserModel shareInstance]changeTelephone:[addressDict safeObjectForKey:@"phone"]];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[addressDict safeObjectForKey:@"province"]?[addressDict safeObjectForKey:@"province"]:@"",[addressDict safeObjectForKey:@"city"]?[addressDict safeObjectForKey:@"province"]:@"",[addressDict safeObjectForKey:@"county"]?[addressDict safeObjectForKey:@"county"]:@"",[addressDict safeObjectForKey:@"addr"]?[addressDict safeObjectForKey:@"addr"]:@""];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else if (indexPath.section ==1)
    {
        static NSString *identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        [cell setUpCellWithDict:self.infoDict];
        cell.countLabel.text = [NSString stringWithFormat:@"x%d",self.goodsCount];
        return cell;
        
    }else if (indexPath.section ==2){
        static NSString *identifier = @"PublicCell";
        PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.headImageView.image = [UIImage imageNamed:@"car_"];
        cell.titleLabel.text = @"配送方式";
        cell.secondLabel.text =@"快递配送";
        return cell;
        
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.detailTextLabel.textColor =[UIColor redColor];
        if (indexPath.row ==0) {
            cell.textLabel.text = @"商品金额";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"+￥%.0f",[[self.param objectForKey:@"totalPrice"]floatValue]];
        }else if (indexPath.row ==1)
        {
            cell.textLabel.text = @"立减";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"-￥%.00f",[[self.param objectForKey:@"totalPrice"]floatValue]-[[self.param objectForKey:@"payableAmount"]floatValue]];
        }else{
            cell.textLabel.text = @"运费";
            cell.detailTextLabel.text = @"免运费";
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==0) {
        AddressListViewController *add = [[AddressListViewController alloc]init];
        add.isComeFromOrder = YES;
        [self.navigationController pushViewController:add animated:YES];
    }
    else if (indexPath.section ==1)
    {
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 80;
    }else if (indexPath.section ==1)
    {
        return 100;
    }else{
        return 44;
    }
}
- (IBAction)didBuy:(id)sender {
    
    
    if (!addressDict||[addressDict allKeys].count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择地址"];
        return;
    }
    
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"receiver"] forKey:@"consigneeName"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"phone"] forKey:@"consigneePhone"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"addr"] forKey:@"consigneeAddress"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"provinceId"] forKey:@"province"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"cityId"] forKey:@"city"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"countyId"] forKey:@"county"];
    
    
    [self.param safeSetObject:[self.infoDict safeObjectForKey:@"productPrice"] forKey:@"totalPrice"];
    [self.param safeSetObject:[self.infoDict safeObjectForKey:@"productPrice"] forKey:@"payableAmount"];
    
    [self.param safeSetObject:warehouseNo forKey:@"warehouseNo"];
    
    [self.param safeSetObject:[self.infoDict safeObjectForKey:@"productIntegral"] forKey:@"integral"];
    
    
    DLog(@"上传数据---%@",self.param);
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/order/saveOrderInfo.do" paramters:self.param success:^(NSDictionary *dic) {
        DLog(@"下单成功--%@",dic);
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        
        [[UserModel shareInstance]showSuccessWithStatus:@"提交成功"];
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值 5积分购买
        web.payType =5;
        web.opt =1;
        web.integral = @"1";
        web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
        
        
        
        
    } failure:^(NSError *error) {
        //        [[UserModel shareInstance]showErrorWithStatus:@"提交失败"];
        
        DLog(@"下单失败--%@",error);
    }];
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
