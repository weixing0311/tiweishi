//
//  NewHealthDetailFivthCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"
@protocol NewHealthDetileFiveDelegate;
@interface NewHealthDetailFivthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UILabel *title3Label;
@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;
@property (weak, nonatomic) IBOutlet UILabel *status1Label;
@property (weak, nonatomic) IBOutlet UILabel *status2Label;
@property (weak, nonatomic) IBOutlet UILabel *status3Label;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerNamelb;
@property (weak, nonatomic) IBOutlet UILabel *headerValuelb;

@property (weak, nonatomic) IBOutlet UILabel *headerContentlb;

@property (weak, nonatomic) IBOutlet UILabel *sliderLislb;
@property (weak, nonatomic) IBOutlet UILabel *sliderMorlb;

@property (weak, nonatomic) IBOutlet UIImageView *sliderIconImage;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic,strong)HealthDetailsItem * currItem;
@property (nonatomic,assign)id<NewHealthDetileFiveDelegate>delegate;
-(void)setInfoWithDict:(HealthDetailsItem *)item;

@property (weak, nonatomic) IBOutlet UIView *sliderBgView;

@property (weak, nonatomic) IBOutlet UIImageView *secondHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondContent;

@property (weak, nonatomic) IBOutlet UILabel *leftlb;
@property (weak, nonatomic) IBOutlet UILabel *midlb;
@property (weak, nonatomic) IBOutlet UILabel *rightlb;
@property (weak, nonatomic) IBOutlet UIImageView *sliderBgImageView;



-(void)setDetailViewContentWithButtonIndex:(NSInteger)index;
@end

@protocol NewHealthDetileFiveDelegate <NSObject>

-(void)didClickItemWithTag:(NSInteger)index showDetail:(int)show cell:(NewHealthDetailFivthCell*)cell;

@end

