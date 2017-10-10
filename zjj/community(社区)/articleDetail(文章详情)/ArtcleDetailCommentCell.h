//
//  ArtcleDetailCommentCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ArtcleDetailCommentDelegate;

@interface ArtcleDetailCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *nicknamelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UILabel *zanCountlb;




@property (nonatomic,assign)id<ArtcleDetailCommentDelegate>delegate;
@end
@protocol ArtcleDetailCommentDelegate <NSObject>
-(void)didZanCommentWithCell:(ArtcleDetailCommentCell*)cell;
@end
