//
//  AddressListCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddressListCell.h"

@implementation AddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didDelete:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickDeleteWithCell:)]) {
        [self.delegate didClickDeleteWithCell:self];
    }
}

- (IBAction)didEdit:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickEditWithCell:)]) {
        [self.delegate didClickEditWithCell:self];
    }

    
}
- (IBAction)isDefault:(id)sender
{
    
    if (self.defaultBtn.selected ==YES){}
    else
    {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickChangeDefaultWithCell:)]) {
            [self.delegate didClickChangeDefaultWithCell:self];
        }
 
    }
    
    
    
}
@end
