//
//  PhoneChargesViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import "IntegralShopDetailModel.h"
@interface PhoneChargesViewController : JFABaseTableViewController
@property (nonatomic,strong)IntegralShopDetailModel * model;
@property (nonatomic,assign)int goodsCount;
@property (nonatomic,strong) NSMutableDictionary * param;
@end
