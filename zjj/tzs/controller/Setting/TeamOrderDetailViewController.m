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
@property (nonatomic,copy)NSTimer * timer;
@end

@implementation TeamOrderDetailViewController
{
    NSMutableArray * _dataArray;
    NSMutableDictionary * _infoDict;
    TZSOrderHeader *tabHeadView;
    UILabel * _lastLabel;
    int timeOut;
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
    
//    [self countDownWithtimeInterval:];
    
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
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"/app/order/info/queryOrderInfo.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic objectForKey:@"data"]objectForKey:@"array"][0];
        [_dataArray addObjectsFromArray:[[[dic objectForKey:@"data"]objectForKey:@"array"][0]objectForKey:@"itemJson"]];
        tabHeadView.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",[_infoDict objectForKey:@"orderNo"]];
        
        int status = [[_infoDict objectForKey:@"stockType"]intValue];
        if (status ==2) {
            [self buildFootView];
        }
        tabHeadView.statusLabel .text = [self getStatusWithStatus:status];

        timeOut = [[_infoDict safeObjectForKey:@"remainingTime"]intValue]/1000;
        [self countDown];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
    }];
    
}

-(void)toBuy
{
    
    if (self.delegate&& [self.delegate respondsToSelector:@selector(teamOrderChange)]) {
        [self.delegate teamOrderChange];
    }
    
    TZSDingGouViewController * dg = [[TZSDingGouViewController alloc]init];
    
    [self.navigationController pushViewController:dg animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int stockType = [[_infoDict safeObjectForKey:@"stockType"]intValue];
    if (section ==0)
    {
        return _dataArray.count;
        
    }
    else
    {
        if (stockType==3) {
            return 4;
        }
        else
        {
            return 3;
        }
        
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
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"销售单价:￥%.2f",[[dic safeObjectForKey:@"unitPrice"] floatValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
//        int stockType = [[_infoDict safeObjectForKey:@"stockType"]intValue];
//        if (stockType ==3) {
//            cell.price2label.text = [NSString stringWithFormat:@"成本单价:￥%.2f",[[dic safeObjectForKey:@"costPrice"] floatValue]];
//            
//        }else{
//            cell.price2label.text = @"";
//        }
        NSString * isgift = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"isGift"]];
        
        if ([isgift isEqualToString:@"1"]) {
            cell.zengimageView.hidden =NO;
        }else{
            cell.zengimageView.hidden =YES;
        }

        return cell;
    }
    else
    {
        
        if (indexPath.row ==0) {
            
            static NSString * identifier = @"PayPriceCell";
            PayPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.countLabel.text =[NSString stringWithFormat:@"共%@项 合计:",[_infoDict safeObjectForKey:@"quantitySum"]];
            cell.priceLabel.text  =[NSString stringWithFormat:@"￥%.2f元",[[_infoDict safeObjectForKey:@"payableAmount"]floatValue]-[[_infoDict safeObjectForKey:@"freight"]floatValue]];
            return cell;
        }
        
        else if (indexPath.row ==1) {
            static NSString * identifier = @"cell1";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }

            cell.textLabel.text =[NSString stringWithFormat:@"订购人：%@(TEL:%@)",[_infoDict objectForKey:@"nickName"],[[UserModel shareInstance]changeTelephone:[_infoDict objectForKey:@"phone"]]];
            return cell;

        }else if(indexPath.row ==2){
            static NSString * identifier = @"cell1";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }

            cell.textLabel.text =[NSString stringWithFormat:@"下单时间：%@",[_infoDict objectForKey:@"createTime"]];
            return cell;

        }else{
            static NSString * identifier = @"cell1";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            
            cell.textLabel.text =[NSString stringWithFormat:@"完成时间：%@",[_infoDict objectForKey:@"payfinishTime"]];
            return cell;
   
        }
        
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
-(NSString *)getNowTimeWithString:(int)aTimeString{
    
    int timeInterval =timeOut;
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"活动已经结束！";
    }
    if (days) {
        return [NSString stringWithFormat:@"%@天 %@小时 %@分", dayStr,hoursStr, minutesStr];
    }
    if (minutes==0&&seconds!=0) {
        return [NSString stringWithFormat:@"%@小时 %d分",hoursStr , [minutesStr intValue]+1];
 
    }else{
    return [NSString stringWithFormat:@"%@小时 %@分",hoursStr , minutesStr];
    }
}

-(void)countDown {
    
    if (timeOut!=0) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshTimeLabel:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}
-(void)refreshTimeLabel:(NSTimer *)timer
{
    DLog(@"%d",timeOut);

    if (!timeOut||timeOut<=0) {
        [_timer invalidate];
        _lastLabel.text = @"补货结束";
        [self getlistInfo_is_team];
        return;
    }
    [self updateTimeInVisibleCellsWithString:timeOut];
    timeOut--;
    
}
-(void)updateTimeInVisibleCellsWithString:(int)str{
    if (str <=0) {
        _lastLabel.text = @"补货结束";
    }
    else
    {
        _lastLabel.text = [NSString stringWithFormat:@"订单补充剩余时间%@",[self getNowTimeWithString:str]];
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
