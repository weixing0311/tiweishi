//
//  PerfectInformationViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2018/1/15.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface PerfectInformationViewController : JFABaseTableViewController
@property (strong, nonatomic)  UITextField *mobiletf;
@property (strong, nonatomic)  UITextField *passwordtf;
@property (strong, nonatomic)  UITextField *rePasswordtf;

@property (strong, nonatomic)  UITextField *secondPasswordtf;
@property (strong, nonatomic)  UITextField *reSecondPasswordtf;

@property (strong, nonatomic)  UIButton *sendBtn;
- (IBAction)updata:(id)sender;
@property (strong, nonatomic)  UIButton *qrBtn;

@end
