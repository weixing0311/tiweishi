//
//  AboutUsViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface AboutUsViewController : JFABaseTableViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *mobileBtn;
- (IBAction)didClickMobile:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *DebugView;
- (IBAction)SwitchChange:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoBtn;

@end
