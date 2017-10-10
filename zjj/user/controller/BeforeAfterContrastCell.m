//
//  BeforeAfterContrastCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BeforeAfterContrastCell.h"

@implementation BeforeAfterContrastCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.continuousDatelb.adjustsFontSizeToFitWidth = YES;
    self.lossWeightlb.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
