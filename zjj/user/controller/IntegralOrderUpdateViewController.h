//
//  IntegralOrderUpdateViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/22.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface IntegralOrderUpdateViewController : JFABaseTableViewController
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (nonatomic,strong) NSMutableDictionary * param;
@property (nonatomic,assign) int goodsCount;
@property (nonatomic,copy) NSString * orderItem;

@end
