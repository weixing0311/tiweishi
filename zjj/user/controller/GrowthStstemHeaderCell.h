//
//  GrowthStstemHeaderCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol growthHeaderCellDelegate;
@interface GrowthStstemHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *levellb;
@property (weak, nonatomic) IBOutlet UIView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *todayIntegerallb;
@property (weak, nonatomic) IBOutlet UILabel *totalIntegerallb;
@property (weak, nonatomic) IBOutlet UILabel *dayslb;
@property (weak, nonatomic) IBOutlet UIButton *qdBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)didClickRightBtn:(id)sender;


@property (nonatomic,assign)id<growthHeaderCellDelegate>delegate;
- (IBAction)didQd:(id)sender;

@end
@protocol growthHeaderCellDelegate <NSObject>
-(void)didClickQdWithCell:(GrowthStstemHeaderCell*)cell;
-(void)didShowInstructions;
@end

