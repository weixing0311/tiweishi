//
//  UserCellCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserCellCell.h"

@implementation UserCellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickDelete:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteSubUserWithCell:)]) {
        [self.delegate deleteSubUserWithCell:self];
    }
}
@end
