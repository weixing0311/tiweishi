//
//  HistorySectionView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistorySectionView.h"

@implementation HistorySectionView

- (IBAction)didShowDetailInfo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowDetailInfoWithIndex:)]) {
        [self.delegate didShowDetailInfoWithIndex:self.tag];
    }else{
        DLog(@"代理未执行");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
