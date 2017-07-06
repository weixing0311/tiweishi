//
//  SubUserItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "SubUserItem.h"
#import "TimeModel.h"
static SubUserItem * item;
@implementation SubUserItem
+(SubUserItem *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        item = [[SubUserItem alloc]init];
    });
    return item;
}
-(void)setInfoWithDic:(NSDictionary *)dict
{
    self.headUrl     = [dict safeObjectForKey:@"headimgurl"];
    self.nickname    = [dict safeObjectForKey:@"nickName"];
    self.height      = [dict safeObjectForKey:@"heigth"];
    self.birthday    = [dict safeObjectForKey:@"birthday"];
    self.sex         = [[dict safeObjectForKey:@"sex"]intValue];
    self.age = [[TimeModel shareInstance] ageWithDateOfBirth:[dict safeObjectForKey:@"birthday"]];
    self.subId       = [dict safeObjectForKey:@"subId"];
    
}

-(void)setInfoWithMainUser
{
    self.headUrl     = [UserModel shareInstance].headUrl;
    self.nickname    = [UserModel shareInstance].nickName;
    self.height      = [UserModel shareInstance].heigth;
    self.birthday    = [UserModel shareInstance].birthday;
    self.sex         = [UserModel shareInstance].gender;
    self.age         = [UserModel shareInstance].age;
    self.subId       = [UserModel shareInstance].healthId;
}


-(void)removeAll
{
    self.headUrl =nil;
    self.nickname = nil;
    self.height = nil;
    self.birthday = nil;
    self.sex = YES;
    self.age = 0;
    self.subId = nil;
}
-(void)setInfoWithHealthId:(NSString* )healthId
{
    if ([[UserModel shareInstance].healthId isEqualToString:healthId]) {
        [self setInfoWithMainUser];
        return;
    }
    
    for (NSDictionary *dic in [UserModel shareInstance].child) {
        NSString * heid = [dic safeObjectForKey:@"id"];
        if ([heid isEqualToString:healthId]) {
            [self setInfoWithDic:dic];
        }
    }
}
@end
