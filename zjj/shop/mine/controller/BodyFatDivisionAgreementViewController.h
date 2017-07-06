//
//  BodyFatDivisionAgreementViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFABaseTableViewController.h"
@interface BodyFatDivisionAgreementViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)alredyRead:(id)sender;
- (IBAction)IAgree:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;

@end
