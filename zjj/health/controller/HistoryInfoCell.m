//
//  HistoryInfoCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryInfoCell.h"

@implementation HistoryInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.secondLb.layer.masksToBounds = YES;
    self.secondLb.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
