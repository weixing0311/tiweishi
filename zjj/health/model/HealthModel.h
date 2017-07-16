//
//  HealthModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareHealthItem.h"

@interface HealthModel : NSObject

+(HealthModel *)shareInstance;

typedef enum
{// BMI 体脂率 脂肪量 水分  蛋白质 肌肉 骨骼肌 内脏脂肪
    /**
     *BMI
     */
    IS_MODEL_BMI,
    /**
     *内脂
     */
    IS_MODEL_VISCERALFAT,//内脂
    /**
     *脂肪
     */
    IS_MODEL_FAT,//脂肪
    /**
     *骨头
     */
    IS_MODEL_BONE,//骨骼肌
    /**
     *水分
     */
    IS_MODEL_WATER,//水分
    /**
     *蛋白质
     */
    IS_MODEL_PROTEIN,//蛋白质 proteinWeight
    /**
     *体脂
     */
    IS_MODEL_FATPERCENT,//体脂  fatPercentage
    /**
     *肌肉
     */
    IS_MODEL_MUSCLE,//肌肉
    /**
     *骨骼肌
     */
    IS_MODEL_BONEMUSCLE,
    /**
     *体重
     */
    IS_MODEL_BODYWEIGHT,
    /**
     *体型
     */
    IS_MODEL_SIZE,//体型
}isMyType;
-(NSString *)getStatus:(isMyType)isMytype;
-(UIColor *)returnColorWithLevel:(int)level;
-(UIColor *)getHealthDetailColorWithStatus:(isMyType)myType;
-(UIColor *)getHealthHeaderColorWithStatus:(isMyType)myType item:(HealthItem*)item;
-(UIColor *)getHealthShareColorWithStatus:(isMyType)myType item:(ShareHealthItem*)item;





/**
 * 上传Debug-----上称蓝牙请求过程
 */
-(void)UpdateBlueToothInfo;

/**
 * 上传debug信息
 */
@property (nonatomic,copy)NSString   *  UpLoadlogString;

/**
 * debug信息拼接
 */
-(void)setLogInUpLoadString:(NSString *)logStr;
@end
