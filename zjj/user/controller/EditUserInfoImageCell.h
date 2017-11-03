//
//  EditUserInfoImageCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditUserInfoCellDelegate;
@interface EditUserInfoImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *fatBeforeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fatAfterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fatBeforeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fatAfterImageView;
@property (nonatomic,assign)id<EditUserInfoCellDelegate>delegate;

@end

@protocol EditUserInfoCellDelegate <NSObject>
-(void)changeBeforeImage;
-(void)changeAfterImage;
@end
