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
    self.firstlb.text = [NSString stringWithFormat:@"%d",[HealthDetailsItem instance].normal+[HealthDetailsItem instance].serious+[HealthDetailsItem instance].warn];
    self.secondlb.text = [NSString stringWithFormat:@"%d",[HealthDetailsItem instance].serious];
    self.thirdlb.text  =[NSString stringWithFormat:@"%d",[HealthDetailsItem instance].serious];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
