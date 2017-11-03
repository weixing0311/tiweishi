//
//  AppDelegate.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarViewController.h"
#import "LoignViewController.h"
#import "WXXShareManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "ADDChengUserViewController.h"
#import <UMMobClick/MobClick.h>
#import "YMSocketUtils.h"

#import "HomePageWebViewController.h"
#import "TzsTabbarViewController.h"
#import "GuidePageViewController.h"

#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>

#endif



@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate
{
    LoignViewController *lo;
    NSTimer      * hudTimer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    if (@available(iOS 11.0, *)){
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
    
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"5938fc6fae1bf85185000571";
    [MobClick startWithConfigure:UMConfigInstance];

    [MobClick setAppVersion:[[UserModel shareInstance]getVersion]];
    //取消所有本地通知
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    //获取忽略版本号
    [UserModel shareInstance].ignoreVerSion = [[[NSUserDefaults standardUserDefaults]objectForKey:@"ignoreVerSion"]intValue];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"7cb890cf010077ca9b1c4648"
                          channel:@"Publish channel"
                 apsForProduction:FALSE
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kShowGuidePage]) {
        if ([[UserModel shareInstance]isHaveUserInfo]==YES) {
            [[UserModel shareInstance]readToDoc];
            if ([UserModel shareInstance].birthday.length>2) {
                TabbarViewController * tabbar = [[TabbarViewController alloc]init];
                [self.window setRootViewController:tabbar];
                
                if ([[UserModel shareInstance].userType isEqualToString:@"2"]) {
                    [[UserModel shareInstance]getNotiadvertising];
                }
            }else{
                ADDChengUserViewController * cg =[[ADDChengUserViewController alloc]init];
                cg.isResignUser = YES;
                [self.window setRootViewController:cg];
            }
        }else{
            
            lo = [[LoignViewController alloc]initWithNibName:@"LoignViewController" bundle:nil];
            [self.window setRootViewController:lo];
            
        }

    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kShowGuidePage];
        GuidePageViewController * guide = [[GuidePageViewController alloc]init];
        [self.window setRootViewController: guide];
    }
    
    
    
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
                                  [appInfo SSDKSetupQQByAppId:@"1106040974"
                                                       appKey:@"bRnLRej36spjLLsp"
                                                     authType:SSDKAuthTypeBoth];
                                  break;
                              default:
                                  break;
                          }
                      }];

    
    // Override point for customization after application launch.
    return YES;
}
-(void)loignOut
{
    [[UserModel shareInstance]removeAllObject];
    [[SubUserItem shareInstance]removeAll];
    [JPUSHService setAlias:@"" callbackSelector:nil object:self];

    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"警告" message:@"有人在其他设备登录您的脂将军账号，本设备将会强制退出。如果这不是您本人操作，请立刻通过登录页面找回密码功能修改密码，慎防盗号。" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        if (!lo) {
            lo = [[LoignViewController alloc]initWithNibName:@"LoignViewController" bundle:nil];
            [self.window setRootViewController:lo];

        }else{
            [self.window setRootViewController:lo];
        }
    }]];
    [self.window.rootViewController presentViewController:al animated:YES completion:nil];
}

-(void)showAletViewWithmessage:(NSString *)message
{
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:al animated:YES completion:nil];

}
-(void)showUpdateAlertViewWithMessage
{
    if ([UserModel shareInstance].isUpdate==YES) {

    UIAlertController * la =[UIAlertController alertControllerWithTitle:@"有新版本需要更新" message:[UserModel shareInstance].updateMessage preferredStyle:UIAlertControllerStyleAlert];
    [la addAction:[UIAlertAction actionWithTitle:@"跳转到AppStore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1209417912"]];

    }]];
    
    if ([UserModel shareInstance].isForce==0) {
        [la addAction:[UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserModel shareInstance].ignoreVerSion = [UserModel shareInstance].upDataVersion;
            [[NSUserDefaults standardUserDefaults]setObject:@([UserModel shareInstance].ignoreVerSion) forKey:@"ignoreVerSion"];
            
            [UserModel shareInstance].isUpdate =NO;
        }]];
    }
        
        [self.window.rootViewController presentViewController:la animated:YES completion:nil];
        
    }

}






- (void)applicationWillResignActive:(UIApplication *)application {
    [self showUpdateAlertViewWithMessage];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    DLog(@"deviceToken--%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//        [rootViewController addNotificationCount];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GETNOTIFICATIONINFOS" object:nil userInfo:userInfo];

    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
//        [rootViewController addNotificationCount];
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        
//        int type = [[userInfo safeObjectForKey:@"type"]intValue];
//        NSString * urlStr = [userInfo safeObjectForKey:@"url"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GETNOTIFICATIONINFOS" object:nil userInfo:userInfo];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
