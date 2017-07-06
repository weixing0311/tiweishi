//
//  TZSDeliveryViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface TZSDeliveryViewController : JFABaseTableViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)didNext:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
