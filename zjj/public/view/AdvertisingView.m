//
//  AdvertisingView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AdvertisingView.h"
#import "UIImageView+WebCache.h"
@implementation AdvertisingView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = RGBACOLOR(255/225.0f, 255/225.0f, 255/225.0f, .3);

    
    
}
- (IBAction)didCloseView:(id)sender {
    [self removeFromSuperview];
}
-(void)setImageWithUrl:(NSString * )imageUrl
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
