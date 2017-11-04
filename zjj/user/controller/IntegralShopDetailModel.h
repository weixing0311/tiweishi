//
//  IntegralShopDetailModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralShopDetailModel : NSObject
@property (nonatomic,copy) NSString * productWeight;
@property (nonatomic,copy) NSString * note;
@property (nonatomic,copy) NSString * viceTitle;
@property (nonatomic,copy) NSString * picture;
@property (nonatomic,copy) NSString * oldPrice;
@property (nonatomic,copy) NSString * oldIntegral;
@property (nonatomic,copy) NSString * productNo;
@property (nonatomic,copy) NSString * productInformation;
@property (nonatomic,copy) NSString * isWarehouseSend;
@property (nonatomic,copy) NSString * colour;
@property (nonatomic,copy) NSString * restrictionNum;
@property (nonatomic,copy) NSString * productName;
@property (nonatomic,copy) NSString * productPrice;
@property (nonatomic,copy) NSString * grade;
@property (nonatomic,copy) NSString * productIntegral;
@property (nonatomic,copy) NSString * classId;
@property (nonatomic,copy) NSString * stockCode;
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
