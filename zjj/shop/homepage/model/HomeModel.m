//
//  HomeModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HomeModel.h"
static HomeModel * model;
@implementation HomeModel
+(HomeModel *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model =[[ HomeModel alloc]init];
    });
    return model;
}
-(NSMutableArray *)arraySortingWithArray:(NSMutableArray *)array
{
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"orders" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    return array;
}
@end
