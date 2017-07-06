//
//  ImageViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/26.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface ImageViewController : JFABaseTableViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)ChangeHeadImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
