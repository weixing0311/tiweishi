//
//  TZSOrderDetailViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface TZSOrderDetailViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,copy)NSString * orderNo;


@end
