//
//  ShareHealthItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShareHealthItem.h"
#import "NSString+dateWithString.h"
static ShareHealthItem *item;

@implementation ShareHealthItem
+(ShareHealthItem *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        item = [[ShareHealthItem alloc]init];
    });
    return item;
}
-(void)setobjectWithDic:(NSDictionary *)dict
{
    self.DataId =[[dict safeObjectForKey:@"DataId"]intValue];//评测数据id
    self.userId =[[dict safeObjectForKey:@"userId"]intValue];//
    self.subUserId =[[dict safeObjectForKey:@"subUserId"]intValue];//
    self.score =[[dict safeObjectForKey:@"score"]floatValue]; //健康得分
    self.weight =[[dict safeObjectForKey:@"weight"]floatValue];// 体重
    self.bmr =[[dict safeObjectForKey:@"bmr"]floatValue];// 基础代谢率
    self.bodyAge =[[dict safeObjectForKey:@"bodyAge"]intValue];// 身体年龄
    self.bmi =[[dict safeObjectForKey:@"bmi"]floatValue];// 体质指数
    self.warn =[[dict safeObjectForKey:@"warn"]intValue];//
    self.normal =[[dict safeObjectForKey:@"normal"]intValue];//
    self.serious =[[dict safeObjectForKey:@"serious"]intValue];//
    
    self.bmiLevel =[[dict safeObjectForKey:@"bmiLevel"]intValue];//bmi程度
    
    self.visceralFatPercentageLevel =[[dict safeObjectForKey:@"visceralFatPercentageLevel"]intValue];//内脂判定标准
    self.mVisceralFat = [[dict safeObjectForKey:@"mVisceralFat"]intValue];// 内脏脂肪
    self.visceralFatPercentage =[[dict safeObjectForKey:@"visceralFatPercentage"]floatValue];//内脏脂肪指数
    
    self.mFat =[[dict safeObjectForKey:@"mFat"]floatValue];// 体脂
    self.fatWeightLevel =[[dict safeObjectForKey:@"fatWeightLevel"]intValue];//脂肪重判定标准
    self.fatWeight =[[dict safeObjectForKey:@"fatWeight"]floatValue];//脂肪重
    self.fatWeightMax =[[dict safeObjectForKey:@"fatWeightMax"]floatValue];// 脂肪重正常范围上限
    self.fatWeightMin =[[dict safeObjectForKey:@"fatWeightMin"]floatValue];// 脂肪重正常范围下限
    
    self.fatPercentage =[[dict safeObjectForKey:@"fatPercentage"]floatValue];// 体脂百分比
    self.fatPercentageMax =[[dict safeObjectForKey:@"fatPercentageMax"]floatValue];// 体脂指数正常范围上限
    self.fatPercentageMin =[[dict safeObjectForKey:@"fatPercentageMin"]floatValue];// 体脂指数正常范围下限
    
    
    self.weightLevel =[[dict safeObjectForKey:@"weightLevel"]intValue];//体重判定标准
    self.bodyLevel =[[dict safeObjectForKey:@"bodyLevel"]intValue];//体型判定标准
    self.fatPercentageLevel =[[dict safeObjectForKey:@"fatPercentageLevel"]intValue];//体脂百分比判定标准
    
    self.mMuscle =[[dict safeObjectForKey:@"mMuscle"]floatValue];// 肌肉
    self.muscleWeight =[[dict safeObjectForKey:@"muscleWeight"]floatValue];// 肌肉重量
    self.muscleLevel =[[dict safeObjectForKey:@"muscleLevel"]intValue];//肌肉判定标准
    self.muscleWeightMax =[[dict safeObjectForKey:@"muscleWeightMax"]floatValue];// 肌肉最大重量
    self.muscleWeightMin =[[dict safeObjectForKey:@"muscleWeightMin"]floatValue];// 肌肉最小重量
    
    self.mBone =[[dict safeObjectForKey:@"mBone"]floatValue];// 骨骼肌
    self.boneMuscleWeight =[[dict safeObjectForKey:@"boneMuscleWeight"]floatValue];// 骨骼肌
    self.boneMuscleLevel =[[dict safeObjectForKey:@"boneMuscleLevel"]intValue];//骨骼肌判定标准
    self.boneMuscleWeightMax =[[dict safeObjectForKey:@"boneMuscleWeightMax"]floatValue];// 骨骼肌正常范围上限
    self.boneMuscleWeightMin =[[dict safeObjectForKey:@"boneMuscleWeightMin"]floatValue];// 骨骼肌正常范围下限
    
    self.waterWeight =[[dict safeObjectForKey:@"waterWeight"]floatValue];// 细胞总水
    self.waterWeightMax =[[dict safeObjectForKey:@"waterWeightMax"]floatValue];// 细胞总水正常范围上限
    self.waterWeightMin =[[dict safeObjectForKey:@"waterWeightMin"]floatValue];// 细胞总水正常范围下限
    self.mWater =[[dict safeObjectForKey:@"mWater"]floatValue];// 水分
    self.waterPercentage =[[dict safeObjectForKey:@"waterPercentage"]floatValue];// 水分率
    self.waterLevel =[[dict safeObjectForKey:@"waterLevel"]intValue];//水分判定标准
    
    self.proteinWeight =[[dict safeObjectForKey:@"proteinWeight"]floatValue];// 蛋白质重量
    self.proteinWeightMax =[[dict safeObjectForKey:@"proteinWeightMax"]floatValue];// 蛋白质最大重量
    self.proteinWeightMin =[[dict safeObjectForKey:@"proteinWeightMin"]floatValue];// 蛋白质最小重量
    self.proteinLevel =[[dict safeObjectForKey:@"proteinLevel"]intValue];//蛋白质判定标准
    
    self.boneWeight =[[dict safeObjectForKey:@"boneWeight"]floatValue];// 骨质重
    self.boneLevel =[[dict safeObjectForKey:@"boneLevel"]intValue];//骨重判定标准
    self.boneWeightMax =[[dict safeObjectForKey:@"boneWeightMax"]floatValue];// 骨质重正常范围上限
    self.boneWeightMin =[[dict safeObjectForKey:@"boneWeightMin"]floatValue];// 骨质重正常范围下限
    
    
    
    self.createTime =[[dict safeObjectForKey:@"createTime"] dateyyyymmddhhmmss ];//检测时间
    self.mCalorie = [[dict safeObjectForKey:@"mCalorie"]floatValue];// 脂肪量

}

/**
 * 根据level获取 正常/偏瘦/危险、
 */
-(NSString *)getStatusWithLevel:(int)level status:(mytype)isMytype
{
    /*
    IS_BMI,
    IS_VISCERALFAT,//内脂
    IS_FAT,//脂肪
    IS_FATPERCENT,//体脂  fatPercentage
    IS_SAME,//肌肉\骨量\水分\蛋白质\骨重判定标准
    IS_BODYWEIGHT,//体重判定
    IS_SIZE,//体型
     */

    switch (isMytype) {
        case IS_BMI:
            switch (level) {
                case 1:
                    return @"偏低";
                    break;
                case 2:
                    return @"正常";
                    break;
                case 3:
                    return @"偏高";
                    break;
                case 4:
                    return @"超标";
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_VISCERALFAT:
            switch (level) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"警告";
                    break;
                case 3:
                    return @"严重";
                    break;
                    
                default:
                    break;
            }
           
            break;
        case IS_FAT:
            switch (level) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"警告";
                    break;
                case 3:
                    return @"严重";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_FATPERCENT:
            switch (level) {
                case 1:
                    return @"偏低";
                    break;
                case 2:
                    return @"正常";
                    break;
                case 3:
                    return @"偏高";
                    break;
                case 4:
                    return @"超标";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_BODYWEIGHT:
            switch (level) {
                case 1:
                    return @"偏瘦";
                    break;
                case 2:
                    return @"正常";
                    break;
                case 3:
                    return @"轻度肥胖";
                    break;
                case 4:
                    return @"中度肥胖";
                    break;
                case 5:
                    return @"重度肥胖";
                    break;
                case 6:
                    return @"极度肥胖";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_SIZE:
            switch (level) {
                case 1:
                    return @"隐性肥胖型";
                    break;
                case 2:
                    return @"脂肪过多";
                    break;
                case 3:
                    return @"肥胖";
                    break;
                case 4:
                    return @"肌肉不足";
                    break;
                case 5:
                    return @"健康匀称型";
                    break;
                case 6:
                    return @"超重肌肉型";
                    break;
                case 7:
                    return @"消瘦型";
                    break;
                case 8:
                    return @"低脂肪型";
                    break;
                case 9:
                    return @"运动员型";
                    break;
                   
                default:
                    break;
            }
            
            break;
        case IS_SAME:
            switch (level) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"警告";
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


-(NSString *)getHeightWithLevel:(int)level status:(mytype)isMytype
{
    /*
     weightLevel  1偏瘦2正常3警告4警告5超重6超重  1低 2正常  3456 高
     fatPercentage level  1正常2低3高
     
     weightLevel  1偏瘦2正常3偏胖4偏胖5超重6超重      1低 2正常  3456 高
     fatPercentage level  1正常2低3高
     fatweightlevel  1正常2低3高
     
     bmi  1低  2正常3高4高
     内脂  1正常2超标3高
     蛋白质(P)/骨骼肌(boneMuscle)/骨量(boneWeight)/水分(waterWieghtLevel)/肌肉(Muscle)  1正常 else低

     
     
     
     
     */

    switch (isMytype) {
        case IS_BMI:
            switch (level) {
                case 1:
                    return @"低";
                    break;
                case 2:
                    return @"正常";
                    break;
                case 3:
                    return @"高";
                    break;
                case 4:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_VISCERALFAT:
            switch (level) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"超标";
                    break;
                case 3:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_FAT:
            switch (level) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                case 3:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_FATPERCENT:
            switch (level) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                case 3:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_BODYWEIGHT:
            switch (level) {
                case 1:
                    return @"低";
                    break;
                case 2:
                    return @"正常";
                    break;
                case 3:
                    return @"偏高";
                    break;
                case 4:
                    return @"偏高";
                    break;
                case 5:
                    return @"高";
                    break;
                case 6:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_SIZE:
            switch (level) {
                case 1:
                    return @"隐性肥胖型";
                    break;
                case 2:
                    return @"脂肪过多";
                    break;
                case 3:
                    return @"肥胖";
                    break;
                case 4:
                    return @"肌肉不足";
                    break;
                case 5:
                    return @"健康匀称型";
                    break;
                case 6:
                    return @"超重肌肉型";
                    break;
                case 7:
                    return @"消瘦型";
                    break;
                case 8:
                    return @"低脂肪型";
                    break;
                case 9:
                    return @"运动员型";
                    break;
                    
                default:
                    break;
            }

            break;
//        case IS_BONEMUSCLE:
//            if (level==1) {
//                return @"正常";
//            }
//            else{
//                return @"低";
//            }
//            break;
        case IS_SAME:
            if (level==1) {
                return @"正常";
            }else
            {
                return @"低";
            }
            break;
        default:
            break;
    }
    return nil;
}



@end
