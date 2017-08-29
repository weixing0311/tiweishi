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
#import "CXdetailView.h"
#import "AppDelegate.h"
#import "BaseWebViewController.h"
@interface TZSDingGouViewController ()<TZSDGCellDelegate,TZSDGUPCellDelegate,UITextFieldDelegate>

@end

@implementation TZSDingGouViewController
{
    NSMutableArray * _dataArray;
    NSMutableArray * _buyArray;
    NSMutableArray * _chooseArray;
    CXdetailView * cuxiaoDetailView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    cuxiaoDetailView = [[CXdetailView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-64)];
    cuxiaoDetailView.hidden = YES;
    [self.view addSubview:cuxiaoDetailView];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    
    
    
    [self getInfo];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ---网络请求

// 请求列表数据
-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/serviceOrder/getSeviceInfo.do" paramters:param success:^(NSDictionary *dic) {
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/serviceOrder/upgradeFatTeacher.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"success--%@",dic);
        
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =3;
        web.opt =1;
        web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
        
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
    
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/serviceOrder/submitServiceOrder.do" paramters:dic success:^(NSDictionary *dic) {
        DLog(@"dic --%@",dic);
        
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        
        [_chooseArray removeAllObjects];
        self.priceLabel.text = @"合计：￥0.00";
        self.countLabel.text = @"总额:￥0.00 优惠:￥0.00";
        [self.tableview reloadData];
        
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =3;
        web.opt =1;
        web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
        
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
        if (promotListArr&&promotListArr.count>0) {
            return 88+30;
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
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"defPicture"]] placeholderImage:[UIImage imageNamed:@""]];
        cell.delegate = self;
        cell.tag = indexPath.row+indexPath.section *100;
        cell.titleLabel .text = [dict safeObjectForKey:@"productName"];
        cell.secondLabel.text = [NSString stringWithFormat:@"直升%@",[dict safeObjectForKey:@"targetGrade"]];
//        cell.thirdLabel .text = [dict safeObjectForKey:@"currentGrade"];
        cell.priceLabel .text = [NSString stringWithFormat:@"￥%.2f",[[dict safeObjectForKey:@"totalPrice"]floatValue]];
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
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"defPicture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        cell.delegate = self;
        cell.tag = indexPath.row+indexPath.section *100;
        cell.titleLabel .text = [dict safeObjectForKey:@"productName"];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dict safeObjectForKey:@"productPrice"]floatValue]];
        NSArray * array = [dict objectForKey:@"promotList"];
        if (array&& array.count>0) {
            cell.cxView.hidden= NO;
            NSDictionary *dic =[array objectAtIndex:0];
            int hdtype = [[dic objectForKey:@"promotionType"]intValue];
            if (hdtype ==1) {
                cell.cxImageLabel.text = @"满减";
            }else{
                cell.cxImageLabel.text= @"满赠";
            }
            cell.cxDetailLabel.text = [dic objectForKey:@"promotionDetail"];
        }else{
            cell.cxView.hidden =YES;
        }
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

-(void)changeBottomInfo
{
    self.countLabel.text = [NSString stringWithFormat:@"总额：￥%.2f，优惠：￥%.2f",[self getPrice],[self getAllPreferentialOrice]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"合计:￥%.2f", [self getPrice]-[self getAllPreferentialOrice]];

}
#pragma mark ----cellDelegate

-(void)showCXDetailWithCell:(TZSDGCell * )cell
{
    NSDictionary *dic = [_dataArray objectAtIndex:cell.tag-100];
    [cuxiaoDetailView showCuxiaoTabViewWithArray:[dic safeObjectForKey:@"promotList"] ];
}
-(void)addCountWithCell:(TZSDGCell *)cell
{
    NSDictionary *dic = [_dataArray objectAtIndex:cell.tag-100];
//
    [self setInfoInChooseArr:dic add:YES];
    [self changeBottomInfo];
    
}

-(void)redCountWithCell:(TZSDGCell *)cell
{
    NSDictionary *dic = [_dataArray objectAtIndex:cell.tag-100];
    [self setInfoInChooseArr:dic add:NO];
    
 
    [self changeBottomInfo];
}
-(void)didChangeCountWithCell:(TZSDGCell * )cell
{
    
    NSDictionary * dic = [_dataArray objectAtIndex:cell.tag-100];
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"修改数量" message:@"单笔最大购买数量：200" preferredStyle:UIAlertControllerStyleAlert];
    [al addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DLog(@"%@",al.textFields.firstObject.text);
        if (al.textFields.firstObject.text.length<1) {
            return ;
        }
        if ([al.textFields.firstObject.text intValue]>=0&&[al.textFields.firstObject.text intValue]<=200) {
            cell.countLabel.text = al.textFields.firstObject.text;
            [self changeChooseArrWithDict:dic Count:[al.textFields.firstObject.text intValue]];
            [self changeBottomInfo];
        }
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:al animated:YES completion:nil];
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

-(void)changeChooseArrWithDict:(NSDictionary *)dict Count:(int)count
{
    NSString * productNo = [dict objectForKey:@"productNo"];
    NSMutableDictionary * test1dic = [NSMutableDictionary dictionary];
    [test1dic setObject:[dict objectForKey:@"productNo"] forKey:@"productNo"];
    [test1dic setObject:@(count) forKey:@"quantity"];
    [test1dic setObject:[dict objectForKey:@"productPrice"] forKey:@"unitPrice"];
    for (int i =0;i<_chooseArray.count ;i++) {
        NSMutableDictionary * dic =_chooseArray[i];
        NSString * productNo1 = [dic objectForKey:@"productNo"];
        
        if ([productNo isEqualToString:productNo1]) {
            count = [[dic objectForKey:@"quantity"]intValue];
            [_chooseArray removeObject:dic];
            
        }
    }
    if (count!=0) {
        [_chooseArray addObject:test1dic];
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
