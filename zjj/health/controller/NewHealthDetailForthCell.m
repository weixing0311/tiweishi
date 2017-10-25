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
    self.firstlb.text = [NSString stringWithFormat:@"%d",item.normal+item.serious+item.warn];
    self.secondlb.text = [NSString stringWithFormat:@"%d",item.serious];
    self.thirdlb.text  =[NSString stringWithFormat:@"%d",item.serious];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
