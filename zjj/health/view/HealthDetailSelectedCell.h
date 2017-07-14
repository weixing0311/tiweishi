//
//  EvaluationDetailDatasCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"
@protocol healthDetailCellDelegate;
@interface HealthDetailSelectedCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel * bottomLineLabel;
@property (weak, nonatomic) IBOutlet UILabel * title1Label;
@property (weak, nonatomic) IBOutlet UILabel * title2Label;
@property (weak, nonatomic) IBOutlet UILabel * title3Label;
@property (weak, nonatomic) IBOutlet UILabel * title4Label;
@property (weak, nonatomic) IBOutlet UILabel * value1Label;
@property (weak, nonatomic) IBOutlet UILabel * value2Label;
@property (weak, nonatomic) IBOutlet UILabel * value3Label;
@property (weak, nonatomic) IBOutlet UILabel * value4Label;


@property (weak, nonatomic) IBOutlet UIImageView * selectMark1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView * selectMark2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView * selectMark3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView * selectMark4ImageView;


@property (weak, nonatomic) IBOutlet UILabel  * lowLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel  * normalLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel  * highLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel  * markHighLabel;
@property (weak, nonatomic) IBOutlet UILabel  * markLowLabel;
@property (weak, nonatomic) IBOutlet UIImageView  * markBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *markIcon;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;




@property (nonatomic,assign)id<healthDetailCellDelegate>delegate;
-(void)buildTableView;

@property (nonatomic,copy)     NSString *  buttonTag;

- (IBAction)showprogress:(UIButton *)sender;
-(void)setSliderInfoWithdict:(NSMutableDictionary *)dict;
-(void)setUpWithItem:(HealthDetailsItem *)hItem;
@end
@protocol healthDetailCellDelegate <NSObject>

-(void)getBtnDidClickCount:(UIButton *)button withCell:(HealthDetailSelectedCell*)cell;
@end
