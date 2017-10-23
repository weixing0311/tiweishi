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
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleIb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *plbtn;

@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;

@property (weak, nonatomic) IBOutlet UIButton *zanbtn;
@property (weak, nonatomic) IBOutlet UIButton *jbBtn;

@property (weak, nonatomic) IBOutlet UIButton *gzBtn;

- (IBAction)didClickJB:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *zanCountlb;
@property (weak, nonatomic) IBOutlet UILabel *commentCountlb;
@property (nonatomic,strong)CommunityModel * currModel;
@property (weak, nonatomic) IBOutlet UILabel *shareCountlb;

@property (weak, nonatomic) IBOutlet UIView *nemuView;
@property (nonatomic,strong)NSMutableArray * imagesArray;


- (IBAction)didClickHeadImage:(id)sender;



@property (nonatomic,assign)id<PublicArticleCellDelegate>delegate;
-(void)setInfoWithDict:(CommunityModel *)item;
-(void)loadImagesWithItem:(CommunityModel *)item;
- (CGFloat)cellOffset;
@end

@protocol PublicArticleCellDelegate <NSObject>
-(void)refreshCellRowHeightWithCell:(PublicArticleCell*)cell height:(double)height;
-(void)didPlayWithCell:(PublicArticleCell *)cell;
-(void)didGzWithCell:(PublicArticleCell*)cell;
-(void)didZanWithCell:(PublicArticleCell*)cell;
-(void)didPLWithCell:(PublicArticleCell*)cell;
-(void)didShareWithCell:(PublicArticleCell*)cell;
-(void)didShowBigImageWithCell:(PublicArticleCell*)cell index:(int)index;
-(void)didJBWithCell:(PublicArticleCell *)cell;
-(void)loadImageSuccessWithCell:(PublicArticleCell *)cell;
-(void)didTapHeadImageViewWithCell:(PublicArticleCell *)cell;
@end
