//
//  IntegralOrderViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
typedef enum
{
    IS_INTEGRAL_ALL=0,//全部
    IS_INTEGRAL_WATE_PAY=1,//待付款
    
    IS_INTEGRAL_WAIT_GETGOOD=2,//待收货
    IS_INTEGRAL_HAVE_SUCCESS=3,//已完成
    
    IS_INTEGRAL_CANCEL=4,//已取消
}IntegralOrderType;

@interface IntegralOrderViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic,assign)IntegralOrderType getOrderType;
- (IBAction)didChangeStatussegment:(id)sender;

@end
