//
//  LoignViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface LoignViewController : JFABaseTableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;

@property (weak, nonatomic) IBOutlet UITextField *verTF;
@property (weak, nonatomic) IBOutlet UIButton *verbtn;
@property (weak, nonatomic) IBOutlet UIButton *resignAugement;
@property (weak, nonatomic) IBOutlet UIButton *loignBtn;
@property (weak, nonatomic) IBOutlet UITextField *loignMobileTf;
@property (weak, nonatomic) IBOutlet UITextField *passWordTf;

@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet UIView *verView;

@property (weak, nonatomic) IBOutlet UIButton *verLoignBtn;
@property (weak, nonatomic) IBOutlet UIButton *psLoignBtn;
- (IBAction)pageChange:(UIButton *)sender;


- (IBAction)didLoign:(id)sender;

- (IBAction)forgetPass:(id)sender;

- (IBAction)getVer:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *forgetpsBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *bgview;





@end
