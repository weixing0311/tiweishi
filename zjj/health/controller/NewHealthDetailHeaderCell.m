//
//  NewHealthDetailHeaderCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailHeaderCell.h"

@implementation NewHealthDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:getImage(@"head_default")];
    self.nicknamelb.text = [SubUserItem shareInstance].nickname;
    self.value1lb.text = [NSString stringWithFormat:@"身高:%d  年龄:%d",item.height,item.age];
    self.value2lb.text = [NSString stringWithFormat:@"体型:%@  身体年龄:%d",@"偏胖型",item.bodyAge];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
