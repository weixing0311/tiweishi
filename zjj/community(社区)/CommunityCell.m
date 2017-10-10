//
//  CommunityCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommunityCell.h"
#import "PublicCollImageCell.h"
@implementation CommunityCell
{
    CGSize  videoSize;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imagesArray = [NSMutableArray array];
    videoSize = CGSizeMake((JFA_SCREEN_WIDTH-20)/4-20, (JFA_SCREEN_WIDTH-20)/4-20);
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;//实现数据源方法
    self.collectionView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH-40, (JFA_SCREEN_WIDTH-40)*0.7);
//    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    [self.imagesView addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PublicCollImageCell"bundle:nil]forCellWithReuseIdentifier:@"PublicCollImageCell"];


}
-(void)setInfoWithDict:(CommunityModel *)item
{
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
        [self.imagesArray removeAllObjects];
        [self.imagesArray addObject:item.movieImageStr];
    }else{
        self.playerBtn.hidden = YES;
        self.imagesArray = item.pictures;
    }
    [self.collectionView reloadData];
}

#pragma mark ----collectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DLog(@"%d",self.imagesArray.count);
    return self.imagesArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublicCollImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublicCollImageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    [cell.headerImageView sd_setImageWithURL:[_imagesArray objectAtIndex:indexPath.row] placeholderImage:getImage(@"default") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.headerImageView.image = image;
        if (self.currModel.pictures.count ==1) {
            videoSize = image.size;
            [self.collectionView reloadData];
        }
    }];
    
    return cell;
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.currModel.movieStr.length>5) {
        return videoSize;

//        return CGSizeMake((JFA_SCREEN_WIDTH-20), (JFA_SCREEN_WIDTH-20)/2*0.7);
        
    }else{
        if (self.currModel.pictures.count==1) {
            return videoSize;
        }else{
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/3-20, (JFA_SCREEN_WIDTH-20)/3-20);
        }
    }
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.currModel.movieStr.length>5) {
        
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
