//
//  TZSDGUPCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDGUPCell.h"

@implementation TZSDGUPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImage.layer.borderWidth = 1;
    self.headImage.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didBuy:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didBuyWithCell:)]) {
        [self.delegate didBuyWithCell:self];
    }

}
@end
