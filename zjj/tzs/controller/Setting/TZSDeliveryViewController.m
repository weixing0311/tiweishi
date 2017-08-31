//
//  TZSDeliveryViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDeliveryViewController.h"
#import "TZSSendCell.h"
#import "TZSConfirmTheViewController.h"
@interface TZSDeliveryViewController ()<TZSSendCellDelegate,UITextFieldDelegate>

@end

@implementation TZSDeliveryViewController
{
    NSMutableArray * _dataArray;
    NSMutableArray * _chooseArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务配送";
    [self setNbColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    _dataArray =[NSMutableArray array];
    _chooseArray =[NSMutableArray array];
    [self getInfoList];
    
}
-(void)getInfoList
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/orderDelivery/queryUserStock.do" paramters:param success:^(NSDictionary *dic) {
        _dataArray =[[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"];
        [self.tableview reloadData];
        DLog(@"dic--%@",dic);
        /*
         "message": "查询成功！",
         "status": "success",
         "data": {
         "array": [
         {
         "productNo": "193609",
         "defPicture": "http://192.168.0.130:81/images/product/700718.jpg",
         "freightTemplateId": 1,
         "limitQuantity": 30,
         "productWeight": 1.4,
         "shippedQuantity": 0,
         "unitPrice": 1380,
         "quantity": 0,
         "productName": "皮皮虾"
         },

         */

    } failure:^(NSError *error) {
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =[_dataArray objectAtIndex:indexPath.row];
    NSString * limitQuantity =[dict safeObjectForKey:@"limitQuantity"];
    if ([limitQuantity isEqualToString:@"0"]) {
        return 90;
    }else{
    return 140;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"TZSSendCell";
    TZSSendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    NSDictionary *dict =[_dataArray objectAtIndex:indexPath.row];
    [cell.headimageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"defPicture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    
    NSString * limitQuantity =[dict safeObjectForKey:@"limitQuantity"];
    if ([limitQuantity isEqualToString:@"0"]) {
        cell.tsView.hidden = YES;
        cell.limitLabel.text = @"";

    }else{
        cell.tsView.hidden =NO;
        cell.limitLabel.text = [NSString stringWithFormat:@"每月服务配送数量不得超过%@，当月可配送%d",[dict safeObjectForKey:@"limitQuantity"],([[dict safeObjectForKey:@"limitQuantity"]intValue]-[[dict safeObjectForKey:@"shippedQuantity"]intValue])];

    }
    
    cell.titleLabel .text = [dict safeObjectForKey:@"productName"];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dict safeObjectForKey:@"unitPrice"] doubleValue]];
    cell.countLabel.text = [NSString stringWithFormat:@"库存数量%d",[[dict objectForKey:@"quantity"]intValue]];
    return cell;

}

#pragma mark ----cellDelegate

-(void)didChangeCountWithCell:(TZSSendCell*)cell
{
    NSMutableDictionary * dic = [_dataArray objectAtIndex:cell.tag];
    int LimitCount;
    int linitQuantity  =[[dic safeObjectForKey:@"limitQuantity"]intValue];
    int quantity =[[dic objectForKey:@"quantity"]intValue];

    NSString * limitQuantity =[NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"limitQuantity"]];
    if ([limitQuantity isEqualToString:@"0"]) {
        LimitCount =quantity;
    }else
    {
        if (linitQuantity>quantity) {
            LimitCount = quantity;
        }else{
            LimitCount = linitQuantity;
        }
    }
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"修改数量" message:[NSString stringWithFormat:@"单笔最大配送数量：%d",LimitCount] preferredStyle:UIAlertControllerStyleAlert];
    [al addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DLog(@"%@",al.textFields.firstObject.text);
        BOOL isNum = [self deptNumInputShouldNumber:al.textFields.firstObject.text];
        if (isNum !=YES||al.textFields.firstObject.text.length<1) {
            [[UserModel shareInstance]showInfoWithStatus:@"请输入正确的数量"];
            return ;
        }

        if ([al.textFields.firstObject.text intValue]>=0&&[al.textFields.firstObject.text intValue]<=LimitCount) {
            
            cell.numberLabel.text =al.textFields.firstObject.text;
            NSString * count = al.textFields.firstObject.text;
            [dic safeSetObject:count forKey:@"chooseCount"];
            [self setInfoInChooseArr:dic add:YES];
        }else{
            [[UserModel shareInstance]showInfoWithStatus:@"请输入正确的数量"];
            return;
        }
        
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];

}

-(void)didAddWithCell:(TZSSendCell*)cell
{
    
    NSMutableDictionary *dic = [_dataArray objectAtIndex:cell.tag];
    int LimitCount;
    int linitQuantity  =[[dic safeObjectForKey:@"limitQuantity"]intValue];
    int quantity =[[dic objectForKey:@"quantity"]intValue];
    
    NSString * limitQuantity =[NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"limitQuantity"]];
    if ([limitQuantity isEqualToString:@"0"]) {
        LimitCount =quantity;
    }else
    {
        if (linitQuantity>quantity) {
            LimitCount = quantity;
        }else{
            LimitCount = linitQuantity;
        }
    }

    int count = [cell.numberLabel.text intValue];
    if (LimitCount ==count) {
        return;
    }
    else{
        count++;
        cell.numberLabel.text =[NSString stringWithFormat:@"%d",count];
        [dic safeSetObject:@(count) forKey:@"chooseCount"];
    }
    [self setInfoInChooseArr:dic add:YES];
    
}

-(void)didRedWithCell:(TZSSendCell*)cell
{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:cell.tag];
    int count = [cell.numberLabel.text intValue];
    if (count==0) {
        return;
    }
    else{
        count--;
        [dic safeSetObject:@(count) forKey:@"chooseCount"];

        cell.numberLabel.text =[NSString stringWithFormat:@"%d",count];
    }
    [self setInfoInChooseArr:dic add:NO];
    
}
- (IBAction)didNext:(id)sender {
    
    if (_chooseArray.count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择需要配送的商品"];
        return;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_chooseArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    TZSConfirmTheViewController * uo = [[TZSConfirmTheViewController alloc]init];
    uo.hidesBottomBarWhenPushed= YES;
    uo.productStr = str;
    uo.dataArray = [self getHaveChooseArr];
    [uo.param safeSetObject:@([self getPrice]) forKey:@"totalPrice"];
    [uo.param safeSetObject:@([self getPrice]-[self getAllPreferentialOrice]) forKey:@"payableAmount"];
    [uo.param safeSetObject:str forKey:@"orderItem"];
    [self.navigationController pushViewController:uo animated:YES];

    
}
-(NSMutableArray *)getHaveChooseArr
{
    NSMutableArray * arr =[NSMutableArray array];
    for (int i =0; i<_chooseArray.count; i++) {
        NSDictionary *dic =[_chooseArray objectAtIndex:i];
        NSString *productNo = [dic objectForKey:@"productNo"];
        for (NSDictionary  * itemDic in _dataArray) {
            if ([[itemDic objectForKey:@"productNo" ] isEqualToString:productNo]) {
                [arr addObject:itemDic];
            }
        }
    }
    return arr;
}


#pragma mark--添加减少选中商品数量并放置在chooseArray中
-(void)setInfoInChooseArr:(NSDictionary *)dict add:(BOOL)isAdd
{
    NSString * productNo = [dict objectForKey:@"productNo"];
    int chooseCount = [[dict safeObjectForKey:@"chooseCount"]intValue];
    NSMutableDictionary * test1dic = [NSMutableDictionary dictionary];
    [test1dic setObject:[dict objectForKey:@"productNo"] forKey:@"productNo"];
    [test1dic setObject:@(chooseCount) forKey:@"quantity"];
    [test1dic setObject:[dict objectForKey:@"unitPrice"] forKey:@"unitPrice"];
    if (_chooseArray.count>0) {
        
        int count =0;
        
        for (int i =0;i<_chooseArray.count ;i++) {
            NSMutableDictionary * dic =_chooseArray[i];
            NSString * productNo1 = [dic objectForKey:@"productNo"];
            
            if ([productNo isEqualToString:productNo1]) {
                count = [[dic objectForKey:@"quantity"]intValue];
                [_chooseArray removeObject:dic];
            }
        }
        if (isAdd==YES) {
            [test1dic setObject:@(count+1) forKey:@"quantity"];
            
        }else{
            [test1dic setObject:@(count-1) forKey:@"quantity"];
            
        }
        [_chooseArray addObject:test1dic];
        
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


- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
