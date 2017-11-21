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
    self.topLabel.layer.borderWidth= 1;
    self.topLabel.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;

    
    
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
//    if (self.gzBtn.selected == YES) {
//        return;
//    }
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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.headurl] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
    
    self.titleIb.text = item.title;
    
    NSString * str = item.content;
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    self.contentlb.text      = str;
    self.timelb.text         = item.releaseTime;
    self.zanCountlb.text     = item.greatnum;
    self.commentCountlb.text = item.commentnum;
//    self.shareCountlb.text   = item.forwardingnum;
    self.levelLb.text        = item.level;
    if (item.isFabulous&&[item.isFabulous isEqualToString:@"1"]) {
        
        self.zanImageView.image = getImage(@"praise_Selected");
        
    }else{
        self.zanImageView.image = getImage(@"praise");
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
    
}
-(void)loadImagesWithItem:(CommunityModel *)item
{
    [self.imagesArray removeAllObjects];
    for (NSString * imageStr in item.pictures) {
        NSMutableDictionary * dict =[NSMutableDictionary dictionary];
        [dict safeSetObject:imageStr forKey:@"videoImageStr"];
        if (item.pictures.count ==4) {
            [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/2-20) forKey:@"videoSizeWidht"];
            [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/2-20) forKey:@"videoSizeHeight"];
        }
        else
        {
            [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/3-10) forKey:@"videoSizeWidht"];
            [dict safeSetObject:@((JFA_SCREEN_WIDTH-20)/3-10) forKey:@"videoSizeHeight"];
        }
        [self.imagesArray addObject:dict];
    }
    
    if (!_imagesArray|| _imagesArray.count==0) {
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
    }
    [self.collectionView reloadData];
}




//裁剪图片



#pragma mark ----collectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(5,10, 5, 10);//分别为上、左、下、右

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublicCollImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublicCollImageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSMutableDictionary * dict = [_imagesArray objectAtIndex:indexPath.row];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"videoImageStr"]] placeholderImage:getImage(@"default")options:SDWebImageRetryFailed];
    
    return cell;
}


//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [_imagesArray objectAtIndex:indexPath.row];
    return CGSizeMake([[dic safeObjectForKey:@"videoSizeWidht"]doubleValue], [[dic safeObjectForKey:@"videoSizeHeight"]doubleValue]);
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(didShowBigImageWithCell:index:)]) {
            [self.delegate didShowBigImageWithCell:self index:indexPath.row];
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
