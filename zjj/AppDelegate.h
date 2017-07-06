//
//  AppDelegate.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
typedef enum : NSUInteger {
    hotwheels,// 只有一个风火轮,加文字
    progress,// 初始化通讯录时有进度条
    onlyMsg,// 只有文字
} HUDType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
-(void)loignOut;
-(void)showHUD:(HUDType)type message:(NSString*)message detai:(NSString*)detailMsg Hdden:(BOOL)hidden;
-(void)hiddenHUD;
-(void)showHUDtishiWithText:(NSString *)text;
-(void)showAletViewWithmessage:(NSString *)message;
@end

