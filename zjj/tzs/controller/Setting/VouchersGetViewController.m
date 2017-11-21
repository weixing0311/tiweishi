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
    myv.isFromOrder =NO;
    [self.navigationController pushViewController:myv animated:YES];
}
-(void)getVouchListInfo
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/coupon/queryCouponList.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
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
    return 130;
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
    cell.titlelb.text = [dic safeObjectForKey:@"grantName"];
    cell.timelb.text = [NSString stringWithFormat:@"有效期至:%@",[dic safeObjectForKey:@"receiveEndTime"]];
    cell.countlb.text = [NSString stringWithFormat:@"%d",[[dic safeObjectForKey:@"grantNum"]intValue]-[[dic safeObjectForKey:@"receiveNum"]intValue]];
    
    
    
    NSString * isReceive = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"isReceive"]];
    if ([isReceive isEqualToString:@"0"]) {
        cell.getBtn.selected = NO;
        cell.getBtn.backgroundColor = [UIColor redColor];
    }else{
        cell.getBtn.selected = YES;
        cell.getBtn.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    
    
    int type = [[dic safeObjectForKey:@"type"]intValue];
    if (type ==2) {
        cell.faceValuelb.text = [NSString stringWithFormat:@"%.0f折",[[dic safeObjectForKey:@"discountAmount"]floatValue]*10];
    }else{
        cell.faceValuelb.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"discountAmount"]];
    }
    
    cell.headImageView.image = getImage(@"default");
    
    //useRange//使用范围 0全部商品 1脂将军饼干 2 体脂称
    int userRange = [[dic safeObjectForKey:@"useRange"]intValue];
    if (userRange ==1) {
        cell.limit2lb.text =@"仅限脂将军饼干使用";
    }
    else if(userRange ==2)
    {
        cell.limit2lb.text = @"仅限脂将军饼干使用";
    }else
    {
        cell.limit2lb.text = @"(无限制)";
    }
    
    int startAmount = [[dic safeObjectForKey:@"startAmount"]intValue];
    if (!startAmount||startAmount ==0) {
        cell.limitlb.text = @"(无限制)";
    }else{
        cell.limitlb.text = [NSString stringWithFormat:@"满%d可用",startAmount];
    }
    
    
    
    
    
    
    
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
