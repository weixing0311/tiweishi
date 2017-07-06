//
//  ForgetJYpasswordViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface ForgetJYpasswordViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *cardTf;
@property (weak, nonatomic) IBOutlet UITextField *mobiletf;
@property (weak, nonatomic) IBOutlet UITextField *vertf;
@property (weak, nonatomic) IBOutlet UIButton *verBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;
@property (weak, nonatomic) IBOutlet UITextField *repasswordtf;
@property (weak, nonatomic) IBOutlet UIButton *pushVer;
- (IBAction)updata:(id)sender;
- (IBAction)getVer:(id)sender;

@end
