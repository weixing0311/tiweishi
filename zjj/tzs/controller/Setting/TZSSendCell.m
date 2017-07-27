//
//  TZSSendCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSSendCell.h"

@implementation TZSSendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headimageView.layer.borderWidth = 1;
    self.headimageView.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didAdd:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didAddWithCell:)]) {
        [self.delegate didAddWithCell:self];
    }
}

- (IBAction)didRed:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didRedWithCell:)]) {
        [self.delegate didRedWithCell:self];
    }

}
@end
