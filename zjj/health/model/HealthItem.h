//
//  HealthItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthItem : NSObject
@property (nonatomic,assign) float              waterWeight ;//// 细胞总水
@property (nonatomic,assign) float              weight ;//// 体重
@property (nonatomic,assign) float              muscleWeight ;//// 肌肉重量
@property (nonatomic,assign) float              bmi ;//// 体质指数
@property (nonatomic,assign) float              lastWeight ;////上次体重
@property (nonatomic,assign) float              fatWeight ;////脂肪重
@property (nonatomic,assign) float              bmr ;//// 基础代谢率
@property (nonatomic,assign) float              bodyAge ;//// 身体年龄
@property (nonatomic,assign) float              visceralFatPercentage ;////内脏脂肪指数
@property (nonatomic,assign) float              proteinWeight ;//// 蛋白质重量

@property (nonatomic,assign) int                normal ;////正常
@property (nonatomic,assign) int                warn ;////警告
@property (nonatomic,assign) int                serious ;////严重

@property (nonatomic,assign) int                DataId ;////评测数据id
@property (nonatomic,assign) int                bmiLevel ;////bmi程度
@property (nonatomic,assign) int                visceralFatPercentageLevel ;////内脂判定标准
@property (nonatomic,assign) int                fatWeightLevel ;////脂肪重判定标准
@property (nonatomic,assign) int                proteinLevel ;////蛋白质判定标准
@property (nonatomic,assign) int                waterLevel ;////水分判定标准
@property (nonatomic,assign) int                muscleLevel ;////肌肉判定标准
@property (nonatomic,assign) int                userId ;//
@property (nonatomic,assign) int                subUserId ;//
@property (nonatomic,assign) int                weightLevel ;////体重判定标准
@property (nonatomic,copy  ) NSString     *     createTime ;////检测时间
@property (nonatomic,assign) float              fatPercentage;

-(void)setobjectWithDic:(NSDictionary *)dict ;//

/*
@property (nonatomic,assign) int                DataId ;//评测数据id
@property (nonatomic,assign) int                userId ;//
@property (nonatomic,assign) int                subUserId ;//
@property (nonatomic,assign) float              score ; //健康得分
@property (nonatomic,assign) float              weight ;// 体重
@property (nonatomic,assign) float              bmr ;// 基础代谢率
@property (nonatomic,assign) float              bodyAge ;// 身体年龄
@property (nonatomic,assign) float              bmi ;// 体质指数
@property (nonatomic,assign) int                warn ;//
@property (nonatomic,assign) int                normal ;//
@property (nonatomic,assign) int                serious ;//

@property (nonatomic,assign) int                bmiLevel ;//bmi程度

@property (nonatomic,assign) int                visceralFatPercentageLevel ;//内脂判定标准
@property (nonatomic,assign) NSDecimal          mVisceralFat ;// 内脏脂肪
@property (nonatomic,assign) float              visceralFatPercentage ;//内脏脂肪指数

@property (nonatomic,assign) NSDecimal          mFat ;// 体脂
@property (nonatomic,assign) int                fatWeightLevel ;//脂肪重判定标准
@property (nonatomic,assign) float              fatWeight ;//脂肪重
@property (nonatomic,assign) float              fatWeightMax ;// 脂肪重正常范围上限
@property (nonatomic,assign) float              fatWeightMin ;// 脂肪重正常范围下限

@property (nonatomic,assign) float              fatPercentage ;// 体脂百分比
@property (nonatomic,assign) float              fatPercentageMax ;// 体脂指数正常范围上限
@property (nonatomic,assign) float              fatPercentageMin ;// 体脂指数正常范围下限


@property (nonatomic,assign) int                weightLevel ;//体重判定标准
@property (nonatomic,assign) int                bodyLevel ;//体型判定标准
@property (nonatomic,assign) int                fatPercentageLevel ;//体脂百分比判定标准

@property (nonatomic,assign) NSDecimal          mMuscle ;// 肌肉
@property (nonatomic,assign) float              muscleWeight ;// 肌肉重量
@property (nonatomic,assign) int                muscleLevel ;//肌肉判定标准
@property (nonatomic,assign) float              muscleWeightMax ;// 肌肉最大重量
@property (nonatomic,assign) float              muscleWeightMin ;// 肌肉最小重量

@property (nonatomic,assign) NSDecimal          mBone ;// 骨骼肌
@property (nonatomic,assign) float              boneMuscleWeight ;// 骨骼肌
@property (nonatomic,assign) int                boneMuscleLevel ;//骨骼肌判定标准
@property (nonatomic,assign) float              boneMuscleWeightMax ;// 骨骼肌正常范围上限
@property (nonatomic,assign) float              boneMuscleWeightMin ;// 骨骼肌正常范围下限

@property (nonatomic,assign) float              waterWeight ;// 细胞总水
@property (nonatomic,assign) float              waterWeightMax ;// 细胞总水正常范围上限
@property (nonatomic,assign) float              waterWeightMin ;// 细胞总水正常范围下限
@property (nonatomic,assign) NSDecimal          mWater ;// 水分
@property (nonatomic,assign) float              waterPercentage ;// 水分率
@property (nonatomic,assign) int                waterLevel ;//水分判定标准

@property (nonatomic,assign) float              proteinWeight ;// 蛋白质重量
@property (nonatomic,assign) float              proteinWeightMax ;// 蛋白质最大重量
@property (nonatomic,assign) float              proteinWeightMin ;// 蛋白质最小重量
@property (nonatomic,assign) int                proteinLevel ;//蛋白质判定标准

@property (nonatomic,assign) float              boneWeight ;// 骨质重
@property (nonatomic,assign) int                boneLevel ;//骨重判定标准
@property (nonatomic,assign) float              boneWeightMax ;// 骨质重正常范围上限
@property (nonatomic,assign) float              boneWeightMin ;// 骨质重正常范围下限



@property (nonatomic,copy  ) NSString     *     createTime ;//检测时间
@property (nonatomic,assign) NSDecimal          mCalorie ;// 脂肪量
*/
@end
