//
//  ChangeUserInfo2ViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface ChangeUserInfo2ViewController : JFABaseTableViewController<UIScrollViewDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *pickView;
- (IBAction)didFinish:(id)sender;
@property (nonatomic ,assign) BOOL isFirstAddInfo;

@property (nonatomic,assign)int changeType;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *ruleImageView;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UITextField *birTf;
@property (nonatomic ,copy) NSString * nickName;
@property (nonatomic ,assign) int   sex;
@property (nonatomic ,copy) NSData * imageData;
@end
