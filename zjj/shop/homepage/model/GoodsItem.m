//
//  GoodsItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GoodsItem.h"

@implementation GoodsItem
-(void)setGoodsInfoWithDict:(NSDictionary *)dict
{
    self.imageUrl      = [dict safeObjectForKey:@"defPicture"];
    self.productName   = [dict safeObjectForKey:@"productName"];
    self.productNo     = [dict safeObjectForKey:@"productNo"];
    self.viceTitle     = [dict safeObjectForKey:@"viceTitle"];
    self.oldPrice      = [dict safeObjectForKey:@"oldPrice"];
    self.productPrice  = [dict safeObjectForKey:@"productPrice"];
    
}
@end
