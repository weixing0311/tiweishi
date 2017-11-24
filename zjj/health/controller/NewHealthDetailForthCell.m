//
//  NewHealthDetailForthCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailForthCell.h"

@implementation NewHealthDetailForthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    self.firstlb.text = [self getBestWeightWithItem:item];
}
-(NSString *)getBestWeightWithItem:(HealthDetailsItem*)item
{
    if (item.standardWeight-item.weight>5) {
        return [NSString stringWithFormat:@"根据您的身体状况判断，您的体重为%.2fkg,比最佳体重还要轻了%.2fkg的距离,继续努力奥！",item.standardWeight,fabsf(item.standardWeight-item.weight)];
    }
    else if (item.weight-item.standardWeight>5)
    {
        return [NSString stringWithFormat:@"根据您的身体状况判断，您的体重为%.2fkg,距离最佳体重还差%.2fkg的距离,继续努力奥！",item.standardWeight,fabsf(item.standardWeight-item.weight)];
    }
    else{
        return @"您已是最佳体重，继续保持奥，不要懈怠，可以适当的犒劳一些自己吧！";
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
