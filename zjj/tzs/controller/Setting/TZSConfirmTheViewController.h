//
//  TZSConfirmTheViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface TZSConfirmTheViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)NSString * productStr;
- (IBAction)placeTheOrder:(id)sender;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * param;
@property (nonatomic,copy) NSString * defaultVouchersNo;

@end
