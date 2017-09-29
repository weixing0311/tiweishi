//
//  GrowthHeader2View.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GrowthHeader2View.h"

@implementation GrowthHeader2View



- (IBAction)didQd:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickQd)]) {
        [self.delegate didClickQd];
    }
}
@end
