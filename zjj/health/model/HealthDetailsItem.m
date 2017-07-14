//
//  HealthDetailsItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailsItem.h"
#import "HealthModel.h"
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
    
    self . lastWeight            = [[dict safeObjectForKey:@"lastWeight"]floatValue];
    
    
    
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
    self . fatPercentage         = [[dict safeObjectForKey:@"fatPercentage"]floatValue]*100;
    self . fatPercentageMax      = [[dict safeObjectForKey:@"fatPercentageMax"]floatValue]*100;
    self . fatPercentageMin      = [[dict safeObjectForKey:@"fatPercentageMin"]floatValue]*100;
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


-(NSMutableDictionary *)setSliderInfoWithRow:(NSInteger)row btnTag:(NSInteger)btnTag
{
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    
    if (btnTag ==4&&row ==1) {
        [dic setObject:@"markbg2" forKey:@"markBg"];
    }else{
        [dic setObject:@"markBg" forKey:@"markBg"];
        
    }
    float x =0.0f;
    switch (row) {
        case 0:
            switch (btnTag) {
                case 1:
                    [dic safeSetObject:[NSString stringWithFormat:@"18.5"] forKey:@"lowText"] ;
                    [dic safeSetObject:[NSString stringWithFormat:@"24.0"] forKey:@"HeightText"];;
                    x = [self getLocationWithMax:24.0
                                             Min:18.5
                                            info:[HealthDetailsItem instance].bmi ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_BMI] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_BMI] forKey:@"color"];
                    
                    break;
                case 2:
                    
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1f%%",[HealthDetailsItem instance].fatPercentageMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1f%%",[HealthDetailsItem instance].fatPercentageMin] forKey:@"lowText"];
                    x = [self getLocationWithMax:[HealthDetailsItem instance].fatPercentageMax
                                             Min:[HealthDetailsItem instance].fatPercentageMin
                                            info:[HealthDetailsItem instance].fatPercentage ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_FATPERCENT] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_FATPERCENT] forKey:@"color"];
                    break;
                case 3:
                    
                    
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatWeightMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatWeightMin] forKey:@"lowText"];
                    x = [self getLocationWithMax:[HealthDetailsItem instance].fatWeightMax
                                             Min:[HealthDetailsItem instance].fatWeightMin
                                            info:[HealthDetailsItem instance].fatWeight ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_FAT] forKey:@"info"];
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_FAT] forKey:@"color"];

                    break;
                case 4:

                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].waterWeightMax] forKey:@"HeightText"];

                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].waterWeightMin] forKey:@"lowText"];;
                    x = [self getLocationWithMax:[HealthDetailsItem instance].waterWeightMax
                                             Min:[HealthDetailsItem instance].waterWeightMin
                                            info:[HealthDetailsItem instance].waterWeight ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_WATER] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_WATER] forKey:@"color"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (btnTag) {
                case 1:
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].proteinWeightMin] forKey:@"lowText"];
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].proteinWeightMax] forKey:@"HeightText"]; ;
                    
                    x = [self getLocationWithMax:[HealthDetailsItem instance].proteinWeightMax
                                             Min:[HealthDetailsItem instance].proteinWeightMin
                                            info:[HealthDetailsItem instance].proteinWeight ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_PROTEIN] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_PROTEIN] forKey:@"color"];
                    break;
                case 2:
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].muscleWeightMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].muscleWeightMin] forKey:@"lowText"];
                    
                    x = [self getLocationWithMax:[HealthDetailsItem instance].muscleWeightMax
                                             Min:[HealthDetailsItem instance].muscleWeightMin
                                            info:[HealthDetailsItem instance].muscleWeight ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_MUSCLE] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_MUSCLE] forKey:@"color"];
                    break;
                case 3:
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].boneMuscleWeightMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].boneMuscleWeightMin] forKey:@"lowText"]; ;
                    
                    x = [self getLocationWithMax:[HealthDetailsItem instance].boneMuscleWeightMax
                                             Min:[HealthDetailsItem instance].boneMuscleWeightMin
                                            info:[HealthDetailsItem instance].boneMuscleWeight ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_BONEMUSCLE] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_BONEMUSCLE] forKey:@"color"];
                    break;
                case 4:
                    [dic safeSetObject:[NSString stringWithFormat:@"14.0"] forKey:@"HeightText"]; ;
                    [dic safeSetObject:[NSString stringWithFormat:@"10.0"] forKey:@"lowText"];
                    
                    
                    x = [self getLocationWithMax:14.0 Min:10.0  info:[HealthDetailsItem instance].visceralFatPercentage ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_VISCERALFAT] forKey:@"info"];
                    
                    
                    
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_VISCERALFAT] forKey:@"color"];
                    break;
                    
                default:
                    break;
            }
            
            break;
        default:
            break;
    }
    
    [dic setObject:@(x) forKey:@"x"];
    return dic;
    
}

-(float)getLocationWithMax:(float)maxdd Min:(float)mindd info:(float)locinfo
{
    
    DLog(@"%.1f---%.1f",maxdd,locinfo);
    float width = JFA_SCREEN_WIDTH-26;
    
    float onedd = width/3/(maxdd-mindd);
    
    
    
    if (locinfo<mindd) {
        
        if (width/3-onedd*(mindd-locinfo)<0) {
            return 13;
        }else{
         return  13+width/3-onedd*(mindd-locinfo);
        }
        
        
    }else if (locinfo>=mindd&&locinfo <maxdd)
    {
        return 13+width/3+(locinfo-mindd)*onedd;
    }else{
        if ((locinfo-maxdd)*onedd>width/3) {
            return width;
        }else{
            return 13+width/3*2+(locinfo-maxdd)*onedd;
        }
    }
    
    
    
}

-(UIColor *)getHealthDetailColorWithStatus:(mytype)myType
{
    switch (myType) {
        case IS_MODEL_BMI:
            if ([HealthDetailsItem instance].bmi<18.5) {
                
            }
            else if (([HealthDetailsItem instance].bmi>=18.5&&([HealthDetailsItem instance].bmi<24)))
            {
                
            }else
            {
                
            }
            break;
        case IS_MODEL_FATPERCENT:
            break;
        case IS_MODEL_FAT:
            break;
        case IS_MODEL_WATER:
            break;
        case IS_MODEL_PROTEIN:
            
            
            break;
        case IS_MODEL_MUSCLE:
            
            
            break;
        case IS_MODEL_BONEMUSCLE:
            break;
            
            
        case IS_MODEL_VISCERALFAT:
            break;
            
        default:
            break;
    }
    return nil;
}

@end
