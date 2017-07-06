//
//  TZSChangeMobileViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface TZSChangeMobileViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *vertf;
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;
@property (weak, nonatomic) IBOutlet UITextField *oldMobileTf;
@property (weak, nonatomic) IBOutlet UIButton *verBtn;
- (IBAction)pushVer:(id)sender;
- (IBAction)didUpdate:(id)sender;

@end
