//
//  JFASubNetWorkErrorView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFASubNetWorkErrorView.h"

@implementation JFASubNetWorkErrorView

{
    UIImageView* errorImageView;
    UIView* errorView;
    UILabel* errorLabel;
}
-(instancetype)initWithFrame:(CGRect)frame bgimage:(UIImage*)bgimage
{
    self=[super initWithFrame:frame];
    if (self) {
        if (bgimage) {
            [self initErrorView];
            
            [self initErrorImageView];
            errorImageView.image = bgimage;
            
            [self initTapGesture];
            [self layoutSubviews];
            self.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];

        }
    }
    return self;
}

-(void)initErrorView
{
    errorView=[[UIView alloc] initWithFrame:self.bounds];
    errorView.backgroundColor=[UIColor clearColor];
    [self addSubview:errorView];
}

-(void)initErrorImageView
{
    errorImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,0,0)];
    errorImageView.backgroundColor=[UIColor clearColor];
    [errorView addSubview:errorImageView];
    
    errorLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    errorLabel.backgroundColor=[UIColor clearColor];
    errorLabel.textColor=[UIColor blackColor];
    errorLabel.font=[UIFont systemFontOfSize:16];
    errorLabel.numberOfLines=0;
    errorLabel.textAlignment=NSTextAlignmentCenter;
    errorLabel.text=@"没有网络，请点击重新加载";
    [errorView addSubview:errorLabel];
}

-(void)initTapGesture
{
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshAction:)];
    [self addGestureRecognizer:tap];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = errorImageView.frame;
    //    rect.origin.y = AI_STORE_IS_IPHONE5 ? 85 : 40;
    rect.origin.y = self.frame.size.height*1/4.0 - 20;
    rect.size.width = AI_SCREEN_WIDTH*3/5.0;
    rect.origin.x = AI_SCREEN_WIDTH/2 - rect.size.width/2;
    rect.size.height = AI_SCREEN_WIDTH*3/5.0+10;
    errorImageView.frame = rect;
    
    CGRect frame = errorLabel.frame;
    CGSize labelSize = [errorLabel sizeThatFits:self.bounds.size];
    frame.size.width = labelSize.width;
    frame.size.height = labelSize.height;
    frame.origin.x = (self.bounds.size.width - labelSize.width) / 2;
    frame.origin.y = errorImageView.frame.origin.y + errorImageView.frame.size.height + 25;
    errorLabel.frame = frame;
    
    
}

-(void)refreshAction:(UITapGestureRecognizer*)tap
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(didRefreshInfo)]) {
        [self.delegate didRefreshInfo];
    }
}

@end
