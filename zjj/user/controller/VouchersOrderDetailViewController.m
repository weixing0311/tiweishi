//
//  VouchersOrderDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersOrderDetailViewController.h"
#import "UpDateOrderCell.h"
#import "TZSOrderHeader.h"
#import "BaseWebViewController.h"
#import "OrderPayFootCell.h"

@interface VouchersOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation VouchersOrderDetailViewController
{
    NSMutableArray * _dataArray;
    NSMutableDictionary * _infoDict;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.tableview .delegate =self;
    self.tableview.dataSource = self;
    self.view.backgroundColor =HEXCOLOR(0xeeeeee);
    self.tableview.backgroundColor =[UIColor clearColor];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    _infoDict = [NSMutableDictionary dictionary ];;
    
    [self getlistInfo_IS_CONSUMERS];

    // Do any additional setup after loading the view from its nib.
}
-(void)getlistInfo_IS_CONSUMERS
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param setObject:self.orderNo forKey:@"orderNo"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/orderInfo/queryIntegrationOrderItem.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic");
        _infoDict = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"][0];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:[_infoDict safeObjectForKey:@"itemJson"]];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section ==0)
    {
        return _dataArray.count;
        
    }
    else if(section ==1)
    {
        int status = [[_infoDict objectForKey:@"status"]intValue];
        if (status ==3) {
            return 2;
        }else{
            return 1;
        }
        
    }
    else
    {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 44;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    else if (section==1)
    {
        return 10;
    }
    else{
        int status = [[_infoDict safeObjectForKey:@"status"]intValue];
        if (status==3||status==1) {
            return 40;
        }else{
            return 5;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section ==0)
    {
        return 100;
    }
    else if(indexPath.section ==1)
    {
        return 44;
    }else{
        return 125;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50)];
    
    if (section ==0) {
        view.backgroundColor =[UIColor colorWithWhite:1 alpha:1];
        
        TZSOrderHeader *header = [self getXibCellWithTitle:@"TZSOrderHeader"];
        header.frame = CGRectMake(0, 10, JFA_SCREEN_WIDTH, 30);
        header.backgroundColor =[UIColor whiteColor];
        header.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",[_infoDict objectForKey:@"orderNo"]];
        
        int status = [[_infoDict objectForKey:@"status"]intValue];
        
        header.statusLabel .text = [self getStatusWithStatus:status];
        [view addSubview:header];
        
    }
    return view;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int status = [[_infoDict objectForKey:@"status"]intValue];
    
    if (indexPath.section ==0) {
        static NSString * identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = [dic safeObjectForKey:@"productName"];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
        
        
        
        NSString * priceStr = [dic safeObjectForKey:@"unitPrice"];
        NSString * integral = [dic safeObjectForKey:@"integral"];
        if (integral.intValue>0&&priceStr.floatValue>0) {
            cell.priceLabel.text =[NSString stringWithFormat:@"%@积分+%.2f元",integral,[priceStr floatValue]];
            
        }else{
            if (integral.intValue>0) {
                cell.priceLabel.text =[NSString stringWithFormat:@"%@积分",integral];
                
            }else{
                cell.priceLabel.text =[NSString stringWithFormat:@"%.2f元",[priceStr floatValue]];
            }
        }
        
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic safeObjectForKey:@"quantity"]];
        
        NSString * isgift = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"isGift"]];
        
        if ([isgift isEqualToString:@"1"]) {
            cell.zengimageView.hidden =NO;
        }else{
            cell.zengimageView.hidden =YES;
        }
        
        return cell;
    }
    else if (indexPath.section ==1)
    {
        static NSString * identifier = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if (indexPath.row ==0) {
            cell.textLabel.text =[NSString stringWithFormat:@"下单时间：%@",[_infoDict objectForKey:@"createTime"]];
        }else{
            if (status==3) {
                if ([[_infoDict objectForKey:@"paymentTypeId"] isEqualToString:@"0"]) {
                    cell.textLabel.text = @"";
                }else{
                    cell.textLabel.text =[NSString stringWithFormat:@"支付方式：%@",[_infoDict objectForKey:@"paymentTypeId"]];
                }
            }else{
                cell.textLabel.text = @"";
            }
            
        }
        return cell;
        
    }
    else
    {
        
        static NSString * identifier = @"OrderPayFootCell";
        OrderPayFootCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        NSString * priceStr = [_infoDict safeObjectForKey:@"payableAmount"];
        NSString * integral = [_infoDict safeObjectForKey:@"integral"];
        if (integral.intValue>0&&priceStr.floatValue>0) {
            cell.value1label.text =[NSString stringWithFormat:@"%@积分+%.2f元",integral,[priceStr floatValue]];
            cell.value3label.text =[NSString stringWithFormat:@"%@积分+%.2f元",integral,[priceStr floatValue]];
            
            
        }else{
            if (integral.intValue>0) {
                cell.value1label.text =[NSString stringWithFormat:@"%@积分",integral];
                cell.value3label.text =[NSString stringWithFormat:@"%@积分",integral];
                
            }else{
                cell.value1label.text =[NSString stringWithFormat:@"%.2f元",[priceStr floatValue]];
                cell.value3label.text =[NSString stringWithFormat:@"%.2f元",[priceStr floatValue]];
                
            }
            
        }
        
        
        cell.value2label.text =@"免运费";
        
        cell.value4label.text =@"0.00元";
        
        
        cell.title4label.text = @"商品优惠";
        if (status ==3||status==10) {
            cell.title3label.text = @"已付款";
        }else{
            cell.title3label.text = @"需付款";
        }
        
        return cell;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        BaseWebViewController * web =[[BaseWebViewController alloc]init];
        web.title = @"我的配送";
        NSString * orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        web.urlStr = [NSString stringWithFormat:@"app/fatTeacher/integralLogisticsInformation.html?orderNo=%@",orderNo];
        web.payType =5;
        [self.navigationController pushViewController:web animated:YES];
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
            return @"";
            break;
        case 3:
            return @"待收货";
            break;
        case 10:
            return @"已完成";
            break;
        case 0:
            return @"已取消";
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
