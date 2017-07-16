//
//  UserView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserView.h"

@implementation UserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didUserInfo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showUserList)]) {
        [self.delegate showUserList];
    }
}


@end
