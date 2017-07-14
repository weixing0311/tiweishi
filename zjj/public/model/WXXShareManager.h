//
//  WXXShareManager.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXXShareManager : NSObject
+(WXXShareManager *)shareInstance;
-(void)buildShareSdk;
@end
