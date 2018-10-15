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
//#import "ShopTabbbarController.h"
//#import "GoodsDetailViewController.h"
#import "TZSDeliveryViewController.h"
#import "MyVouchers2Cell.h"
#import "BaseWebViewController.h"
#import "MyVouchersCell2Model.h"
#import "KfVcodeViewController.h"
@interface MyVoucthersViewController ()<UITableViewDelegate,UITableViewDataSource,myVoucthersDelegate,myVouchers2Delegate>
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

    if (_myType ==IS_FROM_MINE||_myType ==IS_FROM_SHOP||_myType ==IS_FROM_TZS) {
        [self createSegment];
    }else{
        [self getMyUseVoucthers];
    }
    // Do any additional setup after loading the view.
}
-(void)createSegment
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 65, JFA_SCREEN_WIDTH, 46)];
    view.backgroundColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:view];
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
    if (_myType ==IS_FROM_MINE||_myType ==IS_FROM_SHOP||_myType ==IS_FROM_TZS)
    {
        height = 110;
    }
    else
    {
        height = 70;
    }
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, height, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-height) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = HEXCOLOR(0xeeeeee);
    _tableview.separatorColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:_tableview];
    [self setExtraCellLineHiddenWithTb:_tableview];
    if (_myType ==IS_FROM_MINE||_myType ==IS_FROM_SHOP||_myType ==IS_FROM_TZS)
    {
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
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/coupon/queryMyCoupon.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
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
        
        
        for (int i =0; i<dataArr.count; i++) {
            NSDictionary * dict = [dataArr objectAtIndex:i];
            MyVouchersCell2Model *model = [MyVouchersCell2Model new];
            [model setInfoWithDict:dict];
            [_dataArray addObject:model];
            
        }
        [_tableview reloadData];

    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        if ([error code]==402&&page==1) {
            [_dataArray removeAllObjects];
            [_tableview reloadData];
            [self showEmptyViewWithTitle:@"暂无优惠券！"];
            [self.view bringSubviewToFront:_segment];
        }
    }];
    
}

-(void)getMyUseVoucthers
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.productArr forKey:@"productArr"];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/coupon/queryMyCouponByProduct.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
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

            }
            else if (self.myType ==IS_FROM_CONFIRM)
            {
                if (type !=4&&type!=5) {
                    *stop =YES;
                    if (*stop ==YES) {
                        [dataArr removeObject:dict];
                    }
                }
            }
        }];
        
        
        
        
        for (int i =0; i<dataArr.count; i++) {
            NSDictionary * dict = [dataArr objectAtIndex:i];
            MyVouchersCell2Model *model = [MyVouchersCell2Model new];
            [model setInfoWithDict:dict];
            [_dataArray addObject:model];
            
        }
        if (_dataArray.count==0) {
            [self showEmptyViewWithTitle:@"无可用优惠券"];
        }else{
            [self hiddenEmptyView];
        }
        [_tableview reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showEmptyViewWithTitle:@"暂无优惠券"];
        [_tableview reloadData];
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
    MyVouchersCell2Model * model = [_dataArray objectAtIndex:indexPath.row];
    
    int type = [model.type intValue];
    if (type ==6) {
        if ([model.showContent isEqualToString:@"open"]) {
            
            return [_tableview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MyVouchers2Cell class] contentViewWidth:JFA_SCREEN_WIDTH];
        }else{
            return 130;
    }
    }
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MyVouchersCell2Model * model = [_dataArray objectAtIndex:indexPath.row];

    int type = [model.type intValue];

    if (type ==6) {
        static NSString * identifier = @"MyVouchers2Cell";
        MyVouchers2Cell * cell = [_tableview dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.model = model;
        if (_segment.selectedSegmentIndex ==0) {
            [cell.useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            [cell.useBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
            cell.useBtn.backgroundColor = [UIColor redColor];
            cell.useBtn.hidden = NO;
        }else{
            cell.useBtn.hidden = YES;
        }
        //        else{
        //            NSString * depositStatus = [dic safeObjectForKey:@"depositStatus"];
        //            if ([depositStatus isEqualToString:@"2"]) {
        //                [cell.useBtn setTitle:@"退保证金" forState:UIControlStateNormal];
        //                [cell.useBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        //                cell.useBtn.backgroundColor = [UIColor orangeColor];
        //
        //            }
        //            else if ([depositStatus isEqualToString:@"3"]||[depositStatus isEqualToString:@"4"])
        //            {
        //                [cell.useBtn setTitle:@"退款审核中" forState:UIControlStateNormal];
        //                [cell.useBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        //                cell.useBtn.backgroundColor = HEXCOLOR(0xeeeeee);
        //
        //            }
        //            else if ([depositStatus isEqualToString:@"10"])
        //            {
        //                [cell.useBtn setTitle:@"已退款" forState:UIControlStateNormal];
        //                [cell.useBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        //                cell.useBtn.backgroundColor = HEXCOLOR(0xeeeeee);
        //
        //            }
        //
        //        }
        //

        return cell;
    }else{
        static NSString * identifier = @"MyVouchersCell";
        MyVouchersCell * cell = [_tableview dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        cell.titlelb.text = model.grantName;
        NSString * startTime = [model.validStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符
        NSString * endTime  = [model.validEndTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符
        
        cell.timelb.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
        
        
        int type = [model.type intValue];
        if (type ==2) {
            
            
            cell.faceValuelb.text = [NSString stringWithFormat:@"%@折",[cell formatFloat:[model.discountAmount floatValue]*10]];
        }
        else if(type==4)
        {
            cell.faceValuelb.text = @"免运费";
        }
        else
        {
            NSString * faceValue = [NSString stringWithFormat:@"￥%@",model.discountAmount];
            NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:faceValue];
            
            //总共
            [tisString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
            cell.faceValuelb.attributedText = tisString;
        }
        
        
        //控制‘立即使用’button的显示和隐藏 --
        if (self.myType ==IS_FROM_MINE) {
            [cell setDidUserHidden:YES];
            if (_segment) {
                if (_segment.selectedSegmentIndex==1) {
                    cell.statusImage.hidden= NO;
                    cell.statusImage.image = getImage(@"vouchersHasBeenUserd_");
                }else if (_segment.selectedSegmentIndex ==2)
                {
                    cell.statusImage.hidden= NO;
                    cell.statusImage.image = getImage(@"vouchersexpried_");
                    
                }else{
                    cell.statusImage.hidden= YES;
                }
            }else{
                cell.statusImage.hidden= YES;
                [cell setDidUserHidden:YES];
                
            }
        }else{
            
            if (_segment) {
                if (_segment.selectedSegmentIndex==1) {
                    cell.statusImage.hidden= NO;
                    cell.statusImage.image = getImage(@"vouchersHasBeenUserd_");
                    [cell setDidUserHidden:YES];
                }else if (_segment.selectedSegmentIndex ==2)
                {
                    cell.statusImage.hidden= NO;
                    cell.statusImage.image = getImage(@"vouchersexpried_");
                    [cell setDidUserHidden:YES];
                    
                }else{
                    cell.statusImage.hidden= YES;
                    [cell setDidUserHidden:NO];
                    
                }
            }else{
                cell.statusImage.hidden= YES;
                [cell setDidUserHidden:YES];
            }
        }
        
        cell.limitGoodslb.text = [cell getlimitWithArr:model.products];
        cell.limit2Goodslb.text = [cell getlimitWithArr:model.products];
        
        int startAmount = [model.startAmount intValue];
        if (!startAmount||startAmount ==0) {
            cell.limitPricelb.text = @"(无限制)";
        }else{
            cell.limitPricelb.text = [NSString stringWithFormat:@"满%d元可用",startAmount];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        if (self.chooseDict) {
            NSString * couponNo= [self.chooseDict safeObjectForKey:@"couponNo"];
            NSString * indexCouponNo = model.couponNo;
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
    MyVouchersCell2Model * model = [_dataArray objectAtIndex:cell.tag];
    int type = [model.type intValue];
        if (type ==4||type==5) {
            TZSDeliveryViewController * com = [[TZSDeliveryViewController alloc]init];
            [self.navigationController pushViewController:com animated:YES];
        }else{
            TZSDingGouViewController * tzsDG = [[TZSDingGouViewController alloc]init];
            [self.navigationController pushViewController:tzsDG animated:YES];
        }
//    }

    
}
-(void)showContentInfoWithCell:(MyVouchers2Cell *)cell
{
    MyVouchersCell2Model * model = [_dataArray objectAtIndex:cell.tag];
    
        if ([model.showContent isEqualToString:@"open"]) {
            model.showContent = @"close";
        }else{
            model.showContent = @"open";
        }
    [_tableview reloadData];
}
-(void)userTheVoucherWithCell:(MyVouchers2Cell *)cell
{
    
    
    if (_segment.selectedSegmentIndex ==0) {
        MyVouchersCell2Model * model = [_dataArray objectAtIndex:cell.tag];
        
        NSMutableDictionary *param =[NSMutableDictionary dictionary];
        [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:model.startAmount forKey:@"totalPrice"];
        [param safeSetObject:model.startAmount forKey:@"payableAmount"];
        
        [param safeSetObject:model.couponNo forKey:@"couponNo"];
        
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/ordertrail/saveOrderTrial.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
            DLog(@"success--%@",dic);
            NSDictionary * dataDict = [dic safeObjectForKey:@"data"];

            if ([[dataDict safeObjectForKey:@"payableAmount"] doubleValue]<1) {
                [[UserModel shareInstance]showSuccessWithStatus:@"使用成功！"];
                [self getMyVoucthersInfo];
                
                KfVcodeViewController *kf = [[KfVcodeViewController alloc]init];
                [self.navigationController pushViewController:kf animated:YES];
                
                
                
                return ;
            }
            
            
            BaseWebViewController *web = [[BaseWebViewController alloc]init];
            web.urlStr = @"app/checkstand.html";
            web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
            //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
            web.payType =7;
            web.opt =5;
            web.integral = @"3";
            web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
            web.title  =@"收银台";
            [self.navigationController pushViewController:web animated:YES];
            
            
        } failure:^(NSError *error) {
            DLog(@"faile:%@",error);
        }];

    }else{
        MyVouchersCell2Model * model = [_dataArray objectAtIndex:cell.tag];

        NSString * depositStatus = model.depositStatus;
        if ([depositStatus isEqualToString:@"2"]) {

        UIAlertController * al = [UIAlertController alertControllerWithTitle:@"确定要退保证金？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableDictionary *param =[NSMutableDictionary dictionary];
            [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
            [param safeSetObject:model.couponNo forKey:@"couponNo"];
            
            
            self.currentTasks = [[BaseSservice sharedManager]post1:@"app/ordertrail/refundDepositApply.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
                DLog(@"success--%@",dic);
                

                [_tableview.mj_header beginRefreshing];
            } failure:^(NSError *error) {
                DLog(@"faile:%@",error);
            }];

        }]];
        [al addAction:[UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:al animated:YES completion:nil];
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
