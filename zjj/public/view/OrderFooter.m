//
//  OrderFooter.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "OrderFooter.h"

@implementation OrderFooter

-(void)setStatus:(PayStatus)status
{
    switch (self.status) {
        case STATUS_WAIT_PAY:
            [self.firstBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"取消订购" forState:UIControlStateNormal];
            self.firstBtn.hidden =NO;
            self.secondBtn.hidden = NO;
            break;
        case STATUS_SUCCESS:
            self.firstBtn.hidden =YES;
            self.secondBtn.hidden = YES;
            break;
        case STATUS_CANCEL:
            [self.firstBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"取消订购" forState:UIControlStateNormal];
            self.firstBtn.hidden =YES;
            self.secondBtn.hidden = YES;
            break;
            
        default:
            break;
    }

}
- (IBAction)didFirstClick:(id)sender {
}

- (IBAction)didSecondClick:(id)sender {
}
@end
