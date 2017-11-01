//
//  NewHealthDetailSecondCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailSecondCell.h"

@implementation NewHealthDetailSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    self.fatLevellb.text = [NSString stringWithFormat:@"%.1fkg",item.weight];
    self.contentlb.text = [NSString stringWithFormat:@"在社区中排名第%d位，已超过社区%.0f%%的用户",item.ranking,item.percent];
    self.scorelb.text = [NSString stringWithFormat:@"%.1f",item.myScore];
    self.scorelb.adjustsFontSizeToFitWidth = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
