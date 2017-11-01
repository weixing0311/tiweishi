//
//  FcBigImgViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/25.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "FcBigImgViewController.h"

@interface FcBigImgViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation FcBigImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate = self;
    self.scrollview.contentSize = CGSizeMake(JFA_SCREEN_WIDTH*self.images.count, 0);
    self.scrollview.contentOffset = CGPointMake(JFA_SCREEN_WIDTH*self.page, 0);
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu",self.page+1,(unsigned long)self.images.count];
    for (int i =0; i<self.images.count; i++) {
        
        id currImage = self.images[i];
        if (![currImage isKindOfClass:[NSString class]]) {
            currImage = [currImage objectForKey:@"imgUrl"];
        }
        
        UIScrollView *scr = [[UIScrollView alloc]initWithFrame:CGRectMake(i*JFA_SCREEN_WIDTH, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT)];
        UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.tag = i;
        [scr addSubview:imageView];

        imageView.backgroundColor = [UIColor blueColor];

        
        
        NSString *encodedString = (NSString *)

        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)currImage,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));

        [self loadImageWithScr:scr ImageView:imageView Url:encodedString];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if (error) {
//                DLog(@"error--%@",error);
//                imageView.image = [UIImage imageNamed:@"default"];
//            }
//            else
//            {
//                DLog(@"encode--%@",encodedString);
//            float imageHeight = JFA_SCREEN_WIDTH * image.size.height/image.size.width ;
//                imageView.image = image;
//                imageView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH-10, imageHeight);
//                scr.contentSize = CGSizeMake(JFA_SCREEN_WIDTH, imageHeight);
//                imageView.center = CGPointMake(JFA_SCREEN_WIDTH/2, scr.center.y);
//            }
//        }];
        [self.scrollview addSubview:scr];

    }
    
    
    
    
}

-(void)loadImageWithScr:(UIScrollView*)scr ImageView:(UIImageView *)imageView Url:(NSString *)imageUrl
{
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    
    if ( !cachedImage ) {
        imageView.image = getImage(@"default");
        [self downloadImageWithScr:scr ImageView:imageView Url:imageUrl];
    } else {
        float imageHeight = JFA_SCREEN_WIDTH * cachedImage.size.height/cachedImage.size.width ;
        imageView.image = cachedImage;
        imageView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH-10, imageHeight);
        scr.contentSize = CGSizeMake(JFA_SCREEN_WIDTH, imageHeight);
        imageView.center = CGPointMake(JFA_SCREEN_WIDTH/2, scr.center.y);

    }
}

- (void)downloadImageWithScr:(UIScrollView*)scr ImageView:(UIImageView *)imageView Url:(NSString *)imageUrl {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            imageView.image = getImage(@"default");
            return ;
        }
        [[SDImageCache sharedImageCache]storeImage:image forKey:imageUrl completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
            float imageHeight = JFA_SCREEN_WIDTH * image.size.height/image.size.width ;
            imageView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH-10, imageHeight);
            scr.contentSize = CGSizeMake(JFA_SCREEN_WIDTH, imageHeight);
            imageView.center = CGPointMake(JFA_SCREEN_WIDTH/2, scr.center.y);

        });
    }];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/JFA_SCREEN_WIDTH;
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu",page+1,(unsigned long)self.images.count];
}
- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)didSaveImage:(id)sender {
    int page = self.myScrollView.contentOffset.x/JFA_SCREEN_WIDTH;
    UIImageView * imageView = (UIImageView*)[self.view viewWithTag:page];
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
