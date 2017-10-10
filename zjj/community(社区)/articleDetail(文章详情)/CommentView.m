//
//  CommentView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didSend:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didSendCommentWithText:)]) {
        [self.delegate didSendCommentWithText:self.commentTf.text];
    }
}
@end
