//
//  GoodsItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsItem : NSObject
@property (nonatomic ,copy  )NSString * content;
@property (nonatomic ,copy  )NSString * imageUrl;  //图片路径
@property (nonatomic ,copy  )NSString * productName; // 商品名称
@property (nonatomic ,copy  )NSString * productNo;  // 展位ID
@property (nonatomic ,copy  )NSString * viceTitle;//标题
@property (nonatomic ,copy  )NSString * oldPrice;//原来的价格
@property (nonatomic ,copy  )NSString * productPrice;          //价格
-(void)setGoodsInfoWithDict:(NSDictionary *)dict;

@end
/*
 affiliation = 0;
 createTime = "";
 defPicture = "http://192.168.0.130:81/images/product/700718.jpg";
 freightTemplateId = 0;
 isDelivery = 0;
 isDistribution = 0;
 oldPrice = 1380;
 operaterId = "";
 operaterIp = "";
 operaterName = "";
 picture2 = "";
 picture3 = "";
 picture4 = "";
 picture5 = "";
 pictureDetail = "";
 productName = "\U76ae\U76ae\U867e";
 productNo = 193609;
 productPrice = 1380;
 productWeight = "";
 restrictedTakeQuantity = 0;
 restrictionNum = 0;
 status = 0;
 stock = 0;
 stockCode = "";
 textDetail = "";
 updateTime = "";
 viceTitle = "\U76ae\U76ae\U867e";

 */
