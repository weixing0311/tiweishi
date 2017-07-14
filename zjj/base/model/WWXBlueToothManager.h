//
//  WWXBlueToothManager.h
//  BlueToothTest
//
//  Created by iOSdeveloper on 2017/7/7.
//  Copyright © 2017年 -iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWXBlueToothManager : NSObject
+(WWXBlueToothManager *)shareInstance;

typedef void (^BlueToothSuccessBlock)(NSDictionary * dic);
typedef void (^BlueToothFailureBlock)(NSError      * error,NSString * errMsg);
typedef void (^BlueToothStatusBlock )(NSString     * statusString);
//请求成功回调block
@property (nonatomic ,copy) BlueToothSuccessBlock    successBlock;

//请求失败回调block
@property (nonatomic ,copy) BlueToothFailureBlock    faileBlock;

@property (nonatomic ,copy) BlueToothStatusBlock     statusBlock;
-(void)startScanWithStatus:(BlueToothStatusBlock)status
                success:(BlueToothSuccessBlock)success
                  faile:(BlueToothFailureBlock)faile;
-(void)stop;
@end
