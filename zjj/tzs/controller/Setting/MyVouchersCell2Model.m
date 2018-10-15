//
//  MyVouchersCell2Model.m
//  zjj
//
//  Created by iOSdeveloper on 2018/8/1.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MyVouchersCell2Model.h"

@implementation MyVouchersCell2Model
-(void)setInfoWithDict:(NSDictionary *)dict
{
    self.idStr = [dict safeObjectForKey:@"id"];
    self.grantType = [dict safeObjectForKey:@"grantType"];
    self.discountAmount = [dict safeObjectForKey:@"discountAmount"];
    self.validEndTime = [dict safeObjectForKey:@"validEndTime"];
    self.depositStatus = [dict safeObjectForKey:@"depositStatus"];
    self.templateId = [dict safeObjectForKey:@"templateId"];
    self.templateName = [dict safeObjectForKey:@"templateName"];
    self.startAmount = [dict safeObjectForKey:@"startAmount"];
    self.grantNum = [dict safeObjectForKey:@"grantNum"];
    self.context = [dict safeObjectForKey:@"context"];
    self.couponNo = [dict safeObjectForKey:@"couponNo"];
    self.type = [dict safeObjectForKey:@"type"];
    self.receiveEndTime = [dict safeObjectForKey:@"receiveEndTime"];
    self.validStartTime = [dict safeObjectForKey:@"validStartTime"];
    self.grantName = [dict safeObjectForKey:@"grantName"];
    self.grantObject = [dict safeObjectForKey:@"grantObject"];
    self.isValid = [dict safeObjectForKey:@"isValid"];
    self.receiveStartTime = [dict safeObjectForKey:@"receiveStartTime"];
    self.status = [dict safeObjectForKey:@"status"];
    self.showContent = @"close";
    self.products = [dict safeObjectForKey:@"products"];
}
@end
