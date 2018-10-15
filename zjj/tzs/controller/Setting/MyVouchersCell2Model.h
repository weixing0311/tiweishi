//
//  MyVouchersCell2Model.h
//  zjj
//
//  Created by iOSdeveloper on 2018/8/1.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyVouchersCell2Model : NSObject
@property (nonatomic,copy)NSString * templateName;
@property (nonatomic,copy)NSString * startAmount;
@property (nonatomic,copy)NSString * timeStr;
@property (nonatomic,copy)NSString * context;
@property (nonatomic,copy)NSString * idStr;
@property (nonatomic,copy)NSString * couponNo;
@property (nonatomic,copy)NSString * grantType;
@property (nonatomic,copy)NSString * discountAmount;
@property (nonatomic,copy)NSString * validEndTime;
@property (nonatomic,copy)NSString * depositStatus;
@property (nonatomic,copy)NSString * templateId;
@property (nonatomic,copy)NSString * grantNum;
@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * receiveEndTime;
@property (nonatomic,copy)NSString * validStartTime;
@property (nonatomic,copy)NSString * grantName;
@property (nonatomic,copy)NSString * grantObject;
@property (nonatomic,copy)NSString * isValid;
@property (nonatomic,copy)NSString * receiveStartTime;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString * showContent;
@property (nonatomic,strong)NSArray * products;


-(void)setInfoWithDict:(NSDictionary *)dict;
@end
