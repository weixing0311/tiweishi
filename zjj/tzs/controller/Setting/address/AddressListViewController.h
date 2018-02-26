//
//  AddressListViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface AddressListViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)didAdd:(id)sender;
@property(nonatomic,assign)BOOL isComeFromOrder;
@end
