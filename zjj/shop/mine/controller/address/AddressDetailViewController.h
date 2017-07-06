//
//  AddressDetailViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface AddressDetailViewController : JFABaseTableViewController<UIPickerViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTx;
- (IBAction)didChooseCity:(id)sender;
- (IBAction)saveAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *cityTf;

@property (nonatomic,strong)NSDictionary * defaultDict;
@property (nonatomic,assign)BOOL isEdit;
@property (weak, nonatomic) IBOutlet UILabel *tisLabel;

@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;

@end
