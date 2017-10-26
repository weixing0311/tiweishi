//
//  CommunityCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/29.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityModel.h"
@protocol BigImageArticleCellDelegate;
@interface CommunityCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray * imagesArray;
-(void)setInfoWithDict:(CommunityModel *)item;
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleIb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *plbtn;
@property (weak, nonatomic) IBOutlet UIButton *zanbtn;
@property (weak, nonatomic) IBOutlet UIButton *gzBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *zhezhaoceng;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;


@property (nonatomic,strong)CommunityModel * currModel;
@property (nonatomic,assign)id<BigImageArticleCellDelegate>delegate;


@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;

@property (weak, nonatomic) IBOutlet UIButton *jbBtn;

@property (weak, nonatomic) IBOutlet UILabel *zanCountlb;
@property (weak, nonatomic) IBOutlet UILabel *commentCountlb;
@property (weak, nonatomic) IBOutlet UILabel *shareCountlb;

@property (weak, nonatomic) IBOutlet UIView *nemuView;

@property (weak, nonatomic) IBOutlet UIView *playerBgView;


@end

@protocol BigImageArticleCellDelegate <NSObject>
-(void)refreshCellRowHeightWithBigCell:(CommunityCell*)cell height:(double)height;
-(void)didPlayWithBigCell:(CommunityCell *)cell;
-(void)didGzWithBigCell:(CommunityCell*)cell;
-(void)didZanWithBigCell:(CommunityCell*)cell;
-(void)didPLWithBigCell:(CommunityCell*)cell;
-(void)didShareWithBigCell:(CommunityCell*)cell;
-(void)didShowBigImageWithBigCell:(CommunityCell*)cell index:(NSInteger)index;
-(void)didJBWithBigCell:(CommunityCell *)cell;
-(void)loadImageSuccessWithBigCell:(CommunityCell *)cell;
-(void)didTapHeadImageViewWithBigCell:(CommunityCell *)cell;
@end

