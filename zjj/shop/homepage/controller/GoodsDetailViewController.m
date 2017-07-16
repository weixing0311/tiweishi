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
@interface GoodsDetailViewController ()<decailTitleCellDelegate>
@property (nonatomic,assign)int goodsCount;
@end

@implementation GoodsDetailViewController
{
    ADCarouselView * carouselView;
    NSMutableArray * _bannerArray;
    NSMutableArray * _hdArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    self.goodsCount =1;
    _bannerArray = [NSMutableArray array];
    _hdArray = [NSMutableArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    

    self.detailView.hidden = YES;
    self.webView2.hidden = YES;
    self.segment2.selectedSegmentIndex = 0;
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [self.navigationItem setTitleView:view];
    
    UISegmentedControl * seg = [[UISegmentedControl alloc]initWithItems:@[@"商品",@"详情"]];
    seg.frame = CGRectMake(0, 0, 100, 40);
    seg.tintColor = [UIColor whiteColor];
    [seg addTarget:self action:@selector(changepage:) forControlEvents:UIControlEventValueChanged];
    seg.selectedSegmentIndex =0;
    [view addSubview:seg];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIColor darkGrayColor],UITextAttributeTextShadowColor ,nil];
    [self.segment2 setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    
    [self getInfo];
    [self getgoodsCountWithNet];
    [self getImageAndTextWithNet];
    // Do any additional setup after loading the view from its nib.
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
    self.currentTasks = [[BaseSservice sharedManager]post1:kProductsDetail paramters:param success:^(NSDictionary *dic) {
        [[GoodsDetailItem shareInstance]setupInfoWithDict:[dic objectForKey:@"data"]];
        [_hdArray  addObjectsFromArray:[GoodsDetailItem shareInstance].promotList];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)getgoodsCountWithNet
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/shoppingCart/searchProductCount.do" paramters:param success:^(NSDictionary *dic) {
        self.shopCartCountLabel.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"]objectForKey:@"total"]];
    } failure:^(NSError *error) {
        
    }];
}
-(void)getImageAndTextWithNet
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param setObject:self.productNo forKey:@"productNo"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/product/queryAppPictureDetail.do" paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dict = [dic objectForKey:@"data"];
        
        NSString * url1 =[self getUrlWithString:[dict safeObjectForKey:@"pictureDetail"]];
        NSString * url2 =[self getUrlWithString:[dict safeObjectForKey:@"textDetail"]];

        [self setWebViewWithUrl:url1 url2:url2];
        
        
    } failure:^(NSError *error) {
        
    }];

}
-(void)setWebViewWithUrl:(NSString *)url1 url2:(NSString *)url2
{
    [self.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url1]]];
    [self.webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url2]]];
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
        return 21;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return JFA_SCREEN_WIDTH/365*235;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        carouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH)];
        carouselView.loop = YES;
        carouselView.imgs = [GoodsDetailItem shareInstance].pictureArray;
        carouselView.automaticallyScrollDuration = 5;
        carouselView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
        return carouselView;
    }
    else{
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        return _hdArray.count;
    }else{
        return 2;
   
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        
        static NSString * identifier = @"DecailTitleCell";
        DecailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.titleLabel.text = [GoodsDetailItem shareInstance].productName;
        cell.cxtitleLabel.text = [GoodsDetailItem shareInstance].viceTitle;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[GoodsDetailItem shareInstance].productPrice];
        cell.delegate = self;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if (indexPath.section ==1) {
        static NSString * identifier = @"HDCell";
        HDCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray * arr = [[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil];
            cell = [arr lastObject];
        }
        NSDictionary *dic =[_hdArray objectAtIndex:indexPath.row];
        int hdtype = [[dic objectForKey:@"promotionType"]intValue];
        if (hdtype ==1) {
            cell.titleLabel.text = @"满减";
        }else{
            cell.titleLabel.text= @"满赠";
        }
        cell.detailLabel.text = [dic objectForKey:@"promotionDetail"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

        return cell;
        
        
    }
    else {
        if (indexPath.row==0) {
            static NSString * identifier = @"DetailWeigthCell";
            DetailWeigthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell =[self getXibCellWithTitle:identifier];
            }
            cell.weigthLabel.text = [NSString stringWithFormat:@"%@kg",[GoodsDetailItem shareInstance].productWeight];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;

            return cell;
            
            
        }else{
            static NSString * identifier = @"DetailReturnGoodsCell";
            DetailReturnGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.returnGoodLabel.text = @"不支持七天无理由退货";
            cell.selectionStyle =UITableViewCellSelectionStyleNone;

            return cell;
        }
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
    [dic safeSetObject:[GoodsDetailItem shareInstance].productNo forKey:@"productNo"];
    [dic safeSetObject:@(self.goodsCount) forKey:@"quantity"];
    NSArray *arr = @[dic];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"jsonArray",[UserModel shareInstance].userId,@"userId", nil];
    
    NSString *jsonValue = [self DataTOjsonString:dict];
    
    [param safeSetObject:jsonValue forKey:@"jsonData"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/shoppingCart/saveShoppingCart.do" paramters:param success:^(NSDictionary *dic) {
        [self getgoodsCountWithNet];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshShopCart" object:nil];
        [[UserModel shareInstance] showSuccessWithStatus:@"加入成功"];
        
    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:@"加入失败"];
    }];

    
}

- (IBAction)didBuy:(id)sender {
    
    UpdataOrderViewController *upd =[[UpdataOrderViewController alloc]init];
    
    upd.dataArray= [NSMutableArray arrayWithObject:[GoodsDetailItem shareInstance]];
    upd.isComeFromShopCart =NO;
    upd.goodsCount = self.goodsCount;
    [upd.param safeSetObject:@([[GoodsDetailItem shareInstance].productPrice floatValue]*self.goodsCount) forKey:@"totalPrice"];
    [upd.param safeSetObject:@([[GoodsDetailItem shareInstance].productPrice floatValue]*self.goodsCount -[self getPreferentialPrice] ) forKey:@"payableAmount"];
    [upd.param safeSetObject:[self getUpdateInfo] forKey:@"orderItem"];
    
    [self.navigationController pushViewController:upd animated:YES];
    
}
//获取上传数据
-(NSString *)getUpdateInfo
{
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    [dic safeSetObject:[GoodsDetailItem shareInstance].productNo forKey:@"productNo"];
    [dic safeSetObject:@(self.goodsCount) forKey:@"quantity"];
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
    
    
    if (![GoodsDetailItem shareInstance].promotList||[GoodsDetailItem shareInstance].promotList.count<1) {
        return 0;
    }
    NSArray * arr =[NSArray arrayWithArray:[GoodsDetailItem shareInstance].promotList];
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
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSString * string = [self getUrlWithString:jsonString];
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSString *)getUrlWithString:(NSString *)string
{
//    NSString *str3 = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"-"];
//    NSString * str4 = [str3 stringByReplacingOccurrencesOfString:@"/>" withString:@"}"];
    NSArray  *array = [string componentsSeparatedByString:@"\""];//--分隔符
    for (NSString * str in array) {
        if ([str containsString:@"http"]) {
            return str;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
