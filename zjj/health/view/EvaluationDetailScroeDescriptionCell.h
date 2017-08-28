//
//  EvaluationDetailScroeDescriptionCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"
@interface EvaluationDetailScroeDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * bmrLabel;
@property (weak, nonatomic) IBOutlet UILabel * bodyAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;




@property (weak, nonatomic) IBOutlet UIImageView * headImageView;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * scaleResultStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView * trendArrowImageView;
@property (weak, nonatomic) IBOutlet UILabel * trendLabel;
@property (weak, nonatomic) IBOutlet UIImageView * weightBgImageView;
@property (weak, nonatomic) IBOutlet UILabel * weightLabel;
@property (weak, nonatomic) IBOutlet UILabel * weightStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel * testDateLabel;
@property (weak, nonatomic) IBOutlet UILabel * timeLabel;
-(void)setUpinfoWithItem;
@end
