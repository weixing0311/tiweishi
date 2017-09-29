//
//  PublicArticleCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PublicArticleCell.h"
#import "PublicCollImageCell.h"
@implementation PublicArticleCell
{
    float cellHeight ;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (IBAction)didClickPlay:(id)sender {
    self.playerBtn.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayWithCell:)]) {
        [self.delegate didPlayWithCell:self];
    }
}

#pragma mark --button SEL
- (IBAction)didShare:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShareWithCell:)]) {
        [self.delegate didGzWithCell:self];
    }
}
- (IBAction)didpl:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPLWithCell:)]) {
        [self.delegate didPLWithCell:self];
    }
}
- (IBAction)didZan:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didZanWithCell:)]) {
        [self.delegate didGzWithCell:self];
    }
}
- (IBAction)didGz:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didGzWithCell:)]) {
        [self.delegate didGzWithCell:self];
    }
}

-(void)setInfoWithDict:(CommunityModel *)item
{
    cellHeight = item.rowHieght;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.headurl] forState:UIControlStateNormal placeholderImage:getImage(@"logo")];
    
    self.titleIb.text = item.title;
    self.contentlb.text = item.content;
    self.timelb.text = item.releaseTime;
    for (UIView * view in self.imagesView.subviews) {
        if (![view isKindOfClass:[self.playerBtn class]]) {
            [view removeFromSuperview];
        }
    }
    if (item.movieStr.length>5) {
        self.playerBtn.hidden = NO;
        [self.playerBtn sd_setImageWithURL:[NSURL URLWithString:item.movieImageStr] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                [self.playerBtn setImage:[self cutImage:image imgViewWidth:JFA_SCREEN_WIDTH-20 imgViewHeight:(JFA_SCREEN_WIDTH-20)*0.7] forState:UIControlStateNormal];
            }
        }];

    }else{
        self.playerBtn.hidden = YES;
    NSMutableArray * picArr = item.pictures;
    [self buildNineImagesWithArray:picArr];
    }
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
    CGFloat cellW = 0.0;
    CGFloat cellH = 0.0;
    if (array.count<3) {
        cellW = (JFA_SCREEN_WIDTH-40)/array.count;
        cellH = (JFA_SCREEN_WIDTH-40)/3;

    }else{
        cellW = (JFA_SCREEN_WIDTH-40)/3;
        cellH = (JFA_SCREEN_WIDTH-40)/3;

    }
    
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
            NSString *encodedString = (NSString *)
            
            CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      
                                                                      (CFStringRef)array[index],
                                                                      
                                                                      (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                      
                                                                      NULL,
                                                                      
                                                                      kCFStringEncodingUTF8));
            
            [cellView sd_setImageWithURL:[NSURL URLWithString:encodedString] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    [cellView setImage:[self cutImage:image imgViewWidth:cellW imgViewHeight:cellH] forState:UIControlStateNormal];
                }
            }];
            
        }
        cellView.tag = index+1;
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
-(void)saveImages
{
}

#pragma mark-------根据imgView的宽高获得图片的比例

-(UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    
    UIImage * newImage = [self getImageWithUrl:imgUrl imgViewWidth:width imgViewHeight:height];
    
    return newImage;
    
}


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
- (CGFloat)cellOffset{
    /*
     - (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
     将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
     这里用来获取self在window上的位置
     */
    CGRect toWindow      = [self convertRect:self.bounds toView:self.window];
    //获取父视图的中心
    CGPoint windowCenter = self.superview.center;
    //cell在y轴上的位移
    CGFloat cellOffsetY  = CGRectGetMidY(toWindow) - windowCenter.y;
    //位移比例
    CGFloat offsetDig    = 2 * cellOffsetY / self.superview.frame.size.height ;
    //要补偿的位移,self.superview.frame.origin.y是tableView的Y值，这里加上是为了让图片从最上面开始显示
    CGFloat offset       = - offsetDig * (JFA_SCREEN_WIDTH-20 - cellHeight) / 2;
    //让pictureViewY轴方向位移offset
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    self.imagesView.transform   = transY;
    return offset;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
