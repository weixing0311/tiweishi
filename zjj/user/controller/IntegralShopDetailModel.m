//
//  IntegralShopDetailModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralShopDetailModel.h"

@implementation IntegralShopDetailModel
-(void)setInfoWithDict:(NSDictionary *)dict
{
    self.picture = [dict safeObjectForKey:@"picture"];
    self.productWeight = [dict safeObjectForKey:@"productWeight"];
    self.note = [dict safeObjectForKey:@"note"];
    self.viceTitle = [dict safeObjectForKey:@"viceTitle"];
    self.oldPrice = [dict safeObjectForKey:@"oldPrice"];
    self.oldIntegral = [dict safeObjectForKey:@"oldIntegral"];
    self.productNo = [dict safeObjectForKey:@"productNo"];
    self.productInformation = [dict safeObjectForKey:@"productInformation"];
    self.isWarehouseSend = [dict safeObjectForKey:@"isWarehouseSend"];
    self.colour = [dict safeObjectForKey:@"colour"];
    self.restrictionNum = [dict safeObjectForKey:@"restrictionNum"];
    self.productName = [dict safeObjectForKey:@"productName"];
    self.productPrice = [dict safeObjectForKey:@"productPrice"];
    self.grade = [dict safeObjectForKey:@"grade"];
    self.productIntegral = [dict safeObjectForKey:@"productIntegral"];
}
@end
