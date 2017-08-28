//
//  HelpViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface HelpViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy)NSString * urlStr;
@end
