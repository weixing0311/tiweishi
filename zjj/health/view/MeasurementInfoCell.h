//
//  MeasurementInfoCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasurementInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightlabel;
@property (weak, nonatomic) IBOutlet UILabel *neifatLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyFatLabel;
-(void)setUpCellWithItem:(HealthItem *)item;
@end
