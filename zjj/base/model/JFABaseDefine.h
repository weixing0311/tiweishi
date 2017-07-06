//
//  JFABaseDefine.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#ifndef JFABaseKit_JFABaseDefine_h
#define JFABaseKit_JFABaseDefine_h


#ifdef DEBUG
#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#endif

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define JFA_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define JFA_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define SEGMENTED_BAR_HEIGHT 53

#define AI_MAIN_BLUECOLOR [UIColor colorWithRed:0x3d / 255.0f green:0xb9 / 255.0f blue:0xec / 255.0f alpha:1]
#define AI_MAIN_DARK_BLUECOLOR [UIColor colorWithRed:0x00 / 255.0f green:0x66 / 255.0f blue:0x99 / 255.0f alpha:1]



#define JFAGetHotList @"mclient/getHotList" //获取热门列表信息




/*****************   comeFrom Cmmonendif    *************************/



typedef enum
{
    Content_Downloading,
    Content_Downloaded,
    
}AppManagerViewController_Content;

typedef enum
{
    UITypeHot = 1,
    UITypeAppleRank = 2,
    UITypeTopic = 3,
    UITypeHomeBanner = 4,
} UIListType;

#define SearchHotKey @"AISearchHotKey"
#define SearchHistoryKey @"AISearchHistoryKey"
#define ClearImageCacheDone @"AIClearImageCacheDone"
#define InstallingAppNotification @"kInstallingAppNotification"
#define InstalledAppNotification @"kInstalledAppNotification"
#define UpgradeAppNotification @"kUpgradeAppNotification"
#define RepairAppNotification @"kRepairAppNotification"
#define ShowSearchUINotification @"kShowSearchUINotification"
#define HideSearchUINotification @"kHideSearchUINotification"


#define IIHOST @"http://www.fassionsoft.com"
#define Port(api) [NSString stringWithFormat:@"%@/%@", IIHOST, api)


#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)

#define IOS8_OR_LATER NLSystemVersionGreaterOrEqualThan(8.0)

#define IOS81_OR_LATER NLSystemVersionGreaterOrEqualThan(8.1)
#define IOS9_OR_LATER NLSystemVersionGreaterOrEqualThan(9.0)
#define NLSystemVersionLowerOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] < version)
#define IOS6_EARLY NLSystemVersionLowerOrEqualThan(6.0)


#define II_SCREEN_WIDTH_IOS7_EARLY ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define II_SCREEN_HEIGHT_IOS7_EARLY ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define II_SCREEN_WIDTH  1024.0
#define II_SCREEN_HEIGHT 768.0


#define AI_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define AI_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


/*******************陈磊add*******************/

#define AI_STORE_TEXT_MAINCOLOR     [UIColor colorWithRed:0x46 / 255.0f green:0x46 / 255.0f blue:0x46 / 255.0f alpha:1]
#define AI_STORE_TEXT_DETAILCOLOR   [UIColor colorWithRed:0x99 / 255.0f green:0x99 / 255.0f blue:0x99 / 255.0f alpha:1]
#define AI_STORE_TEXT_STATECOLOR   [UIColor colorWithRed:0x66 / 255.0f green:0x66 / 255.0f blue:0x66 / 255.0f alpha:1]

#define II_GRAY_UNDERLINECOLOR [UIColor colorWithRed:0xe2 / 255.0f green:0xe2 / 255.0f blue:0xe2 / 255.0f alpha:1]
#define II_BLUE_UNDERLINECOLOR [UIColor colorWithRed:21 / 255.0f green:134 / 255.0f blue:245 / 255.0f alpha:1]
#define II_MAIN_BLUECOLOR [UIColor colorWithRed:21 / 255.0f green:133 / 255.0f blue:241 / 255.0f alpha:1]
#define AI_MAIN_BLUECOLOR [UIColor colorWithRed:0x3d / 255.0f green:0xb9 / 255.0f blue:0xec / 255.0f alpha:1]
#define AI_MAIN_YELLOWCOLOR [UIColor colorForHex:@"#ff6320"]
#define AI_MAIN_DARK_BLUECOLOR [UIColor colorWithRed:0x00 / 255.0f green:0x66 / 255.0f blue:0x99 / 255.0f alpha:1]
#define II_ORANGE_BORDERCOLOR [UIColor colorWithRed:0xf6 / 255.0f green:0x81 / 255.0f blue:0x0f / 255.0f alpha:1]
#define AI_GREEN_FAIL [UIColor colorForHex:@"#4bd262"]
#define AI_BLUE_DOWNLOAD [UIColor colorForHex:@"#007aff"]

#define II_GREEN_BORDERCOLOR [UIColor colorWithRed:85 / 255.0f green:188 / 255.0f blue:105 / 255.0f alpha:1]
#define II_GRAY_BORDERCOLOR [UIColor colorWithRed:0xa7 / 255.0f green:0xa7 / 255.0f blue:0xa7 / 255.0f alpha:1]

#define II_CELL_UNDERLINE_COLOR [UIColor colorWithRed:0xd2 / 255.0f green:0xd6 / 255.0f blue:0xd9 / 255.0f alpha:1]


#define II_MAIN_TEXTCOLOR [UIColor colorWithRed:0x2d / 255.0f green:0x2f / 255.0f blue:0x2e / 255.0f alpha:1]

#define II_SECOND_TEXTCOLOR  [UIColor colorWithRed:0x4c / 255.0f green:0x4c / 255.0f blue:0x4a / 255.0f alpha:1]

#define II_THIRD_TEXTCOLOR  [UIColor colorWithRed:0x85 / 255.0f green:0x86 / 255.0f blue:0x88 / 255.0f alpha:1]

#define II_TITLE_TEXTCOLOR  [UIColor colorWithRed:0x3f / 255.0f green:0x3f / 255.0f blue:0x3f / 255.0f alpha:1]

#define II_CONTENT_TEXTCOLOR  [UIColor colorWithRed:0x53 / 255.0f green:0x53 / 255.0f blue:053 / 255.0f alpha:1]


#define IISlideTabBarWidth 185
#define IIICONSIZE (CGSize){IISlideTabBarWidth, 53}

// 李冲
#define CELL_WIDTH (II_SCREEN_WIDTH - IISlideTabBarWidth - 35 * 2)
#define CELL_HEIGHT 95

#define CELL_ITEM_WIDTH (CELL_WIDTH / 2.0)
#define CELL_ITEM_HEIGHT CELL_HEIGHT
#define CELL_ITEM_TEXT_PADDING 20
#define CELL_ITEM_PADDING 0
#define CELL_ITEM_ICON_WIDTH 65
#define CELL_ITEM_ICON_HEIGHT 65
#define CELL_ITEM_BUTTON_WIDTH 70
#define CELL_ITEM_BUTTON_HEIGHT 30

#define RECOMMEND_CELL_ITEM_COUNT 2

#define RECOMMEND_HEADER_PADDING 0
#define RECOMMEND_HEADER_HEIGHT 224
#define RECOMMEND_HEADER_PAGECONTROL_DOT_WIDTH  20
#define RECOMMEND_HEADER_PAGECONTROL_HEIGHT 20

#define SEGMENTED_BAR_HEIGHT 53
#define SEGMENTED_BUTTON_WIDTH 85
#define SEGMENTED_BUTTON_HEIGHT 36

#define NAVIGATION_BAR_HEIGHT 44

#define APP_DETAIL_PADDING 37
#define PAD_APP_IMAGE_PADDING 40
#define PAD_APP_IMAGE_SPACE 39
#define APP_DETAIL_TEXT_PADDING  25
#define APP_DETAIL_PADDING2 10
#define APP_DETAIL_ICON_WIDTH 92
#define APP_DETAIL_ICON_HEIGHT 92
#define APP_DETAIL_NAVIGATION_BAR_HEIGHT 90
#define APP_DETAIL_NAVIGATION_BAR_BUTTON1_WIDTH 205
#define APP_DETAIL_NAVIGATION_BAR_BUTTON1_HEIGHT 55
#define APP_DETAIL_NAVIGATION_BAR_BUTTON2_WIDTH 80
#define APP_DETAIL_NAVIGATION_BAR_BUTTON2_HEIGHT 36

#define STAR_SCORE_ONE_STAR_WIDTH 20
#define STAR_SCORE_ONE_STAR_HEIGHT 20
#define STAR_SCORE_ONE_STAR_MARGIN 5

#define MORE_CELL_WIDTH (II_SCREEN_WIDTH - IISlideTabBarWidth)
#define MORE_CELL_HEIGHT 65
#define MORE_CELL_PADDING 40
#define MORE_CELL_SWITCHER_WIDTH 100
#define MORE_CELL_SWITCHER_HEIGHT 40

#define TEXT_HEIGHT 20


#define APPRecoverSettingTitle NSLocalizedString(@"应用(闪退)修复", @"")
#define APPPolicySettingTitle NSLocalizedString(@"使用许可协议", @"")


//upgrade info key
#define KeyDownloadUrl @"download_url"
#define KeyForceUpgrade @"is_force"
#define KeyIntro @"intro"
#define KeyUpgradeInterval @"upgrade_interval"


/*******/
#define QVLogMethodCallStartInfo()            DDLogInfo(@"%d:start", (self))
#define QVLogMethodCallEndInfo()              DDLogInfo(@"%d:end", (self))
#define QVLogMethodCallStartCInfo()           DDLogCInfo(@"start")
#define QVLogMethodCallEndCInfo()             DDLogCInfo(@"end")

#define QVLogMethodCallStartVerbose()         DDLogVerbose(@"%d:start", (self))
#define QVLogMethodCallEndVerbose()           DDLogVerbose(@"%d:end", (self))
#define QVLogMethodCallStartCVerbose()        DDLogCVerbose(@"start")
#define QVLogMethodCallEndCVerbose()          DDLogCVerbose(@"end")

// 按钮等控件的背景色
#define APP_COLOR_1 @"#005DA4"

#define APP_COLOR_2 @"#BEBEBE"

// 搜索框，页面等的背景色
#define APP_COLOR_3 @"#F5F5F5"

// 搜索页面的table cell中text label的颜色
#define APP_COLOR_4 @"#626262"

// 按钮字体的颜色
#define APP_COLOR_5 @"#38505F"

// pageControl 点的颜色
#define APP_COLOR_6 @"#32b9ff"

// Setting 和 Search View 的背景色
#define APP_COLOR_7 @"d5d5d5"

// Multi-Switcher中选中按钮的字体颜色
#define APP_COLOR_8 @"dae7f1"

// 按钮等控件的背景色
#define APP_COLOR_1 @"#005DA4"

#define APP_COLOR_2 @"#BEBEBE"

// 搜索框，页面等的背景色
#define APP_COLOR_3 @"#F5F5F5"

// 搜索页面的table cell中text label的颜色
#define APP_COLOR_4 @"#626262"

// 按钮字体的颜色
#define APP_COLOR_5 @"#38505F"

// pageControl 点的颜色
#define APP_COLOR_6 @"#32b9ff"

// Setting 和 Search View 的背景色
#define APP_COLOR_7 @"d5d5d5"

// Multi-Switcher中选中按钮的字体颜色
#define APP_COLOR_8 @"dae7f1"

// 应用详情占位图背景色
#define APP_COLOR_9 @"#F6F6F6"

#define QVAssertMainThread()                  NSAssert([NSThread isMainThread], @"this method should be called from the main thread");
#define QVCAssertMainThread()                 NSCAssert([NSThread isMainThread], @"this method should be called from the main thread");



#endif
