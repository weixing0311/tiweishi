//
//  ShopCarViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShopCarViewController.h"
#import "shopCarCellItem.h"
#import "UpdataOrderViewController.h"
#import "CXdetailView.h"
#import "BaseWebViewController.h"
#import "BodyFatDivisionAgreementViewController.h"
@interface ShopCarViewController ()
@property (nonatomic ,strong)NSMutableArray * dataArray;//列表数据
@property (nonatomic ,strong)UIButton * editBtn;
@property (nonatomic ,strong)NSMutableArray * chooseArray;//选择数据
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@end

@implementation ShopCarViewController
{
    CXdetailView * cuxiaoDetailView ;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCarInfo];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    self.title = @"购物车";
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCarInfo) name:@"refreshShopCart" object:nil];
    self.tableView .delegate =self;
    self.tableView.dataSource = self;

    self.dataArray =[ NSMutableArray array];
    self.chooseArray =[NSMutableArray array];
    [self setExtraCellLineHiddenWithTb:self.tableView];
    [self buildcuxiaoDetailView];
    self.priceDetailLb.adjustsFontSizeToFitWidth = YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)buildcuxiaoDetailView
{
    cuxiaoDetailView =[[CXdetailView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-64)];
    cuxiaoDetailView.hidden = YES;
    [self.view addSubview:cuxiaoDetailView];
}
-(void)getCarInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/shoppingCart/searchProductList.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        self.emptyView.hidden =YES;
            [self.dataArray removeAllObjects];
            NSArray *arr =[[dic objectForKey:@"data" ]objectForKey:@"productArray"];
            for (NSDictionary *dict in arr) {
                shopCarCellItem *item = [[shopCarCellItem alloc]init];
                [item setupInfoWithDict:dict];
                [self.dataArray addObject:item];
            }
            [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        if ([error code]==402) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            self.emptyView.hidden =NO;
            [self.view bringSubviewToFront:self.emptyView];
        }
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    shopCarCellItem *item = [self.dataArray objectAtIndex:indexPath.row];
    NSArray * promotTitle = item.promotTitle;
    if (promotTitle&&promotTitle.count>0) {
        return 140;
    }else{
        return 100;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"cell";
    ShopCarCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        NSArray *arr =[[NSBundle mainBundle]loadNibNamed:@"ShopCarCell" owner:nil options:nil];
        cell = [arr lastObject];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    shopCarCellItem *item = [self.dataArray objectAtIndex:indexPath.row];
    [cell setUpWithItem:item];
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
#pragma mark ----celldelegate
//点选cell
-(void)showCuXiaoDetailViewWithCell:(ShopCarCell *)cell
{
    shopCarCellItem *item = [self.dataArray objectAtIndex:cell.tag];

    NSArray * arr = [NSArray arrayWithArray:item.promotTitle];
    [cuxiaoDetailView showCuxiaoTabViewWithArray:arr type:2];
}
-(void)getCountWithCell:(ShopCarCell *)cell type:(BOOL)type
{
    shopCarCellItem *item = [self.dataArray objectAtIndex:cell.tag];

    
    if (type==YES) {
        [self setInfoInChooseArr:item];
    }else{
        for (int i =0; i<_chooseArray.count; i++) {
            NSDictionary *dic =[_chooseArray objectAtIndex:i];
            if ([[dic objectForKey:@"productNo"] isEqualToString:item.productNo]) {
                [_chooseArray removeObject:dic];
            }
        }
    }

    

    [self changePriceIsNull:NO];
//    self.priceLabel.text = [NSString stringWithFormat:@"%.0f元",[self getPrice]-[self getAllPreferentialOrice]];
//    self.priceDetailLb.text = [NSString stringWithFormat:@"总额:￥%.1f 立减:￥%.1f",[self getPrice],[self getAllPreferentialOrice]];
//
//    [self.settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",[self getChooseCount]] forState:UIControlStateNormal];
    
    if (_chooseArray.count ==_dataArray.count) {
        self.chooseBtn.selected =YES;
    }else{
        self.chooseBtn.selected =NO;
    }
    
}
//加减数量
-(void)getCellGoodsCountWithCell:(ShopCarCell *)cell count:(int)count
{
    shopCarCellItem * shopItem = [self.dataArray objectAtIndex:cell.tag];
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:shopItem.productNo forKey:@"productNo"];
    [dic setObject:@(count) forKey:@"quantity"];
    [dic setObject:[UserModel shareInstance].userId forKey:@"userId"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [param setObject:str forKey:@"jsonData"];
    DLog(@"%@---%@",str,param);
    [[BaseSservice sharedManager] post1:@"app/order/shoppingCart/updateShoppingCart.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
        [self.dataArray removeAllObjects];
        
        NSArray * arr = [dataDic safeObjectForKey:@"productArray"];
        for (int i =0; i<arr.count; i++) {
            NSDictionary * itemDict =arr[i];
            shopCarCellItem *item = [[shopCarCellItem alloc]init];
            [item setupInfoWithDict:itemDict];
            [self.dataArray addObject:item];
        }
        shopCarCellItem * currentItem = [self.dataArray objectAtIndex:cell.tag];
        if (cell.chooseBtn.selected==NO) {
            cell.chooseBtn.selected =YES;
        }
        [self ChangeTotaPriceWithItem:currentItem];
    } failure:^(NSError *error) {
        shopCarCellItem * item = [self.dataArray objectAtIndex:cell.tag];
        cell.countLabel.text = item.quantity;
    }];
}
-(void)ChangeTotaPriceWithItem:(shopCarCellItem *)currentItem
{
    [self setInfoInChooseArr:currentItem];
    
    [self changePriceIsNull:NO];
//    self.priceLabel.text = [NSString stringWithFormat:@"%.0f元",[self getPrice]-[self getAllPreferentialOrice]];
//    self.priceDetailLb.text = [NSString stringWithFormat:@"总额:￥%.1f 立减:￥%.1f",[self getPrice],[self getAllPreferentialOrice]];
//    [self.settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",[self getChooseCount]] forState:UIControlStateNormal];
}
-(void)deleteCell:(ShopCarCell*)cell
{
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        shopCarCellItem * item = [_dataArray objectAtIndex:cell.tag];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic safeSetObject:item.productNo forKey:@"productNo"];
        NSArray *arr = @[dic];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"productList",[UserModel shareInstance].userId,@"userId", nil];
        
        NSString *jsonValue = [self DataTOjsonString:dict];
        
        [param safeSetObject:jsonValue forKey:@"jsonData"];
        DLog(@"%@--jsonvalue:%@",param,jsonValue);
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/shoppingCart/delShoppingCart.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
            
            
            [self.dataArray removeObject:item];
            
            for (int i =0;i<self.chooseArray.count;i++) {
                NSDictionary * chooseDic = [self.chooseArray objectAtIndex:i];
                if ([[chooseDic safeObjectForKey:@"productNo"] isEqualToString:item.productNo]) {
                    [self.chooseArray removeObject:chooseDic];
                }
            }
            
            
            [self changePriceIsNull:NO];
//            [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:cell.tag inSection:0 ]] withRowAnimation:UITableViewRowAnimationLeft];  //删除对应数据的cell
            [[UserModel shareInstance]showSuccessWithStatus:@""];
            
            
        [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            if ([error code]==402) {
                [self.dataArray removeAllObjects];
                [self.chooseArray removeAllObjects];
                [self changePriceIsNull:YES];
                self.chooseBtn.selected = NO;
                [self.tableView reloadData];
                self.emptyView.hidden =NO;
                [self.view bringSubviewToFront:self.emptyView];
                
            }
            
        }];

    }]];
    
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
    
}
- (IBAction)didSettlement:(id)sender {
    
    if (self.chooseArray.count==0) {
        return;
    }
    
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"此页面为消费者购买专属，如需升级体脂师，请点击“去认证”" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_chooseArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        
        
        UpdataOrderViewController *uo = [[UpdataOrderViewController alloc]init];
        uo.orderType = IS_FROM_SHOPCART;
        uo.hidesBottomBarWhenPushed= YES;
        uo.dataArray = [self getHaveChooseArr];
        [uo.param safeSetObject:@([self getPrice]) forKey:@"totalPrice"];
        [uo.param safeSetObject:@([self getPrice]-[self getAllPreferentialOrice]) forKey:@"payableAmount"];
        [uo.param safeSetObject:str forKey:@"orderItem"];
        
        [self.chooseArray removeAllObjects];
        self.chooseBtn.selected = NO;
        //需要下一级页面推送通知
        [self.navigationController pushViewController:uo animated:YES];
        [self changePriceIsNull:YES];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.chooseBtn.selected = NO;
        [self.chooseArray removeAllObjects];
        [self changePriceIsNull:YES];

        BodyFatDivisionAgreementViewController * bf = [[BodyFatDivisionAgreementViewController alloc]init];
        [self.navigationController pushViewController:bf animated:YES];
        
    }]];
    
    [self presentViewController:al animated:YES completion:nil];
    
    
    
    
    
//    self.priceLabel.text = [NSString stringWithFormat:@"0元"];
//    self.priceDetailLb.text = @"";
//    
//    [self.settlementBtn setTitle:[NSString stringWithFormat:@"结算(0)"] forState:UIControlStateNormal];

    
}

/**
 *修改价格条
 */
-(void)changePriceIsNull:(BOOL)isNull
{
    if (isNull) {
        self.priceLabel.text = @"0.00元";
        self.priceDetailLb.text = @"总额：￥0.00 立减：￥0.00";
        [self.settlementBtn setTitle:@"去结算(0)" forState:UIControlStateNormal];
        

    }else{
        
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",[self getPrice]-[self getAllPreferentialOrice]];
    self.priceDetailLb.text = [NSString stringWithFormat:@"总额:￥%.2f 立减:￥%.2f",[self getPrice],[self getAllPreferentialOrice]];
    
    [self.settlementBtn setTitle:[NSString stringWithFormat:@"去结算(%d)",[self getChooseCount]] forState:UIControlStateNormal];
    }
}

-(NSMutableArray *)getHaveChooseArr
{
    NSMutableArray * arr =[NSMutableArray array];
    for (int i =0; i<_chooseArray.count; i++) {
        NSDictionary *dic =[_chooseArray objectAtIndex:i];
        NSString *productNo = [dic objectForKey:@"productNo"];
        for (shopCarCellItem * item in _dataArray) {
            if ([item.productNo isEqualToString:productNo]) {
                [arr addObject:item];
            }
        }
    }
    return arr;
}
- (IBAction)didChoose:(UIButton *)sender {
    if (!self.dataArray|| self.dataArray.count<1) {
        return;
    }
    [self.chooseArray removeAllObjects];
    if (self.chooseBtn.selected==YES) {
        self.chooseBtn.selected = NO;
        [self changePriceIsNull:YES];
        [self.chooseArray removeAllObjects];
    }else{
        
        self.chooseBtn.selected = YES;
        for (shopCarCellItem * item in _dataArray) {
            [self setInfoInChooseArr:item];
         }
        
        
        [self changePriceIsNull:NO];
        
//        self.priceLabel.text = [NSString stringWithFormat:@"%.0f元",[self getPrice]-[self getAllPreferentialOrice]];
//        self.priceDetailLb.text = [NSString stringWithFormat:@"总额:￥%.1f 立减:￥%.1f",[self getPrice],[self getAllPreferentialOrice]];
//
//        [self.settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",[self getChooseCount]] forState:UIControlStateNormal];

    }
    for ( int i =0; i<self.dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];

        ShopCarCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.chooseBtn.selected = self.chooseBtn.selected;
    }
}

#pragma mark--添加减少选中商品数量并放置在chooseArray中
-(void)setInfoInChooseArr:(shopCarCellItem *)item
{
    NSString * productNo = item.productNo;
    int count = [item.quantity intValue] ;
    NSMutableDictionary * test1dic = [NSMutableDictionary dictionary];
    [test1dic setObject:item.productNo forKey:@"productNo"];
    [test1dic setObject:@(count) forKey:@"quantity"];
    [test1dic setObject:item.productPrice forKey:@"unitPrice"];
    NSArray *    promotArr = item.promotList;
    
    
    for (int i =0 ; i<promotArr.count;i++) {
        NSDictionary * promotDict = [promotArr objectAtIndex:i];
        int promotionType = [[promotDict safeObjectForKey:@"promotionType"]intValue];
        NSString * promotListId =[promotDict safeObjectForKey:@"id"];
        
        
        if (promotionType==1) {
            [test1dic setObject:promotListId forKey:@"giftId"];
        }
        if (promotionType ==2) {
            NSMutableDictionary * mzDic= [NSMutableDictionary dictionary];
            NSString * giveProductNo = [NSString stringWithFormat:@"%@",[promotDict safeObjectForKey:@"giveProductNo"]];
            NSString * giveQuantity = [NSString stringWithFormat:@"%@",[promotDict safeObjectForKey:@"giveQuantity"]];

            [mzDic safeSetObject:promotListId forKey:@"giftId"];
            [mzDic safeSetObject:giveProductNo forKey:@"giveProductNo"];
            [mzDic safeSetObject:giveQuantity forKey:@"giveQuantity"];
            [test1dic safeSetObject:mzDic forKey:@"gift"];
         }
    }


    
        for (int i =0;i<_chooseArray.count ;i++) {
            NSMutableDictionary * dic =_chooseArray[i];
            NSString * productNo1 = [dic objectForKey:@"productNo"];
            
            if ([productNo isEqualToString:productNo1]) {
                [_chooseArray removeObject:dic];
                }
            }
             [_chooseArray addObject:test1dic];
}


#pragma mark--//获取选择单种商品优惠价格

-(int)getPreferentialPriceWithID:(NSString *)goodsId count:(int)count
{
    shopCarCellItem * item1= [[shopCarCellItem alloc]init];
    for (int i =0;i<_dataArray.count;i++) {
        shopCarCellItem * item  = _dataArray[i];        
        if ([item.productNo isEqualToString:goodsId]) {
            item1 =item;
        }
    }
    
    NSArray * arr =[NSArray arrayWithArray:item1.promotList];
    DLog(@"%@",arr);
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
