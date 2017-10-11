//
//  GrowthHeader2View.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol growthHeaderDelegate;
@interface GrowthHeader2View : UIView
@property (weak, nonatomic) IBOutlet UILabel *levellb;
@property (weak, nonatomic) IBOutlet UIView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *todayIntegerallb;
@property (weak, nonatomic) IBOutlet UILabel *totalIntegerallb;
@property (weak, nonatomic) IBOutlet UILabel *dayslb;
@property (weak, nonatomic) IBOutlet UIButton *qdBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)didClickRightBtn:(id)sender;


@property (nonatomic,assign)id<growthHeaderDelegate>delegate;
- (IBAction)didQd:(id)sender;

@end
@protocol growthHeaderDelegate <NSObject>
-(void)didClickQd;
-(void)didShowInstructions;
@end
