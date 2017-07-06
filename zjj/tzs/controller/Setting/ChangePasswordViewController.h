//
//  ChangePasswordViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface ChangePasswordViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;
@property (weak, nonatomic) IBOutlet UITextField *thenewPasswordtf;
@property (weak, nonatomic) IBOutlet UITextField *repasswordtf;
- (IBAction)updata:(id)sender;

@end
