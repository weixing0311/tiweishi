
//
//  FootView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "FootView.h"

@implementation FootView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bottomLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}
- (IBAction)didClickFootBtn:(UIButton *)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didClickFootViewBtnWithTag:)]) {
        [self.delegate didClickFootViewBtnWithTag:sender.tag];
    }
}

@end
