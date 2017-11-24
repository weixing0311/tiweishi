//
//  MyVoucthersViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MyVoucthersViewController.h"
#import "MyVouchersCell.h"
#import "TZSDingGouViewController.h"
#import "ShopTabbbarController.h"
#import "GoodsDetailViewController.h"
#import "TZSDeliveryViewController.h"
@interface MyVoucthersViewController ()<UITableViewDelegate,UITableViewDataSource,myVoucthersDelegate>
{
    UISegmentedControl * _segment;
    UITableView * _tableview;
    NSMutableArray * _dataArray;
    int page;
}
@end

@implementation MyVoucthersViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chooseDict = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的优惠券";
    [self setTBWhiteColor];
    _dataArray = [NSMutableArray array];
    [self createTableview];

    if (self.myType ==IS_FROM_MINE) {
        [self createSegment];
    }else{
        [self getMyUseVoucthers];
    }
    // Do any additional setup after loading the view.
}
-(void)createSegment
{
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"待使用",@"已使用",@"已过期"]];
    [_segment addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self ChangeMySegmentStyle:_segment];
    _segment.frame = CGRectMake(0, 65, JFA_SCREEN_WIDTH, 45);
    _segment.selectedSegmentIndex = 0;
    [self.view addSubview:_segment];
}

-(void)createTableview
{
    int height =0;
    if (_myType ==IS_FROM_MINE) {
        height = 110;
    }
    else{
        height = 70;
    }
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, height, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-height) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = HEXCOLOR(0xeeeeee);
    _tableview.separatorColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:_tableview];
    [self setExtraCellLineHiddenWithTb:_tableview];
    if (self.myType ==IS_FROM_MINE) {
        [self setRefrshWithTableView:_tableview];
    }
}




-(void)changePage:(UISegmentedControl*)segment
{
    [_tableview.mj_header beginRefreshing];
}

-(void)getMyVoucthersInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@(_segment.selectedSegmentIndex+1) forKey:@"status"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/coupon/queryMyCoupon.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [self hiddenEmptyView];
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        if (page ==1) {
            [_dataArray removeAllObjects];
            _tableview.mj_footer.hidden = NO;
        }
        
        NSArray * dataArr =[[dic objectForKey:@"data"]objectForKey:@"array"];
        if (dataArr.count<30) {
            _tableview.mj_footer.hidden =YES;
        }
        [_dataArray addObjectsFromArray:dataArr];
        [_tableview reloadData];

    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        if ([error code]==402&&page==1) {
            [self showEmptyViewWithTitle:@"无优惠券"];
            [self.view bringSubviewToFront:_segment];
        }
    }];
    
}

-(void)getMyUseVoucthers
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.productArr forKey:@"productArr"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/coupon/queryMyCouponByProduct.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        NSMutableArray * dataArr =[[dic objectForKey:@"data"]objectForKey:@"array"];
        [dataArr enumerateObjectsUsingBlock:^(id key, NSUInteger value, BOOL *stop) {
            NSDictionary * dict = key;
            int type = [[dict safeObjectForKey:@"type"]intValue];
            
            if (self.myType ==IS_FROM_TZSDG) {
                if (type ==4||type==5) {
                    *stop =YES;
                    if (*stop ==YES) {
                        [dataArr removeObject:dict];
                    }
                }

            }else if (self.myType ==IS_FROM_CONFIRM)
            
            if (type !=4&&type!=5) {
                *stop =YES;
                if (*stop ==YES) {
                    [dataArr removeObject:dict];
                }
            }
        }];
        [_dataArray addObjectsFromArray:dataArr];
        if (_dataArray.count==0) {
            [self showEmptyViewWithTitle:@"无可用优惠券"];
        }else{
            [self hiddenEmptyView];
        }
        [_tableview reloadData];
    } failure:^(NSError *error) {
        [self showEmptyViewWithTitle:@"暂无优惠券"];
    }];

}


-(void)headerRereshing
{
    [super headerRereshing];
    page =1;
    [self getMyVoucthersInfo];
    
}
-(void)footerRereshing
{
    [super footerRereshing];
    page ++;
    [self getMyVoucthersInfo];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MyVouchersCell";
    MyVouchersCell * cell = [_tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    
    
    
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    cell.titlelb.text = [dic safeObjectForKey:@"templateName"];
    cell.timelb.text = [NSString stringWithFormat:@"有效期至:%@",[dic safeObjectForKey:@"validEndTime"]];
    
    
    int type = [[dic safeObjectForKey:@"type"]intValue];
    if (type ==2) {
        cell.faceValuelb.text = [NSString stringWithFormat:@"%.0f折",[[dic safeObjectForKey:@"discountAmount"]floatValue]*10];
    }else{
        cell.faceValuelb.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"discountAmount"]];
    }
    if (_segment) {
        if (_segment.selectedSegmentIndex==1) {
            cell.statusImage.hidden= NO;
            cell.statusImage.image = getImage(@"vouchersHasBeenUserd_");
            cell.didUseBtn.hidden = YES;
        }else if (_segment.selectedSegmentIndex ==2)
        {
            cell.statusImage.hidden= NO;
            cell.statusImage.image = getImage(@"vouchersexpried_");
            cell.didUseBtn.hidden = YES;

        }else{
            cell.statusImage.hidden= YES;
            cell.didUseBtn.hidden = NO;

        }
    }else{
        cell.statusImage.hidden= YES;
        cell.didUseBtn.hidden = YES;


    }
    
    
//    cell.faceValuelb.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"discountAmount"]];
    
    //useRange//使用范围 0全部商品 1脂将军饼干 2 体脂称
    int userRange = [[dic safeObjectForKey:@"useRange"]intValue];
    if (userRange ==1) {
        cell.limitGoodslb.text =@"仅限脂将军饼干使用";
    }
    else if(userRange ==2)
    {
        cell.limitGoodslb.text = @"仅限脂将军饼干使用";
    }else
    {
        cell.limitGoodslb.text = @"(无限制)";
    }
    
    int startAmount = [[dic safeObjectForKey:@"startAmount"]intValue];
    if (!startAmount||startAmount ==0) {
        cell.limitPricelb.text = @"(无限制)";
    }else{
        cell.limitPricelb.text = [NSString stringWithFormat:@"满%d可用",startAmount];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    if (self.chooseDict) {
        NSString * couponNo= [self.chooseDict safeObjectForKey:@"couponNo"];
        NSString * indexCouponNo = [dic safeObjectForKey:@"couponNo"];
        if ([couponNo isEqualToString:indexCouponNo]) {
            cell.didChooseImage.hidden = NO;
        }else{
            cell.didChooseImage.hidden = YES;
        }
    }else{
        cell.didChooseImage.hidden = YES;
    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    
    if (self.myType!=IS_FROM_MINE) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(getVoucthersToUseWithId:)]) {
            [self.delegate getVoucthersToUseWithId:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark ---cellDelegate

-(void)didUserVoucherWithCell:(MyVouchersCell*)cell
{
    NSDictionary * dic = [_dataArray objectAtIndex:cell.tag];
    int type = [[dic safeObjectForKey:@"type"]intValue];
    NSString * useRange = [dic safeObjectForKey:@"useRange"];
    
    if ([[UserModel shareInstance].tabbarStyle isEqualToString:@"health"]) {
        return;
    }
    else if ([[UserModel shareInstance].tabbarStyle isEqualToString:@"shop"])
    {
        
        NSArray * arr = [dic safeObjectForKey:@"products"];
        if (arr.count==1) {
            NSDictionary * goodsDict = arr[0];
            NSString * productNo = [goodsDict safeObjectForKey:@"productNo"];
            GoodsDetailViewController * goodsd =[[GoodsDetailViewController alloc]init];
            goodsd.productNo = productNo;
            [self.navigationController pushViewController:goodsd animated:YES];
        }
        else{//全部商品
            ShopTabbbarController * shop = [[ShopTabbbarController alloc]init];
            self.view.window.rootViewController = shop;
        }
    }
    
    else if ([[UserModel shareInstance].tabbarStyle isEqualToString:@"tzs"])
    {
        if (type ==4||type==5) {
            TZSDeliveryViewController * com = [[TZSDeliveryViewController alloc]init];
            [self.navigationController pushViewController:com animated:YES];
        }else{
            TZSDingGouViewController * tzsDG = [[TZSDingGouViewController alloc]init];
            [self.navigationController pushViewController:tzsDG animated:YES];
        }
    }

    
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