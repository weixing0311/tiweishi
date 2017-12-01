//
//  VouchersGetViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersGetViewController.h"
#import "VouchersCell.h"
#import "MyVoucthersViewController.h"
@interface VouchersGetViewController ()<UITableViewDelegate,UITableViewDataSource,VouchersCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation VouchersGetViewController
{
    int page;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title  = @"领券中心";
    [self setTBWhiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor =HEXCOLOR(0xeeeeee);
    self.tableview.separatorColor = HEXCOLOR(0xeeeeee);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [NSMutableArray array];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(didEnterMyVouchersPage)];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    // Do any additional setup after loading the view from its nib.
}

-(void)didEnterMyVouchersPage
{
    MyVoucthersViewController * myv = [[MyVoucthersViewController alloc]init];
    myv.myType =self.myType;
    [self.navigationController pushViewController:myv animated:YES];
}
-(void)getVouchListInfo
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/coupon/queryCouponList.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (page ==1) {
            [_dataArray removeAllObjects];
            _tableview.mj_footer.hidden = NO;
        }
        
        NSArray * dataArr =[[dic objectForKey:@"data"]objectForKey:@"array"];
        if (dataArr.count<30) {
            _tableview.mj_footer.hidden =YES;
        }
        [_dataArray addObjectsFromArray:dataArr];

        //TYPE :优惠券类型 1满减券 2折扣券 3现金券 4运费抵用券 5运费现金券
        
        [self.tableview reloadData];
        
        
    } failure:^(NSError *error) {
        [self showEmptyViewWithTitle:@"暂无优惠券可领"];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}
-(void)headerRereshing
{
    [super headerRereshing];
    page =1;
    
    [self getVouchListInfo];
    
}
-(void)footerRereshing
{
    [super footerRereshing];
    page ++;
    [self getVouchListInfo];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (IS_IPHONE5) {
//        return 110;
//    }
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"VouchersCell";
    VouchersCell * cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    [cell setCellInfoWithDict:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)didClickGetVouchersWithCell:(VouchersCell*)cell
{
    NSMutableDictionary * dict = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:[dict safeObjectForKey:@"id"] forKey:@"couponId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/coupon/receiveCoupon.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        cell.getBtn.selected = YES;
        cell.getBtn.backgroundColor = HEXCOLOR(0xeeeeee);
        [dict safeSetObject:@"1" forKey:@"isReceive"];
        int receiveNum = [[dict safeObjectForKey:@"receiveNum"]intValue];
        [dict safeSetObject:@(receiveNum+1) forKey:@"receiveNum"];
        
        [cell refreshProgressWithDict:dict];
        [[UserModel shareInstance]showSuccessWithStatus:@"领取成功"];
    } failure:^(NSError *error) {
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
