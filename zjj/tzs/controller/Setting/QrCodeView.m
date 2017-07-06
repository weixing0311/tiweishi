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
    [self.headimageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"default_"]];
    self.nameLabel.text = [UserModel shareInstance].nickName;
    self.levelLabel.text = [UserModel shareInstance].gradeName;
    self.levelImage.image = [[UserModel shareInstance] getLevelImage];
    [self.qrcodeImage setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].qrcodeImageUrl] placeholderImage:[UIImage imageNamed:@"demoimage_"]];
    _linkStr = [UserModel shareInstance].linkerUrl;


}


- (IBAction)didCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _linkStr;
    [self.copBtn setTitle:@"链接已复制到剪切板" forState:UIControlStateNormal];
}

- (IBAction)didClose:(id)sender {
    [self removeFromSuperview];
}
@end
