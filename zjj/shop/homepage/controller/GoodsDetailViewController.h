//
//  GoodsDetailViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface GoodsDetailViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSString *productNo;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *detailView;

- (IBAction)didshopCar:(id)sender;
- (IBAction)addShopCar:(id)sender;

- (IBAction)didBuy:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *shopCartCountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment2;
@property (weak, nonatomic) IBOutlet UIWebView *webView1;
@property (weak, nonatomic) IBOutlet UIWebView *webView2;
- (IBAction)changeWebView:(id)sender;


@end
