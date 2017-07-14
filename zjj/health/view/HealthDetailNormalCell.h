//
//  EvaluationDetailDatasCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"
@protocol HealthDetailNormalDelegate;
@interface HealthDetailNormalCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel * bottomLineLabel;
@property (weak, nonatomic) IBOutlet UILabel * title1Label;
@property (weak, nonatomic) IBOutlet UILabel * title2Label;
@property (weak, nonatomic) IBOutlet UILabel * title3Label;
@property (weak, nonatomic) IBOutlet UILabel * title4Label;
@property (weak, nonatomic) IBOutlet UILabel * value1Label;
@property (weak, nonatomic) IBOutlet UILabel * value2Label;
@property (weak, nonatomic) IBOutlet UILabel * value3Label;
@property (weak, nonatomic) IBOutlet UILabel * value4Label;


@property (weak, nonatomic) IBOutlet UIImageView * selectMark1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView * selectMark2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView * selectMark3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView * selectMark4ImageView;

@property (strong, nonatomic)  UITableView *tableview;
@property (nonatomic,assign)id<HealthDetailNormalDelegate>delegate;
-(void)buildTableView;

@property (nonatomic,copy)     NSString *  buttonTag;

- (IBAction)showprogress:(UIButton *)sender;

-(void)setUpWithItem:(HealthDetailsItem *)hItem;
@end
@protocol HealthDetailNormalDelegate <NSObject>

-(void)getButtonDidClickCount:(UIButton *)button withCell:(HealthDetailNormalCell*)cell;
@end
