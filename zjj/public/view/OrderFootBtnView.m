//
//  OrderFootBtnView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "OrderFootBtnView.h"

@implementation OrderFootBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.firstBtn.layer.masksToBounds = YES;
    self.firstBtn.layer.cornerRadius  = 5;

    self.secondBtn.layer.masksToBounds = YES;
    self.secondBtn.layer.cornerRadius  = 5;
    self.secondBtn.layer.borderWidth = 1;
    self.secondBtn.layer.borderColor=[UIColor grayColor].CGColor;

}
-(void)ChangeViewWithStatus:(NSInteger)type
{
}

- (IBAction)didCickFirst:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickFirstBtnWithView:)]) {
        [self.delegate didClickFirstBtnWithView:self];
    }
}

- (IBAction)didClickSecond:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickSecondBtnWithView:)]) {
        [self.delegate didClickSecondBtnWithView:self];
    }
}
@end
