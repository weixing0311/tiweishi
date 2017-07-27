//
//  BaseWebViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface BaseWebViewController : JFABaseTableViewController
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, copy)NSString * urlStr;
@property (nonatomic, copy)NSString * orderNo;
@property (nonatomic, copy)NSString * payableAmount;
@property (nonatomic,assign)int payType;


-(void) getHeader;
-(void)exit;
-(void)hideLoad;
-(void)exitToLogin;
void alert(NSString * message);
void loading(NSString * message);


@end
