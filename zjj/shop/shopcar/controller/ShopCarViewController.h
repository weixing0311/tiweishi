//
//  ShopCarViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import "ShopCarbottomView.h"
#import "ShopCarCell.h"

@interface ShopCarViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource ,shopCarCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ShopCarbottomView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *didChoose;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;

- (IBAction)didSettlement:(id)sender;
- (IBAction)didChoose:(id)sender;

@end
