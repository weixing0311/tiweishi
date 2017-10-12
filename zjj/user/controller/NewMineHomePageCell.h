//
//  NewMineHomePageCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewMineHomePageHeaderCellDelegate;

@interface NewMineHomePageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknamelb;
@property (weak, nonatomic) IBOutlet UILabel *jjlb;
@property (weak, nonatomic) IBOutlet UIImageView *editjjimageview;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIButton *gzBtn;
- (IBAction)didClickGz:(id)sender;


@property (nonatomic,assign)id<NewMineHomePageHeaderCellDelegate>delegate;
@end

@protocol NewMineHomePageHeaderCellDelegate <NSObject>
-(void)didShowChangeUserInfoPage;
-(void)didChangeHeaderImage;
-(void)didShareMyInfo;
-(void)didGzUserWithCell:(NewMineHomePageCell *)cell;
-(void)changeBgImageView;
@end
