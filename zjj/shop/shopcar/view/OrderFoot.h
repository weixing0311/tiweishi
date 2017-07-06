//
//  OrderFoot.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFoot : UIView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
- (IBAction)secondDidClick:(id)sender;
- (IBAction)redDidClick:(id)sender;

@end
