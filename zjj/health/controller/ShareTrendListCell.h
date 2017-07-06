//
//  ShareTrendCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTrendListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView * value2TrendImageView;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * value1Label;
@property (weak, nonatomic) IBOutlet UILabel * value2Label;
@property (weak, nonatomic) IBOutlet UILabel * value1StatusLabel;
@property (weak, nonatomic) IBOutlet UILabel * value2StatusLabel;
@property (weak, nonatomic) IBOutlet UIView  * value1StatusBgView;
@property (weak, nonatomic) IBOutlet UIView  * value2StatusBgView;
@end
