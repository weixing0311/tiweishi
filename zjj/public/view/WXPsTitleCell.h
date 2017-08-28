//
//  WXPsTitleCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/25.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXPsTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *payTsView;
@property (weak, nonatomic) IBOutlet UILabel *paypriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tsImage;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
@property(nonatomic,retain) NSTimer * timer;
-(void)setTimeLabelText:(NSString *)text;
@end
