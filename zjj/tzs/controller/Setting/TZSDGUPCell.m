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
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    
    
    self.cxImageLabel.layer.masksToBounds = YES;
    self.cxImageLabel.layer.cornerRadius  = 5;
    self.cxImageLabel.layer.borderWidth = 1;
    self.cxImageLabel.layer.borderColor=[UIColor redColor].CGColor;

    
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

- (IBAction)didShowCuXDetailView:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showCXDetailWithDGCell:)]) {
        [self.delegate showCXDetailWithDGCell:self];
    }
}

@end
