//
//  LineChart.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LineChartDelegate

-(void)didSelectDataPointWithX:(CGFloat)X y:(CGFloat)y;
@end

@interface LineChart : UIView
@property (nonatomic, assign)  id<LineChartDelegate>delegate;
@property (nonatomic, assign)  BOOL visible;
@property (nonatomic, copy)    NSString * values;
@property (nonatomic, assign)  CGFloat    count;
@property (nonatomic, strong)  UIColor *color;
@property (nonatomic, assign)  BOOL enabled;


-(void)Labels;
-(void)Grid;
-(void)Axis;
@end
