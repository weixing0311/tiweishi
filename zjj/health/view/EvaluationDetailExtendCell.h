//
//  EvaluationDetailExtendCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationDetailExtendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel  * descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel  * lowLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel  * normalLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel  * highLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel  * markHighLabel;
@property (weak, nonatomic) IBOutlet UILabel  * markLowLabel;
@property (weak, nonatomic) IBOutlet UILabel  * markBgImageView;
@end
