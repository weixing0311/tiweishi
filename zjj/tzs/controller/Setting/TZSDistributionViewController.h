//
//  TZSDistributionViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface TZSDistributionViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)changeinfo:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
