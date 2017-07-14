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
#import "ChangeUserInfoViewController.h"
#import <UMMobClick/MobClick.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    LoignViewController *lo;
    NSTimer      * hudTimer;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"5938fc6fae1bf85185000571";
    [MobClick startWithConfigure:UMConfigInstance];

    //取消所有本地通知
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    
    
    
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([[UserModel shareInstance]isHaveUserInfo]==YES) {
        [[UserModel shareInstance]readToDoc];
        [[SubUserItem shareInstance]setInfoWithHealthId:[UserModel shareInstance].subId];
        if ([UserModel shareInstance].birthday.length>2) {
            TabbarViewController * tabbar = [[TabbarViewController alloc]init];
            [self.window setRootViewController:tabbar];
 
        }else{
            ChangeUserInfoViewController * cg =[[ChangeUserInfoViewController alloc]init];
            UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:cg];
            cg.changeType = 1;
            [self.window setRootViewController:nav];
        }
        
    }else{
    
    lo = [[LoignViewController alloc]initWithNibName:@"LoignViewController" bundle:nil];
//    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:lo];
    [self.window setRootViewController:lo];
    
    }
//    [[WXXShareManager shareInstance]buildShareSdk];
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

    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"警告" message:@"有人在其他设备登录您的脂将军账号，本设备将会强制退出。如果这不是您本人操作，请立刻通过登录页面找回密码功能修改密码，慎防盗号。" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        if (!lo) {
            lo = [[LoignViewController alloc]initWithNibName:@"LoignViewController" bundle:nil];
//            UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:lo];
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"zjj"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
