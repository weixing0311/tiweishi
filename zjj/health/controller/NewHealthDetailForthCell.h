//
//  NewHealthDetailForthCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"
@protocol NewHealthDetailFouthDelegate;
@interface NewHealthDetailForthCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * value1Label;
@property (weak, nonatomic) IBOutlet UILabel * value2Label;
@property (weak, nonatomic) IBOutlet UILabel * value3Label;
@property (weak, nonatomic) IBOutlet UILabel * value4Label;

@property (weak, nonatomic) IBOutlet UILabel *target1label;
@property (weak, nonatomic) IBOutlet UILabel *target2label;
@property (weak, nonatomic) IBOutlet UILabel *target3label;
@property (weak, nonatomic) IBOutlet UILabel *target4label;

@property (weak, nonatomic) IBOutlet UILabel *my1Label;
@property (weak, nonatomic) IBOutlet UILabel *my2Label;
@property (weak, nonatomic) IBOutlet UILabel *my3Label;
@property (weak, nonatomic) IBOutlet UILabel *my4Label;

@property (weak, nonatomic) IBOutlet UILabel *statusFatLabel;

@property (nonatomic,assign)id<NewHealthDetailFouthDelegate>delegate;
-(void)setInfoWithDict:(HealthDetailsItem *)item;
@end
@protocol NewHealthDetailFouthDelegate <NSObject>
-(void)didShareImage;
@end
