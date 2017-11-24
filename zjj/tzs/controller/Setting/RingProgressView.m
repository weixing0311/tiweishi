//
//  RingProgressView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "RingProgressView.h"

@implementation RingProgressView

-(void)reSetMyProgressView
{
    [self setNeedsDisplay];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();//获取上下文
    CGPoint center1 = CGPointMake(20, 20);  //设置圆心位置
    CGFloat radius1 = 18;  //设置半径
    CGFloat startA1 =  M_PI_8*5.7;  //圆起点位置
    CGFloat endA1 = M_PI_8*5.7 + M_PI * 2 * 0.8;  //圆终点位置
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center1 radius:radius1 startAngle:startA1 endAngle:endA1 clockwise:YES];
    CGContextSetLineWidth(ctx1, 2); //设置线条宽度
    [HEXCOLOR(0xeeeeee) setStroke]; //设置描边颜色
    CGContextAddPath(ctx1, path1.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx1);  //渲染

    
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    CGPoint center = CGPointMake(20, 20);  //设置圆心位置
    CGFloat radius = 18;  //设置半径
    CGFloat startA =  M_PI_8*5.7;  //圆起点位置
    CGFloat endA = M_PI_8*5.7 + M_PI * 2 * self.progressValue*0.8;  //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx, 2); //设置线条宽度
    [[UIColor redColor] setStroke]; //设置描边颜色
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx);  //渲染
    
}

@end
