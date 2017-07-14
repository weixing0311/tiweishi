//
//  WXXShareManager.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WXXShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


#define shareSDKAppKey    @"1ac56d95e4e80"
#define shareSDKAppSecret    @"aa115824ae8968c9455c95a394642384"

#define sinaWeiboAppKey    @"3329439896"
#define sinaWeiboAppSecret    @"fc4d61248d9fb33c35a9e5afb4cc2b5c"
#define sinaWeiboAppRedirectURI    @"https://api.weibo.com/oauth2/default.html"

#define weChatAppId    @"wxea8fcaf6d87a2715"
#define weChatAppSecret    @"504c2084e7c1636499478fc8e079acf1"

#define QQAppId    @"1106040974"
#define QQAppkey    @"bRnLRej36spjLLsp"

@interface WXXShareManager()
@end

static WXXShareManager * manager;
@implementation WXXShareManager

//5938fc6fae1bf85185000571
+(WXXShareManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WXXShareManager alloc]init];
    });
    return manager;
}
-(void)buildShareSdk
{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [ShareSDKConnector connectQQ:[QQApiInterface class]
                                                    tencentOAuthClass:[TencentOAuth class]];
                                         break;
                                     default:
                                         break;
                                 }
                             }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                          
                          switch (platformType)
                          {
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:@"wxea8fcaf6d87a2715"
                                                        appSecret:@"504c2084e7c1636499478fc8e079acf1"];
                                  break;
                              case SSDKPlatformTypeQQ:
                                  [appInfo SSDKSetupQQByAppId:QQAppkey
                                                       appKey:QQAppkey
                                                     authType:SSDKAuthTypeBoth];
                                  break;
                              default:
                                  break;
                          }
                      }];
}
@end



