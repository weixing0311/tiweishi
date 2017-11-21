
//
//  FriendsCircleCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "FriendsCircleCell.h"

@implementation FriendsCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.loadedImage = [NSMutableArray array];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoWithDict:(LoadedImageModel *)item
{
    self.headImageView.image = [UIImage imageNamed:@"logo"];
    self.titleView.text = item.title;
    self.contentLabel.text = item.content;
    self.timeLabel.text = item.releaseTime;
    for (UIView * view in self.imagesView.subviews) {
        [view removeFromSuperview];
    }
    [self buildNineImagesWithArray:item.pictures];
}

-(void)buildNineImagesWithArray:(NSArray *)array
{
    int totalColumns = 0;
    if (array.count==2||array.count==4) {
        totalColumns =2;
    }else{
        totalColumns =3;
    }
    
    //       每一格的尺寸
    CGFloat cellW = (JFA_SCREEN_WIDTH-108)/3;
    CGFloat cellH = (JFA_SCREEN_WIDTH-108)/3;
    
    //    间隙
    CGFloat margin =10;
    
    //    根据格子个数创建对应的框框
    
    
    for(int index = 0; index< array.count; index++) {
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.contentMode =UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = HEXCOLOR(0xeeeeee);
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;

        UIButton *cellView = [UIButton buttonWithType:UIButtonTypeCustom ];

//        [cellView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:array[index]] placeholderImage:[UIImage imageNamed:@"default"]];
        
        id imageCur = [array objectAtIndex:index];
        if ([imageCur isKindOfClass:[UIImage class]]) {
            imageView.image = imageCur;

        }else{
            NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)array[index],(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));

            
            
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:getImage(@"default")];
            
//            [imageView getImageWithUrl:encodedString getImageFinish:^(UIImage *image, NSError *error) {
//                imageView.image =[self cutImage:image imgViewWidth:cellW imgViewHeight:cellH];
//            }];
        }
        cellView.tag = index+1;
        [cellView addTarget:self action:@selector(didClickImages:) forControlEvents:UIControlEventTouchUpInside];
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin);
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        imageView.frame =CGRectMake(cellX, cellY, cellW, cellH);
        // 添加到view 中
        [self.imagesView addSubview:imageView];
        [self.imagesView addSubview:cellView];
    }
}

-(void)didClickImages:(UIButton *)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didCheckImagesWithButton:cell:)]) {
        [self.delegate didCheckImagesWithButton:sender cell:self];
    }
}

- (IBAction)didShare:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShareWithCell:)]) {
        [self.delegate didClickShareWithCell:self];
    }
    
}




#pragma mark-------根据imgView的宽高获得图片的比例

-(UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    
    UIImage * newImage = [self getImageWithUrl:imgUrl imgViewWidth:width imgViewHeight:height];
    
    return newImage;
    
}

//对象方法

-(UIImage *)getImageWithUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    //data 转image
    
    UIImage * image ;
    
    //根据网址将图片转化成image
    
    NSData * data = [NSData dataWithContentsOfURL:imgUrl];
    
    image =[UIImage imageWithData:data];
    
    //图片剪切
    
    UIImage * newImage = [self cutImage:image imgViewWidth:width imgViewHeight:height];
    
    return newImage;
    
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

@end
