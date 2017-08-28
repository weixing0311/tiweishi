
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoWithDict:(NSDictionary *)dict
{
    self.headImageView.image = [UIImage imageNamed:@"logo"];
    self.titleView.text = [dict safeObjectForKey:@"title"];
    self.contentLabel.text = [dict safeObjectForKey:@"content"];
    self.timeLabel.text = [dict safeObjectForKey:@"releaseTime"];
    for (UIView * view in self.imagesView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray * imageArr =[dict safeObjectForKey:@"images"];
    NSMutableArray * picArr = [dict safeObjectForKey:@"pictures"];
    
    if (imageArr.count == picArr.count) {
        [self buildNineImagesWithArray:imageArr];

    }else{
//    NSString * cardUrl = [dict safeObjectForKey:@"cardUrl"];
//    [imageArr addObject:cardUrl];

    [self buildNineImagesWithArray:picArr];
    }
}

-(void)buildNineImagesWithArray:(NSArray *)array
{
    int totalColumns = 3;
    
    //       每一格的尺寸
    CGFloat cellW = (JFA_SCREEN_WIDTH-108)/3;
    CGFloat cellH = (JFA_SCREEN_WIDTH-108)/3;
    
    //    间隙
    CGFloat margin =10;
    
    //    根据格子个数创建对应的框框
    for(int index = 0; index< array.count; index++) {
        UIButton *cellView = [UIButton buttonWithType:UIButtonTypeCustom ];
        cellView.backgroundColor = HEXCOLOR(0xeeeeee);
        cellView.layer.borderWidth = 1;
        cellView.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;

//        [cellView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:array[index]] placeholderImage:[UIImage imageNamed:@"default"]];
        
        id imageCur = [array objectAtIndex:index];
        if ([imageCur isKindOfClass:[UIImage class]]) {
            [cellView setBackgroundImage:imageCur forState:UIControlStateNormal];

        }else{
        
            [cellView sd_setImageWithURL:[NSURL URLWithString:array[index]] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                image = [self cutImage:image imgViewWidth:cellW imgViewHeight:cellH];
            }];
            
            
            
//        [cellView setBackgroundImage:[self getImageFromUrl:[NSURL URLWithString:array[index]] imgViewWidth:cellW imgViewHeight:cellH] forState:UIControlStateNormal];
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
        
        // 添加到view 中  
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
