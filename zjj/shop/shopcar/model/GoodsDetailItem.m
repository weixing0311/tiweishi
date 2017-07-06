//
//  GoodsDetailItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GoodsDetailItem.h"
static GoodsDetailItem * item;
@implementation GoodsDetailItem

+(GoodsDetailItem *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        item = [[GoodsDetailItem alloc]init];
    });
    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!self.pictureArray) {
            self.pictureArray = [NSMutableArray array];
        }
    }
    return self;
}
-(void)setupInfoWithDict:(NSDictionary *)dict
{
    self.productNo =              [dict safeObjectForKey:@"productNo"];
    self.productName =            [dict safeObjectForKey:@"productName"];
    self.viceTitle =              [dict safeObjectForKey:@"viceTitle"];
    self.oldPrice =               [dict safeObjectForKey:@"oldPrice"];
    self.productPrice =           [dict safeObjectForKey:@"productPrice"];
    self.productWeight =          [dict safeObjectForKey:@"productWeight"];
    self.image =                  [dict safeObjectForKey:@"defPicture"];
    self.fatTeacherproductPrice = [dict safeObjectForKey:@"fatTeacherproductPrice"];
    self.promotList =             [dict safeObjectForKey:@"promotList"];
    self.freightTemplateId =      [dict safeObjectForKey:@"freightTemplateId"];
    self.isDelivery            =  [[dict safeObjectForKey:@"isDelivery"]intValue];
    self.isDistribution        =  [[dict safeObjectForKey:@"isDistribution"]intValue];
    
    
    NSString * picture2 =         [dict safeObjectForKey:@"picture2"];
    NSString * picture3 =         [dict safeObjectForKey:@"picture3"];
    NSString * picture4 =         [dict safeObjectForKey:@"picture4"];
    NSString * picture5 =         [dict safeObjectForKey:@"picture5"];
    [self setValueInArray:self.image];
    [self setValueInArray:picture2];
    [self setValueInArray:picture3];
    [self setValueInArray:picture4];
    [self setValueInArray:picture5];
}
-(void)setValueInArray:(NSString *)picture
{
    if (picture.length>5) {
        [self.pictureArray addObject:picture];
    }
}

@end
