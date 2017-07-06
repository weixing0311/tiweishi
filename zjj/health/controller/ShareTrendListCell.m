//
//  ShareTrendCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShareTrendListCell.h"

@implementation ShareTrendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.value1StatusBgView.layer.masksToBounds = YES;
    self.value1StatusBgView.layer.cornerRadius = 5;
    
    self.value2StatusBgView.layer.masksToBounds = YES;
    self.value2StatusBgView.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
