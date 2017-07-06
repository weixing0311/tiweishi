//
//  UpdataOrderViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface UpdataOrderViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic ,assign)BOOL isComeFromShopCart;
- (IBAction)didBuy:(id)sender;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,copy) NSString * orderItem;
@property (nonatomic,strong)NSMutableDictionary * param;
@property (nonatomic,assign)int goodsCount;
@end
