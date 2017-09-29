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
    IS_ALL=0,//全部
    IS_WATE_PAY=1,//待付款
    
    IS_WAIT_GETGOOD=2,//待收货
    IS_HAVE_SUCCESS=3,//已完成
    
    IS_CANCEL=4,//已取消
}OrderType;

@interface IntegralOrderViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic,assign)OrderType getOrderType;
- (IBAction)didChangeStatussegment:(id)sender;

@end
