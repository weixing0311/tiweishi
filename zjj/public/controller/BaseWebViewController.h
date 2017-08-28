//
//  BaseWebViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/8/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import <WebKit/WebKit.h>

typedef enum
{
    IS_HAVE_DG,//已购服务
    IS_TEAM_MANAGEMENT,//团队管理
}webUrlType;
@interface BaseWebViewController : JFABaseTableViewController
@property (nonatomic,strong)WKWebView * webView;
@property (nonatomic, copy)NSString * urlStr;
@property (nonatomic, copy)NSString * orderNo;
@property (nonatomic, copy)NSString * payableAmount;
@property (nonatomic,assign)int payType;
@property (nonatomic,assign)int opt;
@property (nonatomic,copy)NSString * rightBtnTitle;
@property (nonatomic,copy)NSString * rightBtnUrl;
@property (nonatomic,strong)UIProgressView * progressView;

@end
