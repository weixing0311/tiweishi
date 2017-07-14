//
//  UserViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface UserViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
- (IBAction)loignout:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
- (IBAction)EnterCharVC:(UIButton *)sender;

@end
