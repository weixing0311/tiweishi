//
//  TimeModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModel : NSObject
+(TimeModel *)shareInstance;
/**
 *  计算年龄
 */
- (int)ageWithDateOfBirth:(NSString *)date;
@end
