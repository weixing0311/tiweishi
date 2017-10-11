//
//  GuanzModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuanzModel : NSObject
@property (nonatomic,copy)NSString * headImgUrl;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,assign)BOOL     isFollow;
@property (nonatomic,copy)NSString * userId;
-(void)setSearchInfoFromDict:(NSDictionary *)dict;
-(void)setGzInfoWithDict:(NSDictionary *)dict;
@end
