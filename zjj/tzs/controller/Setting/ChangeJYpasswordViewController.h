//
//  ChangeJYpasswordViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface ChangeJYpasswordViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *mobiletf;
@property (weak, nonatomic) IBOutlet UITextField *verTf;
@property (weak, nonatomic) IBOutlet UIButton *verBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldpassword;
@property (weak, nonatomic) IBOutlet UITextField *theNewpasswordtf;
@property (weak, nonatomic) IBOutlet UITextField *renewpassword;
- (IBAction)pudata:(id)sender;
- (IBAction)pushVer:(id)sender;

@end
