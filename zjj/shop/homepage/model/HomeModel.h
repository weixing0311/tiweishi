//
//  HomeModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
+(HomeModel *)shareInstance;
-(NSMutableArray *)arraySortingWithArray:(NSMutableArray *)array;//banner排序
@end
