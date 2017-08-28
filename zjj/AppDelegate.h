//
//  AppDelegate.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



-(void)loignOut;
-(void)showAletViewWithmessage:(NSString *)message;
-(void)showUpdateAlertViewWithMessage;
@end

