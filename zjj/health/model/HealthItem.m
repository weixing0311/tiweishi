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


-(UIColor*)getColorWithType:(enumsType)type
{
    switch (type) {
        case IS_ENUM_visceral:
            switch (self.visceralFatPercentageLevel) {
                case 1:
//                    return @"正常";
                    return [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
                    break;
                case 2:
//                    return @"警告";
                    return [UIColor orangeColor];
                    break;
                case 3:
//                    return @"严重";
                    return [UIColor redColor];
                    break;
                    
                default:
                    break;
            }
  
            break;
        case IS_ENUM_WEIGHT:
            switch (self.weightLevel) {
                case 1:
//                    return @"偏瘦";
                    return [UIColor orangeColor];

                    break;
                case 2:
//                    return @"正常";
                    return [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];

                    break;
                case 3:
//                    return @"轻度肥胖";
                    return [UIColor orangeColor];

                    break;
                case 4:
//                    return @"中度肥胖";
                    return [UIColor orangeColor];

                    break;
                case 5:
//                    return @"重度肥胖";
                    return [UIColor redColor];

                    break;
                case 6:
//                    return @"极度肥胖";
                    return [UIColor redColor];

                    break;
                    
                default:
                    break;
            }
 
            break;
        case IS_ENUM_FATWEIGHT:
            switch (self.fatWeightLevel) {
                case 1:
//                    return @"偏低";
                    return [UIColor orangeColor];

                    break;
                case 2:
//                    return @"正常";
                    return [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];

                    break;
                case 3:
//                    return @"偏高";
                    return [UIColor orangeColor];

                    break;
                case 4:
//                    return @"超标";
                    return [UIColor redColor];

                    break;
                    
                default:
                    break;
            }

            break;
            
        default:
            break;
    }
    return nil;
}




@end
