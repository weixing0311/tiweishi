//
//  FriendsCircleCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol friendsCircleCellDelegate;
@interface FriendsCircleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (assign,nonatomic)id<friendsCircleCellDelegate>delegate;
-(void)setInfoWithDict:(NSDictionary *)dict;
- (IBAction)didShare:(UIButton *)sender;
@end
@protocol friendsCircleCellDelegate <NSObject>

-(void)didCheckImagesWithButton:(UIButton *)button cell:(FriendsCircleCell *)cell;
-(void)didClickShareWithCell:(FriendsCircleCell *)cell;

@end
