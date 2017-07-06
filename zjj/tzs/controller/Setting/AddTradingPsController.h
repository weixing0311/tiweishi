//
//  AddTradingPsController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/5.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface AddTradingPsController : JFABaseTableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *fsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *forImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@end
