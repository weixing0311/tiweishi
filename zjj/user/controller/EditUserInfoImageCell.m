//
//  EditUserInfoImageCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "EditUserInfoImageCell.h"

@implementation EditUserInfoImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fatBeforeImageView.contentMode =UIViewContentModeScaleAspectFill;
    self.fatBeforeImageView.clipsToBounds = YES;
    self.fatAfterImageView.contentMode =UIViewContentModeScaleAspectFill;
    self.fatAfterImageView.clipsToBounds = YES;
    // Initialization code
}
- (IBAction)addFatBeforeImage:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeBeforeImage)]) {
        [self.delegate changeBeforeImage];
    }
}
- (IBAction)addFatAfterImage:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeAfterImage)]) {
        [self.delegate changeAfterImage];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
