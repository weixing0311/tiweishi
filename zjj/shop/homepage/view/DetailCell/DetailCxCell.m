//
//  DetailCxCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "DetailCxCell.h"

@implementation DetailCxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cxImgLabel.layer.masksToBounds = YES;
    self.cxImgLabel.layer.cornerRadius  = 5;
    self.cxImgLabel.layer.borderWidth = 1;
    self.cxImgLabel.layer.borderColor=[UIColor redColor].CGColor;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
