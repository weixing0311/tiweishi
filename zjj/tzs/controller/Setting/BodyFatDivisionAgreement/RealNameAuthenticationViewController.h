//
//  RealNameAuthenticationViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface RealNameAuthenticationViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sfzTf;

- (IBAction)didRz:(id)sender;
@end
