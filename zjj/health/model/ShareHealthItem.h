//
//  ShareHealthItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    IS_BMI,
    IS_VISCERALFAT,//内脂
    IS_FAT,//脂肪
    IS_FATPERCENT,//体脂  fatPercentage
    IS_SAME,//肌肉\骨骼肌\水分\蛋白质\骨重判定标准
    IS_BODYWEIGHT,//体重判定
    IS_SIZE,//体型
}mytype;
@interface ShareHealthItem : NSObject
+(ShareHealthItem *)shareInstance;

@property (nonatomic,assign)mytype              type;

@property (nonatomic,assign) int                DataId ;//评测数据id
@property (nonatomic,assign) int                userId ;//
@property (nonatomic,assign) int                subUserId ;//
@property (nonatomic,assign) float              score ; //健康得分
@property (nonatomic,assign) float              weight ;// 体重
@property (nonatomic,assign) float              bmr ;// 基础代谢率
@property (nonatomic,assign) int                bodyAge ;// 身体年龄
@property (nonatomic,assign) float              bmi ;// 体质指数
@property (nonatomic,assign) int                warn ;//
@property (nonatomic,assign) int                normal ;//
@property (nonatomic,assign) int                serious ;//

@property (nonatomic,assign) int                bmiLevel ;//bmi程度

@property (nonatomic,assign) int                visceralFatPercentageLevel ;//内脂判定标准
@property (nonatomic,assign) float              mVisceralFat ;// 内脏脂肪
@property (nonatomic,assign) float              visceralFatPercentage ;//内脏脂肪指数


@property (nonatomic,assign) int                fatWeightLevel ;//脂肪重判定标准
@property (nonatomic,assign) float              fatWeight ;//脂肪重
@property (nonatomic,assign) float              fatWeightMax ;// 脂肪重正常范围上限
@property (nonatomic,assign) float              fatWeightMin ;// 脂肪重正常范围下限


@property (nonatomic,assign) float              mFat ;// 体脂
@property (nonatomic,assign) float              fatPercentage ;// 体脂百分比
@property (nonatomic,assign) float              fatPercentageMax ;// 体脂指数正常范围上限
@property (nonatomic,assign) float              fatPercentageMin ;// 体脂指数正常范围下限
@property (nonatomic,assign) int                fatPercentageLevel ;//体脂百分比判定标准



@property (nonatomic,assign) int                weightLevel ;//体重判定标准
@property (nonatomic,assign) int                bodyLevel ;//体型判定标准



@property (nonatomic,assign) float          mMuscle ;// 肌肉
@property (nonatomic,assign) float              muscleWeight ;// 肌肉重量
@property (nonatomic,assign) int                muscleLevel ;//肌肉判定标准
@property (nonatomic,assign) float              muscleWeightMax ;// 肌肉最大重量
@property (nonatomic,assign) float              muscleWeightMin ;// 肌肉最小重量
@property (nonatomic,copy  ) NSString    *      muscleLevelStr;


@property (nonatomic,assign) float          mBone ;// 骨骼肌
@property (nonatomic,assign) float              boneMuscleWeight ;// 骨骼肌
@property (nonatomic,assign) int                boneMuscleLevel ;//骨骼肌判定标准
@property (nonatomic,assign) float              boneMuscleWeightMax ;// 骨骼肌正常范围上限
@property (nonatomic,assign) float              boneMuscleWeightMin ;// 骨骼肌正常范围下限
@property (nonatomic,copy  ) NSString    *      boneMuscleLevelStr;

@property (nonatomic,assign) float              waterWeight ;// 细胞总水
@property (nonatomic,assign) float              waterWeightMax ;// 细胞总水正常范围上限
@property (nonatomic,assign) float              waterWeightMin ;// 细胞总水正常范围下限
@property (nonatomic,assign) float              mWater ;// 水分
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
@property (nonatomic,assign) float          mCalorie ;// 脂肪量
-(void)setobjectWithDic:(NSDictionary *)dict ;
-(NSString *)getHeightWithLevel:(int)level status:(mytype)isMytype;
-(NSString *)getStatusWithLevel:(int)level status:(mytype)isMytype;
@end
