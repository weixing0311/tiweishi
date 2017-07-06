//
//  shopCarCellItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopCarCellItem : NSObject
@property (nonatomic,copy  )NSString * productNo; //商品id
@property (nonatomic,copy  )NSString * productName;//商品名称
@property (nonatomic,copy  )NSString * oldPrice; //原价
@property (nonatomic,copy  )NSString * productPrice;//现价
@property (nonatomic,copy  )NSString * productWeight;//重量
@property (nonatomic,copy  )NSString * image;//图片
@property (nonatomic,copy  )NSString * isDistribution;//是否分销
@property (nonatomic,copy  )NSString * freightTemplateId;//运费模板
@property (nonatomic,copy  )NSString * stock;//库存
@property (nonatomic,copy  )NSString * isDelivery;//是否需要配送 0否1是
@property (nonatomic,copy  )NSString * affiliation;//商品归属 1消费者 2体脂师
@property (nonatomic,copy  )NSString * restrictionNum;//单笔订单限购数量
@property (nonatomic,copy  )NSString * status;//1正常 2已下架 0 删除
@property (nonatomic,copy  )NSString * quantity;//数量


@property (nonatomic,strong)NSArray * promotList;

-(void)setupInfoWithDict:(NSDictionary *)dict;

@end
