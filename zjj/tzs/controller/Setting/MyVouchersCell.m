//
//  MyVouchersCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MyVouchersCell.h"

@implementation MyVouchersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickUse:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didUserVoucherWithCell:)]) {
        [self.delegate didUserVoucherWithCell:self];
    }
}
@end
