//
//  HealthItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthItem.h"

@implementation HealthItem
-(void)setobjectWithDic:(NSDictionary *)dict
{
    self.waterWeight                = [[dict safeObjectForKey:@"waterWeight"]floatValue];
    self.weight                     = [[dict safeObjectForKey:@"weight"]floatValue];
    self.muscleWeight               = [[dict safeObjectForKey:@"muscleWeight"]floatValue];
    self.bmi                        = [[dict safeObjectForKey:@"bmi"]floatValue];
    self.normal                     = [[dict safeObjectForKey:@"normal"]intValue];
    self.DataId                     = [[dict safeObjectForKey:@"DataId"]intValue];
    self.bmiLevel                   = [[dict safeObjectForKey:@"bmiLevel"]intValue];
    self.visceralFatPercentageLevel = [[dict safeObjectForKey:@"visceralFatPercentageLevel"]intValue];
    self.visceralFatPercentage      = [[dict safeObjectForKey:@"visceralFatPercentage"]floatValue];
    self.fatWeightLevel             = [[dict safeObjectForKey:@"fatWeightLevel"]intValue];
    self.lastWeight                 = [[dict safeObjectForKey:@"lastWeight"]floatValue];
    self.fatWeight                  = [[dict safeObjectForKey:@"fatWeight"]floatValue];
    self.bmr                        = [[dict safeObjectForKey:@"bmr"]floatValue];
    self.proteinLevel               = [[dict safeObjectForKey:@"proteinLevel"]intValue];
    self.bodyAge                    = [[dict safeObjectForKey:@"bodyAge"]intValue];
    self.waterLevel                 = [[dict safeObjectForKey:@"waterLevel"]intValue];
    self.muscleLevel                = [[dict safeObjectForKey:@"muscleLevel"]intValue];
    self.userId                     = [[dict safeObjectForKey:@"userId"]intValue];
    self.subUserId                  = [[dict safeObjectForKey:@"subUserId"]intValue];
    self.serious                    = [[dict safeObjectForKey:@"serious"]intValue];
    self.weightLevel                = [[dict safeObjectForKey:@"weightLevel"]intValue];
    self.proteinWeight              = [[dict safeObjectForKey:@"proteinWeight"]floatValue];
    self.warn                       = [[dict safeObjectForKey:@"warn"]intValue];
    self.createTime                 = [ dict safeObjectForKey:@"createTime"];
    self.fatPercentage              = [[dict safeObjectForKey:@"fatPercentage"]floatValue];
}
@end
