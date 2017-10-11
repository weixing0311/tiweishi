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
}
-(void)setGzInfoWithDict:(NSDictionary *)dict
{
    self.headImgUrl = [dict safeObjectForKey:@"headimgurl"];
    self.nickname = [dict safeObjectForKey:@"nickName"];
    self.isFollow = [[dict safeObjectForKey:@"isFollow"]boolValue];
    self.userId = [dict safeObjectForKey:@"followId"];

}
@end
