//
//  PublicCollImageCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PublicCollImageCell.h"

@implementation PublicCollImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.contentMode =UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    // Initialization code

}

@end
