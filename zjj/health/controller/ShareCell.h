//
//  ShareCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareHealthItem.h"
@interface ShareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)didChoose:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightlabel;
@property (weak, nonatomic) IBOutlet UILabel *neifatLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyFatLabel;
-(void)setUpCellWithItem:(ShareHealthItem *)item;

@end
