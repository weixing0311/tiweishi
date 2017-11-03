//
//  GoodsDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ADCarouselView.h"
#import "DetailCxCell.h"
#import "DecailTitleCell.h"
#import "DetailWeigthCell.h"
#import "HDCell.h"
#import "DetailReturnGoodsCell.h"
#import "GoodsDetailItem.h"
#import "ShopCarViewController.h"
#import "UpdataOrderViewController.h"
#import "CXdetailView.h"
#import "BodyFatDivisionAgreementViewController.h"
@interface GoodsDetailViewController ()<decailTitleCellDelegate>
@property (nonatomic,assign)int goodsCount;
@end

@implementation GoodsDetailViewController
{
    ADCarouselView * goodscarouselView;
    NSMutableArray * _bannerArray;
    NSMutableArray * _hdArray;
    GoodsDetailItem * item;
    CXdetailView * cuxDetailView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getgoodsCountWithNet];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    self.goodsCount =1;
    if (goodscarouselView) {
        [goodscarouselView removeFromSuperview];
    }
    _bannerArray = [NSMutableArray array];
    _hdArray = [NSMutableArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.shopCartCountLabel.hidden = YES;

    [self ChangeMySegmentStyle:self.segment2];

    self.detailView.hidden = YES;
    self.webView2.hidden = YES;
    [self initCxDetailView];
    
    
    self.segment2.selectedSegmentIndex = 0;
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [self.navigationItem setTitleView:view];
    
    UISegmentedControl * seg = [[UISegmentedControl alloc]initWithItems:@[@"商品",@"详情"]];
    seg.frame = CGRectMake(0, 0, 100, 40);
    seg.tintColor = [UIColor whiteColor];
    [seg addTarget:self action:@selector(changepage:) forControlEvents:UIControlEventValueChanged];
    seg.selectedSegmentIndex =0;
    [view addSubview:seg];
    [seg setTintColor:[UIColor clearColor]];
    [seg setBackgroundImage:[UIImage imageNamed:@"selectImg"]
                             forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    NSDictionary *segDic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:20],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    
    NSDictionary *segDic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:17],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [seg setTitleTextAttributes:segDic2 forState:UIControlStateNormal];
    [seg setTitleTextAttributes:segDic1 forState:UIControlStateSelected];
    

//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIColor darkGrayColor],UITextAttributeTextShadowColor ,nil];
//    [self.segment2 setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    [self getInfo];
    [self getgoodsCountWithNet];
    [self getImageAndTextWithNet];
    // Do any additional setup after loading the view from its nib.
}
-(void)initCxDetailView
{
    cuxDetailView = [[CXdetailView alloc]initWithFrame:self.view.bounds];
    cuxDetailView.hidden = YES;
    [self.view addSubview:cuxDetailView];
}

-(void)changepage:(UISegmentedControl*)seg
{
    if (seg.selectedSegmentIndex ==0) {
        self.detailView.hidden = YES;
        self.tableview.hidden =NO;
    }else{
        self.detailView.hidden =NO;
        self.tableview.hidden = YES;
        
    }
}
-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param setObject:self.productNo forKey:@"productNo"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.currentTasks = [[BaseSservice sharedManager]post1:kProductsDetail HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        item = [[GoodsDetailItem alloc]init ];
        [item setupInfoWithDict:[dic objectForKey:@"data"]];
//        [itemsetupInfoWithDict:[dic objectForKey:@"data"]];
//        [carouselView setImgs: item.pictureArray];
//        [carouselView.carouselView reloadData];
        [_hdArray  addObjectsFromArray:item.promotList];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance]showInfoWithStatus:@"加载失败"];
    }];
}
//获取商品数量
-(void)getgoodsCountWithNet
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/shoppingCart/searchProductCount.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        int total = [[[dic safeObjectForKey:@"data"]safeObjectForKey:@"total"]intValue];
        if (!total||total==0) {
            self.shopCartCountLabel.hidden = YES;
        }else{
            self.shopCartCountLabel.hidden = NO;
        }
        self.shopCartCountLabel.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"]objectForKey:@"total"]];
    } failure:^(NSError *error) {
        
    }];
}
//获取详情webview
-(void)getImageAndTextWithNet
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param setObject:self.productNo forKey:@"productNo"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/product/queryAppPictureDetail.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dict = [dic objectForKey:@"data"];
        
        NSString * url1 =[dict safeObjectForKey:@"pictureDetail"];
        NSString * url2 =[dict safeObjectForKey:@"textDetail"];

        [self setWebViewWithUrl:url1 url2:url2];
        
        
    } failure:^(NSError *error) {
        
    }];

}

//加载webview
-(void)setWebViewWithUrl:(NSString *)url1 url2:(NSString *)url2
{
    [self.webView1 loadHTMLString:url1 baseURL:nil];
    [self.webView2 loadHTMLString:url2 baseURL:nil];

}

-(void)setValueInArray:(NSString *)picture
{
    if (picture.length>5) {
        [_bannerArray addObject:picture];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 140;
    }else if(indexPath.section ==1){
        return 35;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return JFA_SCREEN_WIDTH;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        goodscarouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH)];
        goodscarouselView.loop = YES;
        goodscarouselView.imgs=  item.pictureArray;
        goodscarouselView.automaticallyScrollDuration = 5;
        goodscarouselView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
        return goodscarouselView;
    }
    else{
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        if (item.promotList&&item.promotList.count>0) {
            return 1;
        }else{
        return 0;
        }
    }
//        else{
//        return 2;
//   
//    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        
        static NSString * identifier = @"DecailTitleCell";
        DecailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.titleLabel.text = item.productName;
        cell.cxtitleLabel.text = item.viceTitle;
        cell.restrictionNum = item.restrictionNum;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[item.productPrice floatValue]];
        cell.delegate = self;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

        if (item.restrictionNum==0) {
            cell.purchasingLabel.hidden = YES;
        }else{
            cell.purchasingLabel.hidden =NO;
            cell.purchasingLabel.text = [NSString stringWithFormat:@"该商品每人单笔订单限购%d件",item.restrictionNum];
        }
        
        
        return cell;
    }
//    else if (indexPath.section ==1) {
    else{
        static NSString * identifier = @"HDCell";
        HDCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray * arr = [[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil];
            cell = [arr lastObject];
        }

        NSDictionary *dic =[_hdArray objectAtIndex:0];
        int hdtype = [[dic objectForKey:@"promotionType"]intValue];
        if (hdtype ==1) {
            cell.titleLabel.text = @"满减";
        }else{
            cell.titleLabel.text= @"满赠";
        }
        cell.detailLabel.text = [dic objectForKey:@"promotionDetail"];
        return cell;
        
        
    }
//    else {
//        if (indexPath.row==0) {
//            static NSString * identifier = @"DetailWeigthCell";
//            DetailWeigthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell =[self getXibCellWithTitle:identifier];
//            }
//            cell.weigthLabel.text = [NSString stringWithFormat:@"%@kg",item.productWeight];
//            cell.selectionStyle =UITableViewCellSelectionStyleNone;
//
//            return cell;
//            
//            
//        }else{
//            static NSString * identifier = @"DetailReturnGoodsCell";
//            DetailReturnGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [self getXibCellWithTitle:identifier];
//            }
//            cell.returnGoodLabel.text = @"不支持七天无理由退货";
//            cell.selectionStyle =UITableViewCellSelectionStyleNone;
//
//            return cell;
//        }
//    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==1) {
//        cuxDetailView
        [cuxDetailView showCuxiaoTabViewWithArray:item.promotList type:2];
    }
}
-(void)changeCount:(int)count
{
    self.goodsCount = count;
}
- (IBAction)didshopCar:(id)sender {
    ShopCarViewController *sc =[[ShopCarViewController alloc]init];
    [self.navigationController pushViewController:sc animated:YES];
}

- (IBAction)addShopCar:(id)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic safeSetObject:item.productNo forKey:@"productNo"];
    [dic safeSetObject:@(self.goodsCount) forKey:@"quantity"];
    NSArray *arr = @[dic];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"jsonArray",[UserModel shareInstance].userId,@"userId", nil];
    
    NSString *jsonValue = [self DataTOjsonString:dict];
    
    [param safeSetObject:jsonValue forKey:@"jsonData"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/shoppingCart/saveShoppingCart.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"加入成功"];

        [self getgoodsCountWithNet];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshShopCart" object:nil];
        
    } failure:^(NSError *error) {
//        [[UserModel shareInstance] showErrorWithStatus:@"加入失败"];
    }];

    
}

- (IBAction)didBuy:(id)sender {
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"此页面为消费者购买专属，如需升级体脂师，请点击“去认证”" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UpdataOrderViewController *upd =[[UpdataOrderViewController alloc]init];
        
        upd.dataArray= [NSMutableArray arrayWithObject:item];
        upd.orderType =IS_FROM_GOODSDETAIL;
        upd.goodsCount = self.goodsCount;
        [upd.param safeSetObject:@([item.productPrice floatValue]*self.goodsCount) forKey:@"totalPrice"];
        [upd.param safeSetObject:@([item.productPrice floatValue]*self.goodsCount -[self getPreferentialPrice] ) forKey:@"payableAmount"];
        [upd.param safeSetObject:[self getUpdateInfo] forKey:@"orderItem"];
        
        [self.navigationController pushViewController:upd animated:YES];

    }]];
    
    
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BodyFatDivisionAgreementViewController * bf = [[BodyFatDivisionAgreementViewController alloc]init];
        [self.navigationController pushViewController:bf animated:YES];
        
    }]];
    
    [self presentViewController:al animated:YES completion:nil];

    
    
}
//获取上传数据
-(NSString *)getUpdateInfo
{
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    [dic safeSetObject:item.productNo forKey:@"productNo"];
    [dic safeSetObject:@(self.goodsCount) forKey:@"quantity"];
    
    
    [dic setObject:item.productPrice forKey:@"unitPrice"];
    NSArray *    promotArr = item.promotList;
    
    for (int i =0 ; i<promotArr.count;i++) {
        NSDictionary * promotDict = [promotArr objectAtIndex:i];
        int promotionType = [[promotDict safeObjectForKey:@"promotionType"]intValue];
        NSString * promotListId =[promotDict safeObjectForKey:@"id"];
        
        //判断是否有满减 -- 有加字段 -gift id
        if (promotionType==1) {
            int maxCount = [[promotDict safeObjectForKey:@"maxQuantity"]intValue];
            int minCount = [[promotDict safeObjectForKey:@"minQuantity"]intValue];
            if (self.goodsCount>=minCount&&self.goodsCount<maxCount) {
                [dic setObject:promotListId forKey:@"giftId"];
            }
        }
        //判断是否有满赠 有则加字段 --gift
        if (promotionType ==2) {
            NSMutableDictionary * mzDic= [NSMutableDictionary dictionary];
            NSString * giveProductNo = [NSString stringWithFormat:@"%@",[promotDict safeObjectForKey:@"giveProductNo"]];
            NSString * giveQuantity = [NSString stringWithFormat:@"%@",[promotDict safeObjectForKey:@"giveQuantity"]];
            
            [mzDic safeSetObject:promotListId forKey:@"giftId"];
            [mzDic safeSetObject:giveProductNo forKey:@"giveProductNo"];
            [mzDic safeSetObject:giveQuantity forKey:@"giveQuantity"];
            int maxCount = [[promotDict safeObjectForKey:@"maxQuantity"]intValue];
            int minCount = [[promotDict safeObjectForKey:@"minQuantity"]intValue];
            if (self.goodsCount>=minCount&&self.goodsCount<maxCount) {

            [dic safeSetObject:mzDic forKey:@"gift"];
            }
        }
    }
    
    
    NSArray *arr = @[dic];
    NSString * str =[self DataTOjsonString:arr];
    return str;
}
/**
 * 获取总价
 */
-(void)getTotoPrice
{
    
}
#pragma mark--//获取选择单种商品优惠价格

/**
 * 获取优惠价格
 */

-(int)getPreferentialPrice
{
    
    
    if (!item.promotList||item.promotList.count<1) {
        return 0;
    }
    NSArray * arr =[NSArray arrayWithArray:item.promotList];
    for (NSDictionary *dict in arr) {
        if ([[dict objectForKey:@"promotionType"]intValue]==1) {
            int maxCount = [[dict safeObjectForKey:@"maxQuantity"]intValue];
            int minCount = [[dict safeObjectForKey:@"minQuantity"]intValue];
            int reduceAmount =[[dict safeObjectForKey:@"reduceAmount"]intValue];
            if (self.goodsCount>=minCount&&self.goodsCount<maxCount) {
                return reduceAmount;
            }
        }
    }
    return 0;
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

- (IBAction)changeWebView:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex==0) {
        self.webView1.hidden = NO;
        self.webView2.hidden = YES;
    }else{
        self.webView2.hidden = NO;
        self.webView1.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [self.currentTasks cancel];
    goodscarouselView=nil;
    
}

@end
