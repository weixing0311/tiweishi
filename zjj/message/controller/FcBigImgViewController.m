//
//  FcBigImgViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/25.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "FcBigImgViewController.h"

@interface FcBigImgViewController ()<UIScrollViewDelegate>

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
        
        
        UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(i*JFA_SCREEN_WIDTH+5, 0, 0, 0)];

        
        
        
        NSString *encodedString = (NSString *)

        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)self.images[i],
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));

        
        [imageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"head_default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (!error) {
            float imageHeight = JFA_SCREEN_WIDTH * image.size.height/image.size.width ;
                
                imageView.frame =CGRectMake(i*JFA_SCREEN_WIDTH+5, (JFA_SCREEN_HEIGHT-imageHeight)/2, JFA_SCREEN_WIDTH-10, imageHeight);
            }
            
        }];
        [self.scrollview addSubview:imageView];

    }
    
    
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/JFA_SCREEN_WIDTH;
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu",page+1,(unsigned long)self.images.count];
}
- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
