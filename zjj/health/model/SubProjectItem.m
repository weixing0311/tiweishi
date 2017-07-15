//
//  SubProjectItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "SubProjectItem.h"

@implementation SubProjectItem
+(SubProjectItem *)shareInstance
{
    static SubProjectItem * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SubProjectItem alloc]init];
    });
    return manager;
}



@end
