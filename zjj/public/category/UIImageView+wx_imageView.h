//
//  UIImageView+wx_imageView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (wx_imageView)
//请求成功回调block
typedef void (^getImageFinish)(UIImage * image,NSError * error);
-(void)getImageWithUrl:(NSString *)urlstr
        getImageFinish:(getImageFinish)finish;
@end
