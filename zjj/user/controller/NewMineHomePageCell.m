//
//  NewMineHomePageCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineHomePageCell.h"

@implementation NewMineHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBGiamgeViewImage)];
    tap.delegate= self;
    [self.bgImageView addGestureRecognizer:tap];
    // Initialization code
}
-(void)changeBGiamgeViewImage
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeBgImageView)]) {
        [self.delegate changeBgImageView];
    }
}

- (IBAction)editUserInfo:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowChangeUserInfoPage)]) {
        [self.delegate didShowChangeUserInfoPage];
    }
}
- (IBAction)editHeaderImage:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didChangeHeaderImage)]) {
        [self.delegate didChangeHeaderImage];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickGz:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didGzUserWithCell:)]) {
        [self.delegate didGzUserWithCell:self];
    }

    
}
@end
