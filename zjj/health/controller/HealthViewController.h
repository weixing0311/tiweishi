//
//  HealthViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface HealthViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *tableView;

@end
