//
//  BeforeAfterContrastCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeforeAfterContrastCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *continuousDatelb;//连续多少天
@property (weak, nonatomic) IBOutlet UILabel *beforeWeightlb;
@property (weak, nonatomic) IBOutlet UILabel *afterweightlb;
@property (weak, nonatomic) IBOutlet UILabel *lossWeightlb;

@end
