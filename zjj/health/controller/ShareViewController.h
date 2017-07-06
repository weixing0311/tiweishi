//
//  ShareViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface ShareViewController : JFABaseTableViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *shareVX;
@property (weak, nonatomic) IBOutlet UIImageView *shareFriends;
@property (weak, nonatomic) IBOutlet UIImageView *shareQQ;
@property (nonatomic,strong)NSMutableArray * dataArray;
- (IBAction)didShareVX:(id)sender;
- (IBAction)didShareFriedns:(id)sender;
- (IBAction)didShareQQ:(id)sender;
@end
