//
//  MessageCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(NSDictionary * )dict
{
    self.timeLabel.text = [dict safeObjectForKey:@"releaseTime"];
    self.contentLabel.text = [dict safeObjectForKey:@"content"];
    self.titleLabel.text = [dict safeObjectForKey:@"operaterName"];
    [self.imageView setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"find_default2"]];;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
