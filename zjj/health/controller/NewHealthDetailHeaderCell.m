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
    self.nicknamelb.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:getImage(@"head_default")options:SDWebImageRetryFailed];
    self.nicknamelb.text = [SubUserItem shareInstance].nickname;
    self.value1lb.text = [NSString stringWithFormat:@"身高:%d  年龄:%d",item.height,item.age];
    self.value2lb.text = [NSString stringWithFormat:@"体型:%@  身体年龄:%d",[self getBodyStatusWithLevel:item.weightLevel],item.bodyAge];
    self.value2lb.adjustsFontSizeToFitWidth = YES;

}

-(NSString *)getBodyStatusWithLevel:(int)level
{
    switch (level) {
        case 1:
            return  [NSString stringWithFormat:@"偏瘦"];
            break;
        case 2:
            return  [NSString stringWithFormat:@"标准"];
            break;
        case 3:
            return   [NSString stringWithFormat:@"偏胖"];
            break;
        case 4:
            return  [NSString stringWithFormat:@"偏胖"];
            break;
        case 5:
            return   [NSString stringWithFormat:@"超重"];
            break;
        case 6:
            return   [NSString stringWithFormat:@"超重"];
            break;
        default:
            return @"";
            break;
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
