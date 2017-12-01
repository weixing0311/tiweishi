//
//  VouchersUpOrderViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import "IntegralShopDetailModel.h"

@interface VouchersUpOrderViewController : JFABaseTableViewController
@property (nonatomic,strong)IntegralShopDetailModel * model;
@property (nonatomic,assign)int goodsCount;
@property (nonatomic,strong) NSMutableDictionary * param;

@end
