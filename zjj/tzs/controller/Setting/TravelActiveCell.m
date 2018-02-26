//
//  TravelActiveCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/1/18.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TravelActiveCell.h"

@implementation TravelActiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(NSDictionary *)dict
{
    self.titlelb.text = [dict safeObjectForKey:@""];
    self.timelb.text = [NSString stringWithFormat:@"%@至%@",[dict safeObjectForKey:@""],[dict safeObjectForKey:@""]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@""]] placeholderImage:getImage(@"bigDefalut_")];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
