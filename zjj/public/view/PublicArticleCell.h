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
@interface PublicArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleIb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *plbtn;
@property (weak, nonatomic) IBOutlet UIButton *zanbtn;
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;
@property (weak, nonatomic) IBOutlet UIButton *gzBtn;
@property (nonatomic,strong)CommunityModel * currModel;

@property (nonatomic,assign)id<PublicArticleCellDelegate>delegate;
-(void)setInfoWithDict:(CommunityModel *)item;
- (CGFloat)cellOffset;
@end

@protocol PublicArticleCellDelegate <NSObject>
-(void)refreshCellRowHeightWithCell:(PublicArticleCell*)cell height:(double)height;
-(void)didPlayWithCell:(PublicArticleCell *)cell;
-(void)didGzWithCell:(PublicArticleCell*)cell;
-(void)didZanWithCell:(PublicArticleCell*)cell;
-(void)didPLWithCell:(PublicArticleCell*)cell;
-(void)didShareWithCell:(PublicArticleCell*)cell;


@end
