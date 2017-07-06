//
//  shopCarCellItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "shopCarCellItem.h"

@implementation shopCarCellItem
-(void)setupInfoWithDict:(NSDictionary *)dict

{
    self.productNo         = [dict safeObjectForKey:@"productNo"];
    self.productName       = [dict safeObjectForKey:@"productName"];
    self.status            = [dict safeObjectForKey:@"status"];
    self.oldPrice          = [dict safeObjectForKey:@"oldPrice"];
    self.productPrice      = [dict safeObjectForKey:@"productPrice"];
    self.productWeight     = [dict safeObjectForKey:@"productWeight"];
    self.image             = [dict safeObjectForKey:@"image"];
    self.promotList        = [dict safeObjectForKey:@"promotList"];
    self.isDistribution    = [dict safeObjectForKey:@"isDistribution"];
    self.freightTemplateId = [dict safeObjectForKey:@"freightTemplateId"];
    self.stock             = [dict safeObjectForKey:@"stock"];
    self.isDelivery        = [dict safeObjectForKey:@"isDelivery"];
    self.affiliation       = [dict safeObjectForKey:@"affiliation"];
    self.restrictionNum    = [dict safeObjectForKey:@"restrictionNum"];
    self.quantity          = [dict safeObjectForKey:@"quantity"];
}

@end
