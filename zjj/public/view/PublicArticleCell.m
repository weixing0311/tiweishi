//
//  PublicArticleCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PublicArticleCell.h"
#import "PublicCollImageCell.h"
#import <CoreImage/CoreImage.h>
#define BigImageWidth JFA_SCREEN_WIDTH-20
#define BigImageHeight (JFA_SCREEN_WIDTH-20)*0.7
@implementation PublicArticleCell
{
    float cellHeight ;
    CGSize  videoSize;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gzBtn.layer.borderWidth= 1;
    self.gzBtn.layer.borderColor = [UIColor redColor].CGColor;

    
    
    self.imagesArray = [NSMutableArray array];
//    self.layout.itemSize = CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;//实现数据源方法
    self.collectionView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH-40, (JFA_SCREEN_WIDTH-40)*0.7);
    self.collectionView.bounces = NO;
        self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    [self.collectionView registerNib:[UINib nibWithNibName:@"PublicCollImageCell"bundle:nil]forCellWithReuseIdentifier:@"PublicCollImageCell"];
    


}
- (IBAction)didClickPlay:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayWithCell:)]) {
        [self.delegate didPlayWithCell:self];
    }
}

#pragma mark --button SEL
- (IBAction)didShare:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShareWithCell:)]) {
        [self.delegate didShareWithCell:self];
    }
}
- (IBAction)didpl:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPLWithCell:)]) {
        [self.delegate didPLWithCell:self];
    }
}
- (IBAction)didZan:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didZanWithCell:)]) {
        [self.delegate didZanWithCell:self];
    }
}
- (IBAction)didGz:(id)sender {
    if (self.gzBtn.selected == YES) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didGzWithCell:)]) {
        [self.delegate didGzWithCell:self];
    }else{
        NSLog(@"关注代理没走通");
    }
}

-(void)setInfoWithDict:(CommunityModel *)item
{
    cellHeight = item.rowHieght;
    self.currModel = item;
    if ([item.loadSuccess isEqualToString:@"1"]) {
        self.collectionView.hidden =NO;
    }else{
        self.collectionView.hidden = YES;
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.headurl] forState:UIControlStateNormal placeholderImage:getImage(@"logo")];
    
    self.titleIb.text = item.title;
    
    NSString * str = item.content;
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    self.contentlb.text = str;
    self.timelb.text = item.releaseTime;
    self.zanCountlb.text = item.greatnum;
    self.commentCountlb.text = item.commentnum;
    
    if (item.isFabulous&&[item.isFabulous isEqualToString:@"1"]) {
        
        self.zanImageView.image = getImage(@"praise_Selected");
        
    }else{
        self.zanImageView.image = getImage(@"praise");
    }
    
    if ( item.isFollow&&[item.isFollow isEqualToString:@"1"]) {
        self.gzBtn.selected = YES;
    }else{
        self.gzBtn.selected = NO;
    }
    
    
    
    
}
-(void)loadImagesWithItem:(CommunityModel *)item
{
    if (item.movieStr.length>5) {
        //        self.playerBtn.hidden = NO;
        [self.imagesArray removeAllObjects];
        NSMutableDictionary * dict =[NSMutableDictionary dictionary];
        [dict safeSetObject:item.movieImageStr forKey:@"videoImageStr"];
        [dict safeSetObject:@(BigImageWidth) forKey:@"videoSizeWidht"];
        [dict safeSetObject:@(BigImageHeight) forKey:@"videoSizeHeight"];
        
        [self.imagesArray addObject:dict];
    }else{
        [self.imagesArray removeAllObjects];
        //        self.playerBtn.hidden = YES;
        //        self.imagesArray = item.pictures;
        for (NSString * imageStr in item.pictures) {
            NSMutableDictionary * dict =[NSMutableDictionary dictionary];
            [dict safeSetObject:imageStr forKey:@"videoImageStr"];
            if (item.pictures.count==1) {
                [dict safeSetObject:@(BigImageWidth ) forKey:@"videoSizeWidht"];
                [dict safeSetObject:@(BigImageHeight) forKey:@"videoSizeHeight"];
                
            }else{
                if (item.pictures.count ==4) {
                    [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/2-20) forKey:@"videoSizeWidht"];
                    [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/2-20) forKey:@"videoSizeHeight"];
                    
                }
                else
                {
                    [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/3-10) forKey:@"videoSizeWidht"];
                    [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/3-10) forKey:@"videoSizeHeight"];
                }
            }
            [self.imagesArray addObject:dict];
        }
    }
    if (!_imagesArray|| _imagesArray.count==0) {
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
    }
    [self.collectionView reloadData];
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
//    self.imagesView.transform   = transY;
    return offset;
}


#pragma mark ----collectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    DLog(@"%d",self.imagesArray.count);
    return self.imagesArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    if (_imagesArray.count ==1) {
//        // 先从缓存中查找图片
//        NSDictionary * dic = [_imagesArray objectAtIndex:0];
//
//        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: [dic safeObjectForKey:@"videoImageStr"]];
//
//        // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
//        if (!image) {
//            return UIEdgeInsetsMake(5,([[dic safeObjectForKey:@"videoSizeWidht"]doubleValue])/2, 5, ([[dic safeObjectForKey:@"videoSizeWidht"]doubleValue])/2);//分别为上、左、下、右
//        }else{
//            DLog(@"bigimageSize (%f) ----%f,%f image --W-%f  h --%f",BigImageHeight,BigImageHeight*image.size.width/image.size.height,BigImageHeight,image.size.width,image.size.height);
//
//            CGFloat imageW = image.size.width;
//            CGFloat imageH = image.size.height;
//
//            CGFloat imageWH = imageW/imageH;
//            CGFloat bigImageH = (JFA_SCREEN_WIDTH-20)*0.8-20<imageH?(JFA_SCREEN_WIDTH-20)*0.8-20:imageH;
//            CGFloat bigImageW = bigImageH* imageWH;
//
//            //手动计算cell
//            return UIEdgeInsetsMake(5,(JFA_SCREEN_WIDTH-bigImageW)/2, 5, (JFA_SCREEN_WIDTH-bigImageW)/2);//分别为上、左、下、右
//
//        }
//    }else{
        return UIEdgeInsetsMake(5,10, 5, 10);//分别为上、左、下、右

        
//    }

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublicCollImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublicCollImageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.currModel.movieStr.length>5) {
        cell.headerImageView.hidden =NO;
        cell.playImageView.hidden = NO;
        cell.midImageView.hidden = NO;
        cell.visualView.hidden =NO;
        [cell bringSubviewToFront:cell.playImageView];
    }else{
        if (_imagesArray.count==1) {
            cell.headerImageView.hidden = YES;
            cell.midImageView.hidden =NO;
        }else{
            cell.midImageView.hidden = YES;
            cell.headerImageView.hidden =NO;
        }
        cell.playImageView.hidden = YES;
        cell.visualView.hidden = YES;
 
    }
    
    NSMutableDictionary * dict = [_imagesArray objectAtIndex:indexPath.row];
    
//    if (self.imagesArray.count ==1) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }else{
    
    [cell.headerImageView sd_setImageWithURL:[dict safeObjectForKey:@"videoImageStr"] placeholderImage:getImage(@"default") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            cell.headerImageView.image = getImage(@"bigDefalut_");
            return ;
        }
//        if (!image) {
//            cell.headerImageView.image = getImage(@"");
//
//            return ;
//        }
        if (_imagesArray.count==1) {
          
            cell.midImageView.image = [self cutImage:image imgViewWidth:BigImageHeight/image.size.height*image.size.width imgViewHeight:BigImageHeight];
            
            cell.midImageView.frame = CGRectMake(0, 0, BigImageHeight/image.size.height*image.size.width, BigImageHeight);
            
            cell.headerImageView.image = [self cutImage:image imgViewWidth:BigImageWidth imgViewHeight:BigImageHeight];

            cell.midImageView.center = cell.center;
    }else{
        cell.headerImageView.image = [self cutImage:image imgViewWidth:(JFA_SCREEN_WIDTH-20)/2-20 imgViewHeight:(JFA_SCREEN_WIDTH-20)/2-20];
    }
        if (indexPath.row ==_imagesArray.count-1) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(loadImageSuccessWithCell:)]) {
                [self.delegate loadImageSuccessWithCell:self];
            }
        }
    }];

//    }
    return cell;
}

- (void)configureCell:(PublicCollImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *imgURL = [self.imagesArray[indexPath.row]safeObjectForKey:@"videoImageStr"];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    
    if ( !cachedImage ) {
        [self downloadImage:[self.imagesArray[indexPath.row]safeObjectForKey:@"videoImageStr"] forIndexPath:indexPath];
        cell.headerImageView.image = getImage(@"default");
    } else {
        cell.headerImageView.image =cachedImage;
    }
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    
    
    NSMutableDictionary * dic = [self.imagesArray objectAtIndex:indexPath.row];
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        [dic safeSetObject:@(BigImageHeight/image.size.height*image.size.width) forKey:@"videoSizeWidht"];
        [dic safeSetObject:@(BigImageHeight) forKey:@"videoSizeHeight"];
        
        [[SDImageCache sharedImageCache]storeImage:image forKey:imageURL completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [_imagesArray objectAtIndex:indexPath.row];
    if (_imagesArray.count ==1) {
        return CGSizeMake(BigImageWidth-20, BigImageHeight);
    }
//        // 先从缓存中查找图片
//        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: [dic safeObjectForKey:@"videoImageStr"]];
//
//        // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
//        if (!image) {
//            return CGSizeMake([[dic safeObjectForKey:@"videoSizeWidht"]doubleValue], [[dic safeObjectForKey:@"videoSizeHeight"]doubleValue]);
//        }else{
//            DLog(@"bigimageSize (%f) ----%f,%f image --W-%f  h --%f",BigImageHeight,BigImageHeight*image.size.width/image.size.height,BigImageHeight,image.size.width,image.size.height);
//
//            CGFloat imageW = image.size.width;
//            CGFloat imageH = image.size.height;
//
//            CGFloat imageWH = imageW/imageH;
//            CGFloat bigImageH = (JFA_SCREEN_WIDTH-20)*0.7-20<imageH?(JFA_SCREEN_WIDTH-20)*0.8-20:imageH;
//            CGFloat bigImageW = bigImageH* imageWH;
//
//            //手动计算cell
//            return CGSizeMake(bigImageW, bigImageH);
//        }
//    }else{
        return CGSizeMake([[dic safeObjectForKey:@"videoSizeWidht"]doubleValue], [[dic safeObjectForKey:@"videoSizeHeight"]doubleValue]);

//    }
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.currModel.movieStr.length>5) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayWithCell:)]) {
            [self.delegate didPlayWithCell:self];
        }

    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didShowBigImageWithCell:index:)]) {
            [self.delegate didShowBigImageWithCell:self index:indexPath.row];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)didClickJB:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didJBWithCell:)]) {
        [self.delegate didJBWithCell:self];
    }
    
    
}
- (IBAction)didClickHeadImage:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didTapHeadImageViewWithCell:)]) {
        [self.delegate didTapHeadImageViewWithCell:self];
    }
}
@end
