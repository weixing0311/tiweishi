//
//  BTManager.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BTManager.h"
static BTManager * btmanager;
@implementation BTManager
+(BTManager*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        btmanager = [[BTManager alloc]init];
    });
    return btmanager;
}

@end
