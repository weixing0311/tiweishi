//
//  ChangeUserInfoViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface ChangeUserInfoViewController : JFABaseTableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickNameLb;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UIImageView *manChooseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *womanChooseImageView;
@property (nonatomic,assign)int  changeType;//进入type
@property (nonatomic ,strong) UIImage * headImage;
@property (nonatomic ,copy)  NSString * sexStr;
@property (nonatomic ,copy)  NSString * nickNameStr;
- (IBAction)chooseSex:(UIButton*)sender;
- (IBAction)next:(id)sender;
- (IBAction)changeHeader:(id)sender;
@end
