//
//  TZSHomePageCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/1/22.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSHomePageCell.h"

@implementation TZSHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(NSDictionary *)dict
{
    self.titlelb.text = [dict safeObjectForKey:@""];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@""]] placeholderImage:getImage(@"bigDefault")];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
