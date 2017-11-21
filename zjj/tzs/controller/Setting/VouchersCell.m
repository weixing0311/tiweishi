//
//  VouchersCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersCell.h"

@implementation VouchersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.borderWidth= 2;
    self.headImageView.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickGetVouchers:(id)sender {
    if (self.getBtn.selected ==YES) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didClickGetVouchersWithCell:)]) {
        [self.delegate didClickGetVouchersWithCell:self];
    }
}
@end
