//
//  TeamOrderDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TeamOrderDetailViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "UpdataAddressCell.h"
#import "DistributionBottomCell.h"
#import "BaseWebViewController.h"
#import "PayPriceCell.h"
#import "TZSDingGouViewController.h"
@interface TeamOrderDetailViewController ()

@end

@implementation TeamOrderDetailViewController
{
    NSMutableArray * _dataArray;
    NSMutableDictionary * _infoDict;
    TZSOrderHeader *tabHeadView;
    UILabel * _lastLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self setNbColor];
    self.tableview .delegate =self;
    self.tableview.dataSource = self;
    self.tableview.sectionHeaderHeight = 10;
    self.tableview.sectionFooterHeight = 10;

    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self buildHeadView];
    _dataArray = [NSMutableArray array];
    _infoDict = [NSMutableDictionary dictionary ];;
    [self getlistInfo_is_team];
    // Do any additional setup after loading the view from its nib.
}

-(void)buildHeadView
{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];
    view.backgroundColor =HEXCOLOR(0xeeeeee);
    
    tabHeadView = [self getXibCellWithTitle:@"TZSOrderHeader"];
    tabHeadView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50);
    tabHeadView.backgroundColor =[UIColor whiteColor];
    tabHeadView.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",[_infoDict objectForKey:@"orderNo"]];
    
    int status = [[_infoDict objectForKey:@"status"]intValue];
    
    tabHeadView.statusLabel .text = [self getStatusWithStatus:status];
    [view addSubview:tabHeadView];
    self.tableview.tableHeaderView = view;
}

-(void)buildFootView
{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 100)];
    view.backgroundColor =HEXCOLOR(0xeeeeee);
    
    
    _lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, JFA_SCREEN_WIDTH, 30)];
    _lastLabel.textColor = HEXCOLOR(0x666666);
    _lastLabel.font = [UIFont systemFontOfSize:15];
    _lastLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_lastLabel];
    
    
    UIButton * button  =[[UIButton alloc]initWithFrame:CGRectMake(20,50 , JFA_SCREEN_WIDTH-40, 45)];
    button.backgroundColor =HEXCOLOR(0xee0a3b);
    [button setTitle:@"去订购" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius  = 5;
    [button addTarget:self action:@selector(toBuy) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    self.tableview.tableFooterView= view;

}

-(void)getlistInfo_is_team
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:self.orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/order/info/queryOrderInfo.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic objectForKey:@"data"]objectForKey:@"array"][0];
        [_dataArray addObjectsFromArray:[[[dic objectForKey:@"data"]objectForKey:@"array"][0]objectForKey:@"itemJson"]];
        tabHeadView.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",[_infoDict objectForKey:@"orderNo"]];
        
        int status = [[_infoDict objectForKey:@"stockType"]intValue];
        if (status ==2) {
            [self buildFootView];
        }
        tabHeadView.statusLabel .text = [self getStatusWithStatus:status];

        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
    }];
    
}

-(void)toBuy
{
    TZSDingGouViewController * dg = [[TZSDingGouViewController alloc]init];
    
    [self.navigationController pushViewController:dg animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0)
    {
        return _dataArray.count;
        
    }
    else
    {
        return 3;
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return 100;
    }else if(indexPath.section ==1){
        return 44;
    }else{
        return 75;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
        
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"销售单价:￥%@",[dic safeObjectForKey:@"unitPrice"]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
        return cell;
    }
    else
    {
        static NSString * identifier = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        if (indexPath.row ==0) {
            
            static NSString * identifier = @"PayPriceCell";
            PayPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.countLabel.text =[NSString stringWithFormat:@"共%@项 合计:",[_infoDict safeObjectForKey:@"quantitySum"]];
            cell.priceLabel.text  =[NSString stringWithFormat:@"￥%.2f元",[[_infoDict safeObjectForKey:@"totalPrice"]floatValue]];
        }
        
        else if (indexPath.row ==1) {
            cell.textLabel.text =[NSString stringWithFormat:@"订购人：%@(TEL:%@)",[_infoDict objectForKey:@"nickName"],[_infoDict objectForKey:@"phone"]];

        }else{
            cell.textLabel.text =[NSString stringWithFormat:@"下单时间：%@",[_infoDict objectForKey:@"createTime"]];

        }
        return cell;
        
    }

}
-(NSString *)getStatusWithStatus:(int)myStatus
{
    switch (myStatus) {
            //                    订单状态1待付款   2付款确认中   3待收货   10.已完成  0已取消
        case 1:
            return @"待付款";
            break;
        case 2:
            return @"待补货";
            break;
        case 3:
            return @"已完成";
            break;
            
        default:
            break;
    }
    return nil;
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
