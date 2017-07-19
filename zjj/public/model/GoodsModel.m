//
//  GoodsModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
+(GoodsModel *)shareInstance
{
    static GoodsModel * model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[GoodsModel alloc]init];
    });
    return model;
}

@end
