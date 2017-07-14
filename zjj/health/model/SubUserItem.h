//
//  SubUserItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubUserItem : NSObject
+(SubUserItem *)shareInstance;
@property (nonatomic , assign)int   age;
@property (nonatomic , copy)NSString * birthday;
@property (nonatomic , copy)NSString * nickname;
@property (nonatomic , copy)NSString * subId;
@property (nonatomic , assign)int    height;
@property (nonatomic , copy)NSString * headUrl;
@property (nonatomic , assign)int   sex;
-(void)setInfoWithHealthId:(NSString* )healthId;
-(void)setInfoWithMainUser;
-(void)removeAll;
@end
