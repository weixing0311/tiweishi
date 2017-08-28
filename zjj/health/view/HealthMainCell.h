//
//  HealthMainCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import <CoreBluetooth/CoreBluetooth.h>
@protocol healthMainDelegate;
@interface HealthMainCell : UITableViewCell<CBCentralManagerDelegate>

@property (weak, nonatomic) IBOutlet  UIButton     *   scaleButton;
@property (weak, nonatomic) IBOutlet  UIButton     *   shareButton;

@property (weak, nonatomic) IBOutlet  UIButton     *   weightBgButton;
@property (weak, nonatomic) IBOutlet  UIImageView  *   weightBgImageView;
@property (weak, nonatomic) IBOutlet  UILabel      *   weightLabel;
@property (weak, nonatomic) IBOutlet  UILabel      *   trendLabel;
@property (weak, nonatomic) IBOutlet  UILabel      *   visceralFatWeightLabel;
@property (weak, nonatomic) IBOutlet  UILabel      *   fatWeight;  // 体脂重

@property (weak, nonatomic) IBOutlet  UILabel      *   agelabel;
@property (weak, nonatomic) IBOutlet  UILabel      *   heightLabel;
@property (weak, nonatomic) IBOutlet  UILabel      *   lineLabel;

@property (weak, nonatomic) IBOutlet UILabel      *   bmrLabel;
@property (weak, nonatomic) IBOutlet UILabel      *   bmrAgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *emptyInfoLabel;

@property (weak, nonatomic) IBOutlet  UIImageView  *   dangerTipImageView;
@property (weak, nonatomic) IBOutlet  UILabel      *   dangerTipLabel;

@property (weak, nonatomic) IBOutlet  UILabel      *   warningTipLabel;
@property (weak, nonatomic) IBOutlet  UIImageView  *   warningTipImageView;

@property (weak, nonatomic) IBOutlet  UILabel      *   timeLabel;

@property (weak, nonatomic) IBOutlet  UIImageView  *   trendArrowImageView;



@property (weak, nonatomic) IBOutlet UILabel * title1Label;
@property (weak, nonatomic) IBOutlet UILabel * title2Label;
@property (weak, nonatomic) IBOutlet UILabel * title3Label;
@property (weak, nonatomic) IBOutlet UILabel * title4Label;
@property (weak, nonatomic) IBOutlet UILabel * value1Label;
@property (weak, nonatomic) IBOutlet UILabel * value2Label;
@property (weak, nonatomic) IBOutlet UILabel * value3Label;
@property (weak, nonatomic) IBOutlet UILabel * value4Label;

@property (weak, nonatomic) IBOutlet UILabel *target1label;
@property (weak, nonatomic) IBOutlet UILabel *target2label;
@property (weak, nonatomic) IBOutlet UILabel *target3label;
@property (weak, nonatomic) IBOutlet UILabel *target4label;






//@property (weak, nonatomic) IBOutlet  LineChart      *    chartView;
@property (weak, nonatomic) IBOutlet UIButton *enterChart;
- (IBAction)didEnterChart:(id)sender;

@property (nonatomic,assign)id<healthMainDelegate>delegate;
- (IBAction)didScale:(id)sender;

- (IBAction)showWeight:(id)sender;

- (IBAction)didShare:(id)sender;


-(void)setUpInfo:(HealthItem*)item;

-(void)clearView;



@end
@protocol healthMainDelegate <NSObject>

-(void)didUpdateinfo;
-(void)didShare;
-(void)enterDetailView;
-(void)didEnterChart;

@end
