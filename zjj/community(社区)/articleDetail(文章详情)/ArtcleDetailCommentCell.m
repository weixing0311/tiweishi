//
//  ArtcleDetailCommentCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ArtcleDetailCommentCell.h"

@implementation ArtcleDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)didClickHeadImg:(id)sender {
}
- (IBAction)didZan:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didZanCommentWithCell:)]) {
        [self.delegate didZanCommentWithCell:self];
    }
    
    
    
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
