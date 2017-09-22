//
//  NewMineRelationsCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineRelationsCell.h"

@implementation NewMineRelationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickzt:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showzt)]) {
        [self.delegate showzt];
    }
}

- (IBAction)didClickGZ:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showGZ)]) {
        [self.delegate showGZ];
    }

}

- (IBAction)didClickFuns:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFuns)]) {
        [self.delegate showFuns];
    }

}
@end
