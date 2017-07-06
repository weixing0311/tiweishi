//
//  setUpViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface setUpViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
