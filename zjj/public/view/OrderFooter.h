//
//  OrderFooter.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    STATUS_WAIT_PAY,
    STATUS_SUCCESS,
    STATUS_CANCEL,
}PayStatus;
@interface OrderFooter : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property(nonatomic,assign)PayStatus status;
- (IBAction)didFirstClick:(id)sender;

- (IBAction)didSecondClick:(id)sender;

-(void)setStatus:(PayStatus)status;
@end
