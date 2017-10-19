//
//  GrowthStstemHeaderCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GrowthStstemHeaderCell.h"

@implementation GrowthStstemHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.headerImageView.layer.borderWidth= 2;
//    self.headerImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    self.totalIntegerallb.adjustsFontSizeToFitWidth = YES;
    self.levellb.adjustsFontSizeToFitWidth = YES;
}
- (IBAction)didQd:(id)sender {
    if ([self.qdBtn.titleLabel.text isEqualToString:@"已签到"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickQdWithCell:)]) {
        [self.delegate didClickQdWithCell:self];
    }
}
- (IBAction)didClickRightBtn:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowInstructions)]) {
        [self.delegate didShowInstructions];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
