//
//  CustomLabel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UIView
@property(nonatomic,strong) NSMutableAttributedString * attributedString;
@property(nonatomic,assign)BOOL isCenterAlignment;
-(void)append:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
@end
