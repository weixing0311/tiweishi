//
//  HealthDetailsItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailsItem.h"
static HealthDetailsItem *item;
@implementation HealthDetailsItem
+(HealthDetailsItem *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        item = [[HealthDetailsItem alloc]init];
    });
    return item;
}
-(void)getInfoWithDict:(NSDictionary *)dict
{
    
    self . DataId                = [[dict safeObjectForKey:@"DataId"]intValue];
    self . userId                = [[dict safeObjectForKey:@"userId"]intValue];
    self . subUserId             = [[dict safeObjectForKey:@"subUserId"]intValue];
    self . createTime            = [ dict safeObjectForKey:@"createTime"];
    self . score                 = [[dict safeObjectForKey:@"score"]floatValue];
    self . weight                = [[dict safeObjectForKey:@"weight"]floatValue];
    self . weightLevel           = [[dict safeObjectForKey:@"weightLevel"]intValue];
    self . bmi                   = [[dict safeObjectForKey:@"bmi"]floatValue];
    self . bmiLevel              = [[dict safeObjectForKey:@"bmiLevel"]intValue];
    self . mVisceralFat          = [[dict safeObjectForKey:@"mVisceralFat"]intValue];
    self . visceralFatPercentage = [[dict safeObjectForKey:@"visceralFatPercentage"]floatValue];
    self . visceralFatPercentageLevel = [[dict safeObjectForKey:@"visceralFatPercentageLevel"]floatValue];
    self . bmr                   = [[dict safeObjectForKey:@"bmr"]floatValue];
    self . bodyAge               = [[dict safeObjectForKey:@"bodyAge"]floatValue];
    self . bodyLevel             = [[dict safeObjectForKey:@"bodyLevel"]intValue];
    
    
    
    self . mFat                  = [[dict safeObjectForKey:@"mFat"]floatValue];
    self . fatWeight             = [[dict safeObjectForKey:@"fatWeight"]floatValue];
    self . fatWeightMax          = [[dict safeObjectForKey:@"fatWeightMax"]floatValue];
    self . fatWeightMin          = [[dict safeObjectForKey:@"fatWeightMin"]floatValue];
    self . fatWeightLevel        = [[dict safeObjectForKey:@"fatWeightLevel"]intValue];
    
    
    self . mWater                = [[dict safeObjectForKey:@"mWater"]floatValue];
    self . waterWeight           = [[dict safeObjectForKey:@"waterWeight"]floatValue];
    self . waterWeightMax        = [[dict safeObjectForKey:@"waterWeightMax"]floatValue];
    self . waterWeightMin        = [[dict safeObjectForKey:@"waterWeightMin"]floatValue];
    self . waterLevel            = [[dict safeObjectForKey:@"waterLevel"]intValue];
 
    
    self . proteinWeight         = [[dict safeObjectForKey:@"proteinWeight"]floatValue];
    self . proteinWeightMax      = [[dict safeObjectForKey:@"proteinWeightMax"]floatValue];
    self . proteinWeightMin      = [[dict safeObjectForKey:@"proteinWeightMin"]floatValue];
    self . proteinLevel          = [[dict safeObjectForKey:@"proteinLevel"]intValue];
  
    
    self . mBone                 = [[dict safeObjectForKey:@"mBone"]floatValue];
    self . boneWeight            = [[dict safeObjectForKey:@"boneWeight"]floatValue];
    self . boneWeightMax         = [[dict safeObjectForKey:@"boneWeightMax"]floatValue];
    self . boneWeightMin         = [[dict safeObjectForKey:@"boneWeightMin"]floatValue];
    self . boneLevel             = [[dict safeObjectForKey:@"boneLevel"]intValue];
 
    
    self . mMuscle               = [[dict safeObjectForKey:@"mMuscle"]floatValue];
    self . muscleWeight          = [[dict safeObjectForKey:@"muscleWeight"]floatValue];
    self . muscleWeightMax       = [[dict safeObjectForKey:@"muscleWeightMax"]floatValue];
    self . muscleWeightMin       = [[dict safeObjectForKey:@"muscleWeightMin"]floatValue];
    self . muscleLevel           = [[dict safeObjectForKey:@"muscleLevel"]intValue];
    

    self . mCalorie              = [[dict safeObjectForKey:@"mCalorie"]intValue];
    self . fatPercentage         = [[dict safeObjectForKey:@"fatPercentage"]floatValue];
    self . fatPercentageMax      = [[dict safeObjectForKey:@"fatPercentageMax"]floatValue];
    self . fatPercentageMin      = [[dict safeObjectForKey:@"fatPercentageMin"]floatValue];
    self . fatPercentageLevel    = [[dict safeObjectForKey:@"fatPercentageLevel"]intValue];
    

    
    self . boneMuscleLevel       = [[dict safeObjectForKey:@"boneMuscleLevel"]intValue];
    self . boneMuscleWeight      = [[dict safeObjectForKey:@"boneMuscleWeight"]floatValue];
    self . boneMuscleWeightMax   = [[dict safeObjectForKey:@"boneMuscleWeightMax"]floatValue];
    self . boneMuscleWeightMin   = [[dict safeObjectForKey:@"boneMuscleWeightMin"]floatValue];
    self . boneLevel             = [[dict safeObjectForKey:@"boneLevel"]intValue];
    

    
    self . normal                = [[dict safeObjectForKey:@"normal"]intValue];
    self . warn                  = [[dict safeObjectForKey:@"warn"]intValue];
    self . serious               = [[dict safeObjectForKey:@"serious"]intValue];

}
@end
