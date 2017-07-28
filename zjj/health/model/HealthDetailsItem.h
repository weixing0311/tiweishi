//
//  HealthDetailsItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthDetailsItem : NSObject
+(HealthDetailsItem *)instance;

@property (nonatomic,assign) int                DataId;//评测数据id
@property (nonatomic,assign) int                userId;
@property (nonatomic,assign) int                subUserId;
@property (nonatomic,copy  ) NSString     *     createTime;//检测时间

@property (nonatomic,assign) float              score;//分数

@property (nonatomic,assign) float              lastWeight;
@property (nonatomic,assign) float              weight;// 体重
@property (nonatomic,assign) int                weightLevel;//体重判定标准



@property (nonatomic,assign) float              bmi;// 体质指数
@property (nonatomic,assign) int                bmiLevel;//bmi程度

@property (nonatomic,assign) int                mVisceralFat;//内脏脂肪
@property (nonatomic,assign) float              visceralFatPercentage;//内脏脂肪指数
@property (nonatomic,assign) int                visceralFatPercentageLevel;//内脂判定标准


@property (nonatomic,assign) float              bmr;// 基础代谢率
@property (nonatomic,assign) int              bodyAge;// 身体年龄
@property (nonatomic,assign) int                bodyLevel; //身体指数

@property (nonatomic,assign) float              mFat;//体脂
@property (nonatomic,assign) float              fatWeight;//脂肪重
@property (nonatomic,assign) float              fatWeightMax;
@property (nonatomic,assign) float              fatWeightMin;
@property (nonatomic,assign) int                fatWeightLevel;//脂肪重判定标准

@property (nonatomic,assign) float              mWater;//水分
@property (nonatomic,assign) float              waterWeight;// 细胞总水
@property (nonatomic,assign) float              waterWeightMax;
@property (nonatomic,assign) float              waterWeightMin;
@property (nonatomic,assign) int                waterLevel;//水分判定标准


@property (nonatomic,assign) float              proteinWeight;// 蛋白质重量
@property (nonatomic,assign) float              proteinWeightMax;
@property (nonatomic,assign) float              proteinWeightMin;
@property (nonatomic,assign) int                proteinLevel;//蛋白质判定标准


@property (nonatomic,assign) float              mBone;//骨骼肌
@property (nonatomic,assign) float              boneWeight;//骨头重量
@property (nonatomic,assign) float              boneWeightMax;
@property (nonatomic,assign) float              boneWeightMin;
@property (nonatomic,assign) int                boneLevel;

@property (nonatomic,assign) float              mMuscle;//肌肉
@property (nonatomic,assign) float              muscleWeight;// 肌肉重量
@property (nonatomic,assign) float              muscleWeightMax;
@property (nonatomic,assign) float              muscleWeightMin;
@property (nonatomic,assign) int                muscleLevel;//肌肉判定标准

@property (nonatomic,assign) float                mCalorie;//脂肪量
@property (nonatomic,assign) float              fatPercentage; //脂肪比例
@property (nonatomic,assign) float              fatPercentageMax;
@property (nonatomic,assign) float              fatPercentageMin;
@property (nonatomic,assign) int                fatPercentageLevel;


@property (nonatomic,assign) int                boneMuscleLevel;//骨骼肌
@property (nonatomic,assign) float              boneMuscleWeight;
@property (nonatomic,assign) float              boneMuscleWeightMin;
@property (nonatomic,assign) float              boneMuscleWeightMax;

@property (nonatomic,assign) float              standardWeight;//标准体重
@property (nonatomic,assign) float              weightControl;//体重控制量
@property (nonatomic,assign) float              lbm;//去脂体重
@property (nonatomic,assign) float              fatControl;//脂肪控制量


@property (nonatomic,assign) int                normal;//正常
@property (nonatomic,assign) int                warn;//警告
@property (nonatomic,assign) int                serious;//严重
-(void)getInfoWithDict:(NSDictionary *)dict;
-(NSMutableDictionary *)setSliderInfoWithRow:(NSInteger)row btnTag:(NSInteger)btnTag;
/*
 
 "waterWeight":3913.92,
         "normal":5,
         "score":-35364.62,
         "bmiLevel":2,
         "visceralFatPercentage":6,
         "visceralFatPercentageLevel":1,
         "bodyAge":42,
         "proteinLevel":1,
         "waterLevel":2,
         "fatPercentageMax":0.2,
         "fatWeightMax":12.96,
         "muscleLevel":1,
         "fatWeightMin":6.48,
         "mVisceralFat":6,
         "userId":1,
         "waterWeightMin":34.992,
         "boneWeight":285.29794,
         "bodyLevel":8,
         "serious":0,
         "waterWeightMax":42.768,
         "boneWeightMax":3.564,
         "proteinWeightMin":9.0396,
         "proteinWeightMax":11.0484,
         "boneWeightMin":2.916,
         "bmr":1480.5,
         "weightLevel":1,
         "mFat":14.3,
         "subUserId":10,
         "warn":4,
         "mMuscle":34.6,
         "createTime":"2017-06-11 10:05:46",
         "weight":64.8,
         "bmi":22.422146,
         "fatPercentageMin":0.1,
         "DataId":6,
         "muscleWeightMin":44.78725,
         "boneMuscleLevel":1,
         "fatWeightLevel":2,
         "fatWeight":-5237.9443,
         "boneMuscleWeight":3579.9478,
         "waterPercentage":60.4,
         "fatPercentageLevel":2,
         "boneMuscleWeightMin":33.590435,
         "mCalorie":1555,
         "proteinWeight":1103.5261,
         "mWater":60.4,
         "boneLevel":1,
         "muscleWeight":5017.4463,
         "fatPercentage":-80.83247,
         "muscleWeightMax":54.73997,
         "boneMuscleWeightMax":41.054977,
         "mBone":3.1
 */
@end
