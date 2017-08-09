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
    [self.BigImageView setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"find_default2"]];;

    self.timeLabel.text = [dict safeObjectForKey:@"releaseTime"];
    self.timeLabel.frame = CGRectMake((JFA_SCREEN_WIDTH-[self getWidthWithString:self.timeLabel.text]-20)/2, 8, [self getWidthWithString:self.timeLabel.text]+20, 20) ;
    
    
    self.contentLabel.text = [dict safeObjectForKey:@"content"];
    self.contentLabel.hidden =NO;
    self.titleLabel.text = [dict safeObjectForKey:@"operaterName"];
}
-(float)getWidthWithString:(NSString *)str
{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    
    UIFont *font = [UIFont systemFontOfSize:13];
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};
    CGSize size = [self.timeLabel.text boundingRectWithSize:CGSizeMake(JFA_SCREEN_WIDTH-52, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.width;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
