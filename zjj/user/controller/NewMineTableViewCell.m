//
//  NewMineTableViewCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineTableViewCell.h"

@implementation NewMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.notifationCountLb.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
