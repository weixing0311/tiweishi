//
//  GuanzModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GuanzModel.h"

@implementation GuanzModel
-(void)setSearchInfoFromDict:(NSDictionary *)dict
{
    self.headImgUrl = [dict safeObjectForKey:@"headimgurl"];
    self.nickname = [dict safeObjectForKey:@"nickName"];
    self.isFollow = [[dict safeObjectForKey:@"isFollow"]boolValue];
    self.userId = [dict safeObjectForKey:@"userId"];
    self.introduction = [dict safeObjectForKey:@"introduction"];
}
-(void)setGzInfoWithDict:(NSDictionary *)dict
{
    self.headImgUrl = [dict safeObjectForKey:@"headimgurl"];
    self.nickname = [dict safeObjectForKey:@"nickName"];
    self.isFollow = [[dict safeObjectForKey:@"isFollow"]boolValue];
    self.userId = [dict safeObjectForKey:@"followId"];
    self.introduction = [dict safeObjectForKey:@"introduction"];

}
-(void)setGzsPersonInfoWithDict:(NSDictionary *)dict
{
    self.headImgUrl = [dict safeObjectForKey:@"headimgurl"];
    self.nickname = [dict safeObjectForKey:@"nickName"];
//    self.isFollow = [[dict safeObjectForKey:@"isFollow"]boolValue];
    self.userId = [dict safeObjectForKey:@"userId"];
//    self.introduction = [dict safeObjectForKey:@"introduction"];
    
}

@end
