//
//  PublicArticleCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityModel.h"
#import <MediaPlayer/MediaPlayer.h>
@protocol PublicArticleCellDelegate;
@interface PublicArticleCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
///头像
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
///昵称
@property (weak, nonatomic) IBOutlet UILabel *titleIb;
///发表时间
@property (weak, nonatomic) IBOutlet UILabel *timelb;
///内容
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
///分享button
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
///评论button
@property (weak, nonatomic) IBOutlet UIButton *plbtn;
///点赞imageView
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
///点赞button
@property (weak, nonatomic) IBOutlet UIButton *zanbtn;
///举报button
@property (weak, nonatomic) IBOutlet UIButton *jbBtn;
///关注button
@property (weak, nonatomic) IBOutlet UIButton *gzBtn;
///点赞数量label
@property (weak, nonatomic) IBOutlet UILabel *zanCountlb;
///记录评论数
@property (weak, nonatomic) IBOutlet UILabel *commentCountlb;
///数据集合
@property (nonatomic,strong)CommunityModel * currModel;
///记录分享数
@property (weak, nonatomic) IBOutlet UILabel *shareCountlb;
///下方bottom条
@property (weak, nonatomic) IBOutlet UIView *nemuView;
///图片集合
@property (nonatomic,strong)NSMutableArray * imagesArray;
///等级label
@property (weak, nonatomic) IBOutlet UILabel *levelLb;



///点击头像事件
- (IBAction)didClickHeadImage:(id)sender;
///点击举报事件
- (IBAction)didClickJB:(id)sender;



@property (nonatomic,assign)id<PublicArticleCellDelegate>delegate;
///接收数据
-(void)setInfoWithDict:(CommunityModel *)item;
///接收图片方法
-(void)loadImagesWithItem:(CommunityModel *)item;



- (CGFloat)cellOffset;
@end

@protocol PublicArticleCellDelegate <NSObject>
///刷新高度
-(void)refreshCellRowHeightWithCell:(PublicArticleCell*)cell height:(double)height;
///关注delegate
-(void)didGzWithCell:(PublicArticleCell*)cell;
///--delegate--点赞
-(void)didZanWithCell:(PublicArticleCell*)cell;
///--delegate--评论
-(void)didPLWithCell:(PublicArticleCell*)cell;
///--delegate--分享
-(void)didShareWithCell:(PublicArticleCell*)cell;
///--delegate--显示大图
-(void)didShowBigImageWithCell:(PublicArticleCell*)cell index:(NSInteger)index;
///--delegate--举报
-(void)didJBWithCell:(PublicArticleCell *)cell;
///--delegate--加载成功
-(void)loadImageSuccessWithCell:(PublicArticleCell *)cell;
///--delegate--点击头像
-(void)didTapHeadImageViewWithCell:(PublicArticleCell *)cell;
@end
