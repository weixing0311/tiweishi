//
//  UIImageView+wx_imageView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UIImageView+wx_imageView.h"

@implementation UIImageView (wx_imageView)
-(void)getImageWithUrl:(NSString *)urlstr getImageFinish:(getImageFinish)finish
{
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlstr];
    if (!cachedImage) {
        [self downloadImageWithUrl:urlstr getImageFinish:finish];
    }else{
        finish(cachedImage,nil);
    }
}


- (void)downloadImageWithUrl:(NSString *)imageUrl getImageFinish:(getImageFinish)finish{
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            [self downloadFailImageWithUrl:imageUrl getImageFinish:finish];
            return ;
        }
        [[SDImageCache sharedImageCache]storeImage:image forKey:imageUrl completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(image,nil);
        });
    }];
}
- (void)downloadFailImageWithUrl:(NSString *)imageUrl getImageFinish:(getImageFinish)finish
{
    
    [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (error) {
            finish(nil,error);
        }
        [[SDImageCache sharedImageCache]storeImage:image forKey:imageUrl completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(image,nil);
        });
    }];
}

@end
