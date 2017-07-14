//
//  TZdetaolViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface TZdetaolViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSString *dataId;
@property(retain, nonatomic) NSIndexPath *selectIndex;

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end
