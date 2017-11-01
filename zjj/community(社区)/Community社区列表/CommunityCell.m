//
//  CommunityCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommunityCell.h"
#import <CoreImage/CoreImage.h>
#define BigImageWidth JFA_SCREEN_WIDTH-40
#define BigImageHeight (JFA_SCREEN_WIDTH-40)*0.6

@implementation CommunityCell
{
    CGSize  videoSize;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gzBtn.layer.borderWidth= 1;
    self.gzBtn.layer.borderColor = [UIColor redColor].CGColor;

    self.topLabel.layer.borderWidth= 1;
    self.topLabel.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;

    
    
    self.imagesArray = [NSMutableArray array];
    [self.midImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage)]];

}
-(void)setInfoWithDict:(CommunityModel *)item
{
    self.currModel = item;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.headurl] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
    
    self.titleIb.text        = item.title;
    self.contentlb.text      = item.content;
    self.timelb.text         = item.releaseTime;
    self.zanCountlb.text     = item.greatnum;
    self.commentCountlb.text = item.commentnum;
//    self.shareCountlb.text   = item.forwardingnum;
    self.levelLb.text        = item.level;
    if (item.isFabulous&&[item.isFabulous isEqualToString:@"1"]) {
        
        self.zanImageView.image = getImage(@"praise_Selected");
        self.zanCountlb.textColor = [UIColor orangeColor];
        
    }else{
        self.zanImageView.image = getImage(@"praise");
        self.zanCountlb.textColor = HEXCOLOR(0x666666);
    }
    
    if ( item.isFollow&&[item.isFollow isEqualToString:@"1"]) {
        self.gzBtn.selected = YES;
        self.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

    }else{
        self.gzBtn.selected = NO;
        self.gzBtn.layer.borderColor = [UIColor redColor].CGColor;
    }

    if ([item.topNum intValue]>0) {
        self.topLabel.hidden = NO;
    }else{
        self.topLabel.hidden = YES;
    }

    
    NSString * imageUrl ;
    if (item.movieStr.length>5) {
        self.midImageView.userInteractionEnabled = NO;
        self.bgImageView.hidden = NO;
        self.playBtn.hidden = NO;
        self.zhezhaoceng.hidden = NO;
        imageUrl  = [NSString stringWithFormat:@"%@",item.movieImageStr];
    }else{
        self.midImageView.userInteractionEnabled = YES;
        self.bgImageView.hidden =YES;
        self.playBtn.hidden = YES;
        self.zhezhaoceng.hidden = YES;
        imageUrl = item.pictures[0];;
    }
    [self configureImage:imageUrl];
}
- (void)configureImage:(NSString *)imageUrl {
    
    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    
    if ( !cachedImage ) {
        self.bgImageView.image = getImage(@"default");
        self.midImageView.image = getImage(@"default");
        [self downloadImage:imageUrl];
    } else {
        self.bgImageView.image =cachedImage;
        
        self.midImageView.image = [self cutImage:cachedImage imgViewWidth:BigImageHeight/cachedImage.size.height*cachedImage.size.width imgViewHeight:BigImageHeight];

        if (self.currModel.movieStr.length>5) {
            self.midImageView.frame = CGRectMake(
                                                 JFA_SCREEN_WIDTH/2-20 - BigImageHeight/cachedImage.size.height*cachedImage.size.width/2<0?0:JFA_SCREEN_WIDTH/2-20 - BigImageHeight/cachedImage.size.height*cachedImage.size.width/2,
                                                 0,
                                                 BigImageHeight/cachedImage.size.height*cachedImage.size.width>(JFA_SCREEN_WIDTH-20)?(JFA_SCREEN_WIDTH-40):BigImageHeight/cachedImage.size.height*cachedImage.size.width,
                                                 BigImageHeight);
            DLog(@"已存在image--video");
        }else{
            self.midImageView.frame = CGRectMake(0,
                                                 0,
                                                 BigImageHeight/cachedImage.size.height*cachedImage.size.width>(JFA_SCREEN_WIDTH-20)?(JFA_SCREEN_WIDTH-40):BigImageHeight/cachedImage.size.height*cachedImage.size.width,
                                                 BigImageHeight);
            DLog(@"已存在image--Image");
        }

    }
}

- (void)downloadImage:(NSString *)imageURL {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            self.bgImageView.image = getImage(@"default");
            self.midImageView.image = getImage(@"");
            return ;
        }
        [[SDImageCache sharedImageCache]storeImage:image forKey:imageURL completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bgImageView.image = image;
            self.midImageView.image = image;
            if (self.currModel.movieStr.length>5) {
                self.midImageView.frame = CGRectMake(
                                                     JFA_SCREEN_WIDTH/2-20 - BigImageHeight/image.size.height*image.size.width/2<0?0:JFA_SCREEN_WIDTH/2-20 - BigImageHeight/image.size.height*image.size.width/2,
                                                     0,
                                                     BigImageHeight/image.size.height*image.size.width>(JFA_SCREEN_WIDTH-20)?(JFA_SCREEN_WIDTH-40):BigImageHeight/image.size.height*image.size.width,
                                                     BigImageHeight);
                DLog(@"下载image--video");

            }else{
                self.midImageView.frame = CGRectMake(
                                                     0,
                                                     0,
                                                     BigImageHeight/image.size.height*image.size.width>(JFA_SCREEN_WIDTH-20)?(JFA_SCREEN_WIDTH-40):BigImageHeight/image.size.height*image.size.width,
                                                     BigImageHeight);
                DLog(@"下载image--image");
            }

        });
    }];
}


//裁剪图片

- (UIImage *)cutImage:(UIImage*)image imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height

{
    
    //压缩图片
    
    
    
    CGSize newSize;
    
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (width / height)) {
        
        newSize.width = image.size.width;
        
        newSize.height = image.size.width * height /width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        
        newSize.height = image.size.height;
        
        newSize.width = image.size.height * width / height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
    
}

#pragma mark --button SEL

-(void)showBigImage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowBigImageWithBigCell:index:)]) {
        [self.delegate didShowBigImageWithBigCell:self index:0];
    }

}
- (IBAction)didClickPlay:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayWithBigCell:)]) {
        [self.delegate didPlayWithBigCell:self];
    }else{
        DLog(@"代理未走通");
    }
}

- (IBAction)didShare:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShareWithBigCell:)]) {
        [self.delegate didShareWithBigCell:self];
    }
}
- (IBAction)didpl:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPLWithBigCell:)]) {
        [self.delegate didPLWithBigCell:self];
    }
}
- (IBAction)didZan:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didZanWithBigCell:)]) {
        [self.delegate didZanWithBigCell:self];
    }
}
- (IBAction)didGz:(id)sender {
//    if (self.gzBtn.selected == YES) {
//        return;
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didGzWithBigCell:)]) {
        [self.delegate didGzWithBigCell:self];
    }else{
        NSLog(@"关注代理没走通");
    }
}

- (IBAction)didClickJB:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didJBWithBigCell:)]) {
        [self.delegate didJBWithBigCell:self];
    }
    
    
}
- (IBAction)didClickHeadImage:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didTapHeadImageViewWithBigCell:)]) {
        [self.delegate didTapHeadImageViewWithBigCell:self];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
