//
//  HDCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HDCell.h"

@implementation HDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius  = 5;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor=[UIColor redColor].CGColor;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
