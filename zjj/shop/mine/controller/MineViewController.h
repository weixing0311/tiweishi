//
//  MineViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface MineViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *tizhishiBtn;
- (IBAction)didSetUp:(id)sender;
- (IBAction)waitForPayment:(id)sender;
- (IBAction)waitForGetGoods:(id)sender;
- (IBAction)allTheOrder:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)didTzs:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *waitpayCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitSendLabel;

@end
