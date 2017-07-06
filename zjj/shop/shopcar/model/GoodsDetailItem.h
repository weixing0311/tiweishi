//
//  GoodsDetailItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailItem : NSObject

+(GoodsDetailItem *)shareInstance;

@property (nonatomic,copy  )NSString * productNo;
@property (nonatomic,copy  )NSString * productName;
@property (nonatomic,copy  )NSString * viceTitle;
@property (nonatomic,copy  )NSString * oldPrice;
@property (nonatomic,copy  )NSString * productPrice;
@property (nonatomic,copy  )NSString * productWeight;
@property (nonatomic,copy  )NSString * image;
@property (nonatomic,copy  )NSString * fatTeacherproductPrice;
@property (nonatomic,strong)NSArray * promotList;
@property (nonatomic,strong)NSMutableArray * pictureArray;
@property (nonatomic,copy) NSString * freightTemplateId;

@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,assign)int isDelivery;
@property (nonatomic,assign)int isDistribution;


-(void)setupInfoWithDict:(NSDictionary *)dict;
@end
