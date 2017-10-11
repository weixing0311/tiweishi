//
//  GrowthHeader2View.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GrowthHeader2View.h"

@implementation GrowthHeader2View

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.headerImageView.layer.borderWidth= 2;
    self.headerImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    self.totalIntegerallb.adjustsFontSizeToFitWidth = YES;
    self.levellb.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)didQd:(id)sender {
    if ([self.qdBtn.titleLabel.text isEqualToString:@"已签到"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickQd)]) {
        [self.delegate didClickQd];
    }
}
- (IBAction)didClickRightBtn:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowInstructions)]) {
        [self.delegate didShowInstructions];
    }
}
@end
