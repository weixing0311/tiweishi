//
//  QrCodeView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "QrCodeView.h"

@implementation QrCodeView
{
    NSString * _linkStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .5);

    
}

-(void)setInfoWithDict:(NSDictionary *)dict
{
    [self.headimageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]options:SDWebImageRetryFailed];
    self.nameLabel.text = [UserModel shareInstance].nickName;
    self.levelLabel.text = [UserModel shareInstance].gradeName;
    self.levelImage.image = [[UserModel shareInstance] getLevelImage];
    [self.qrcodeImage sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].qrcodeImageUrl] placeholderImage:[UIImage imageNamed:@"demoimage_"]options:SDWebImageRetryFailed];
    _linkStr = [UserModel shareInstance].linkerUrl;


}


- (IBAction)didCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",_linkStr];
    [self.copBtn setTitle:@"链接已复制到剪切板" forState:UIControlStateNormal];
}
- (IBAction)didShare:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShareWithimage:)]) {
        [self.delegate didShareWithimage:self.qrcodeImage.image];
        [self removeFromSuperview];
    }
    
}

- (IBAction)didClose:(id)sender {
    [self removeFromSuperview];
}

-(UIImage *)getImageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    //    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    [view removeFromSuperview];
    return viewImage;
}

@end
