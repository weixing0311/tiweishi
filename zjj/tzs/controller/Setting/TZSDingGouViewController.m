//
//  TZSDingGouViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDingGouViewController.h"
#import "TZSDGCell.h"
#import "TZSDGUPCell.h"
#import "AppDelegate.h"
@interface TZSDingGouViewController ()<TZSDGCellDelegate,TZSDGUPCellDelegate>

@end

@implementation TZSDingGouViewController
{
    NSMutableArray * _dataArray;
    NSMutableArray * _buyArray;
    NSMutableArray * _chooseArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务订购";
    [self setNbColor];
    _dataArray   = [NSMutableArray array];
    _chooseArray =[NSMutableArray array];
    _buyArray    = [NSMutableArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource= self;
    
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    [self getInfo];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ---网络请求

// 请求列表数据
-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [[BaseSservice sharedManager]post1:@"app/serviceOrder/getSeviceInfo.do" paramters:param success:^(NSDictionary *dic) {
        _buyArray = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"condition"];
        
        _dataArray =[[dic safeObjectForKey:@"data"]safeObjectForKey:@"productList"];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        NSDictionary *dic = error.userInfo;
        NSString * errMsg ;
        for (NSString * keystr in [dic allKeys]) {
            if ([keystr isEqualToString:@"message"]) {
                errMsg = [dic objectForKey:@"message"];
            }
        }
        if (!errMsg) {
            errMsg = @"获取失败";
        }
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAletViewWithmessage:errMsg];
    }];
    
}

//提交升级信息

-(void)updataWithConditionId:(NSString *)conId
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:conId forKey:@"conditionId"];
    [[BaseSservice sharedManager]post1:@"app/serviceOrder/upgradeFatTeacher.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"success--%@",dic);
        
    } failure:^(NSError *error) {
        DLog(@"faile:%@",error);
    }];

}


-(void)updataGoodsInfo
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_chooseArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    float  totalPrice = [self getPrice];
    float  payable = [self getAllPreferentialOrice];
    float  payableAmount = totalPrice-payable;
    
    
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    [dic setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",totalPrice] forKey:@"totalPrice"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",payableAmount] forKey:@"payableAmount"];
    [dic setObject:str forKey:@"orderItem"];
    
    
    [[BaseSservice sharedManager]post1:@"app/serviceOrder/submitServiceOrder.do" paramters:dic success:^(NSDictionary *dic) {
        DLog(@"dic --%@",dic);
        
        [_chooseArray removeAllObjects];
        self.priceLabel.text = @"订单总价：0";
        self.countLabel.text = @"已选服务：0";
        [self.tableview reloadData];
        
        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _buyArray.count;
    }else
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        return 88;
    }else{
        
        NSDictionary *dic =[_dataArray objectAtIndex:indexPath.row];
        NSArray * promotListArr = [dic objectForKey:@"promotList"];
        if (promotListArr) {
            return 88+22*promotListArr.count;
        }else{
            return 88;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        static NSString * identifier = @"TZSDGUPCell";
        TZSDGUPCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }

        NSDictionary *dict =[_buyArray objectAtIndex:indexPath.row];
        [cell.headImage setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"defPicture"]] placeholderImage:[UIImage imageNamed:@""]];
        cell.delegate = self;
        cell.tag = indexPath.row+indexPath.section *100;
        cell.titleLabel .text = [dict safeObjectForKey:@"productName"];
        cell.secondLabel.text = [dict safeObjectForKey:@"targetGrade"];
        cell.thirdLabel .text = [dict safeObjectForKey:@"currentGrade"];
        cell.priceLabel .text = [dict safeObjectForKey:@"totalPrice"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        static NSString * identifier = @"TZSDGCell";
        TZSDGCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        NSDictionary *dict =[_dataArray objectAtIndex:indexPath.row];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"defPicture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        cell.delegate = self;
        cell.tag = indexPath.row+indexPath.section *100;
        cell.titleLabel .text = [dict safeObjectForKey:@"productName"];
        cell.priceLabel.text = [dict safeObjectForKey:@"productPrice"];
        [cell setHdArray:[dict objectForKey:@"promotList"]];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
#pragma mark-- 去进货 点击事件
- (IBAction)placeTheOrder:(id)sender {
    
    if (_chooseArray.count<1) {
        return;
    }
    UIAlertController *al =[UIAlertController alertControllerWithTitle:@"" message:@"确定购买服务吗？" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updataGoodsInfo];
        
    }]];
    [self presentViewController:al animated:YES completion:nil];
}


#pragma mark ----cellDelegate
-(void)addCountWithCell:(TZSDGCell *)cell
{
    NSDictionary *dic = [_dataArray objectAtIndex:cell.tag-100];
//
    [self setInfoInChooseArr:dic add:YES];
    
    self.countLabel.text = [NSString stringWithFormat:@"已选服务:%d", [self getChooseCount]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"订单总价：%.0f，优惠价格：%.0f",[self getPrice],[self getAllPreferentialOrice]];
    
}

-(void)redCountWithCell:(TZSDGCell *)cell
{
    NSDictionary *dic = [_dataArray objectAtIndex:cell.tag-100];
    [self setInfoInChooseArr:dic add:NO];
    
    self.countLabel.text = [NSString stringWithFormat:@"已选服务:%d", [self getChooseCount]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"订单总价：%.0f，优惠价格：%.0f",[self getPrice],[self getAllPreferentialOrice]];
    
}
-(void)didBuyWithCell:(TZSDGUPCell *)cell
{
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"确定购买此服务？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dic =[_buyArray objectAtIndex:cell.tag];
        DLog(@"%@",dic);
        NSString * conditionId = [dic safeObjectForKey:@"conditionId"];
        cell.buyBtn.userInteractionEnabled = NO;
        [self updataWithConditionId:conditionId];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}

#pragma mark--添加减少选中商品数量并放置在chooseArray中
-(void)setInfoInChooseArr:(NSDictionary *)dict add:(BOOL)isAdd
{
    NSString * productNo = [dict objectForKey:@"productNo"];
    
    NSMutableDictionary * test1dic = [NSMutableDictionary dictionary];
    [test1dic setObject:[dict objectForKey:@"productNo"] forKey:@"productNo"];
    [test1dic setObject:@"1" forKey:@"quantity"];
    [test1dic setObject:[dict objectForKey:@"productPrice"] forKey:@"unitPrice"];
    if (_chooseArray.count>0) {
        
    
    for (int i =0;i<_chooseArray.count ;i++) {
        NSMutableDictionary * dic =_chooseArray[i];
        NSString * productNo1 = [dic objectForKey:@"productNo"];

        if ([productNo isEqualToString:productNo1]) {
            int count = [[dic objectForKey:@"quantity"]intValue];
            if (isAdd ==YES) {
                count ++;
                [dic setObject:@(count) forKey:@"quantity"];
            }else{
                if (count>1) {
                    count--;
                    [dic setObject:@(count) forKey:@"quantity"];
                    
                }else{
                    [_chooseArray removeObject:dic];
                }
            }
        }else{
            [_chooseArray addObject:test1dic];
        }
    }
    
    
    
    }else{
        if (isAdd==YES) {
            [_chooseArray addObject:test1dic];
        }
    }
    
    
}



#pragma mark--//获取选择单种商品优惠价格

-(int)getPreferentialPriceWithID:(NSString *)goodsId count:(int)count
{
    NSDictionary *param =[NSDictionary dictionary];
    for (NSDictionary *dic in _dataArray) {
        if ([[dic objectForKey:@"productNo"]isEqualToString:goodsId]) {
            param =[NSDictionary dictionaryWithDictionary:dic];
                }
    }
    NSArray * arr =[param objectForKey:@"promotList"];
    for (NSDictionary *dict in arr) {
        if ([[dict objectForKey:@"promotionType"]intValue]==1) {
            int maxCount = [[dict safeObjectForKey:@"maxQuantity"]intValue];
            int minCount = [[dict safeObjectForKey:@"minQuantity"]intValue];
            int reduceAmount =[[dict safeObjectForKey:@"reduceAmount"]intValue];
            if (count>=minCount&&count<maxCount) {
                return reduceAmount;
            }
        }
    }
    return 0;
}
#pragma mark--//获取总优惠价格
-(float)getAllPreferentialOrice
{
    float allprice = 0.0f;
    for (int i =0; i<_chooseArray.count; i++) {
        NSDictionary *dic = [_chooseArray objectAtIndex:i];
        int count = [[dic objectForKey:@"quantity"]intValue];
        NSString * theId = [dic objectForKey:@"productNo"];
        allprice += [self getPreferentialPriceWithID:theId count:count];
    }
    return allprice;
}

#pragma mark--  获取选择商品总价
-(float)getPrice
{
    float price=0.00f;
    
    for (int i =0; i<_chooseArray.count; i++) {
        NSDictionary * dict = [_chooseArray objectAtIndex:i];
        NSString * priceStr = [dict objectForKey:@"unitPrice"];
        int count = [[dict objectForKey:@"quantity"]intValue];
        price += [priceStr floatValue]*count;
    }
    
    return price;
}

#pragma mark--//获取选择商品数量
-(int)getChooseCount
{
    int  count =0;
    
    for (int i =0; i<_chooseArray.count; i++) {
        NSDictionary *dic = [_chooseArray objectAtIndex:i];
        int subCount = [[dic objectForKey:@"quantity"]intValue];
        count +=subCount;
    }
    
    return count;

}

@end
