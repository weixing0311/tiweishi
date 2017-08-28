//
//  AddressListCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddressListCell.h"

@implementation AddressListCell
{
    
    __weak IBOutlet UIButton *deleteBtn;
    __weak IBOutlet UIButton *edtiBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    edtiBtn.layer.masksToBounds = YES;
    edtiBtn.layer.cornerRadius  = 5;
    edtiBtn.layer.borderWidth = 1;
    edtiBtn.layer.borderColor=HEXCOLOR(0x999999).CGColor;
    
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.cornerRadius  = 5;
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.borderColor=HEXCOLOR(0x999999).CGColor;
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
