//
//  BaseWebViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : JFABaseTableViewController
@property (nonatomic,strong)WKWebView * webView;
@property (nonatomic, copy)NSString * urlStr;
@property (nonatomic, copy)NSString * orderNo;
@property (nonatomic, copy)NSString * payableAmount;
@property (nonatomic,assign)int payType;
@property (nonatomic,assign)int opt;




@end
