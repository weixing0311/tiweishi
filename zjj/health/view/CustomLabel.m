//
//  CustomLabel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CustomLabel.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
@implementation CustomLabel
@synthesize attributedString;
@synthesize isCenterAlignment;
- (instancetype)init
{
    self = [super init];
    if (self) {
           }
    return self;
}
-(CGSize)stringSize
{
    return [attributedString boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesFontLeading context:nil].size;
}

-(void)append:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    NSRange range = NSMakeRange(attributedString.length, text.length);
    //  attributedString.append(NSAttributedString(string: text))

    if (font) {
        [attributedString addAttribute:(NSString *)kCTFontAttributeName value:font range:range];
    }else{
        [attributedString addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
    }
    if (color) {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:color range:range];
    }
    [self setNeedsDisplay];
    
    
}

-(void)clear
{
    [attributedString deleteCharactersInRange:NSMakeRange(0, attributedString.length)];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.0, -1.0);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &transform ,rect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame,contextRef);
}


-(void)setting
{
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    CTParagraphStyleSetting mylineBreakModel ;
    mylineBreakModel.spec=kCTParagraphStyleSpecifierLineBreakMode;//指定为对齐属性
    mylineBreakModel.valueSize=sizeof(lineBreak);
    mylineBreakModel.value=&lineBreak;
    
    
    CGFloat spacing = 4.0;
    CTParagraphStyleSetting mylineSpacing ;
    mylineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    mylineSpacing.valueSize = sizeof(spacing);
    mylineSpacing.value = &spacing;
    
    if (isCenterAlignment ==NO) {
        return;
    }
        CTRubyAlignment  alignmentValue = kCTRubyAlignmentCenter;
        CTParagraphStyleSetting myalignment;
        myalignment.spec = kCTParagraphStyleSpecifierAlignment;
        myalignment.valueSize = sizeof(alignmentValue);
        myalignment.value =&alignmentValue;
        
    
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &spacing},
        {kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &mylineBreakModel},
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTRubyAlignment), &myalignment}
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);

    [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)theParagraphRef range:NSMakeRange(0, [attributedString length])];


}


        
@end
