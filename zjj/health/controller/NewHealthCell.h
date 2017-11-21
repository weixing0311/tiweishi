//
//  NewHealthCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/5.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol newHealthCellDelegate;
@interface NewHealthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *resignTimelb;
@property (weak, nonatomic) IBOutlet UILabel *redFatlb;
@property (weak, nonatomic) IBOutlet UILabel *fatStatuslb;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;
@property (weak, nonatomic) IBOutlet UILabel *lessWeightLb;
@property (weak, nonatomic) IBOutlet UIImageView *trendArrowImageView;
@property (weak, nonatomic) IBOutlet UIView *minView;
@property (nonatomic,assign)id<newHealthCellDelegate>delegate;

#pragma mark --引导页
///1
@property (weak, nonatomic) IBOutlet UIView *guide1View;
@property (weak, nonatomic) IBOutlet UIView *Guide2View;
@property (weak, nonatomic) IBOutlet UIView *guide3View;
@property (weak, nonatomic) IBOutlet UIButton *next1btn;
@property (weak, nonatomic) IBOutlet UIButton *next2btn;
@property (weak, nonatomic) IBOutlet UIButton *next3btn;

- (IBAction)didClickNext:(id)sender;
- (IBAction)didStop:(id)sender;
- (IBAction)didFinish:(id)sender;
-(void)refreshPageInfoWithItem:(HealthItem*)item;
@end
@protocol newHealthCellDelegate <NSObject>
-(void)didShowUserList;
-(void)didShowSHuoming;
-(void)didWeighting;
-(void)didEnterDetailVC;
-(void)didEnterRightVC;


@end
