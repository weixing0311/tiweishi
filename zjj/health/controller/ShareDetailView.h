//
//  ShareDataDetailView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"
#import "HealthModel.h"

@interface ShareDetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknamelb;
@property (weak, nonatomic) IBOutlet UILabel *heightlb;
@property (weak, nonatomic) IBOutlet UILabel *bodylb;
@property (weak, nonatomic) IBOutlet UILabel *agelb;
@property (weak, nonatomic) IBOutlet UILabel *bodyAgelb;
@property (weak, nonatomic) IBOutlet UILabel *scorelb;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UILabel *bglb;
@property (weak, nonatomic) IBOutlet UILabel *tclb;
@property (weak, nonatomic) IBOutlet UILabel *value1lb;
@property (weak, nonatomic) IBOutlet UILabel *value2lb;
@property (weak, nonatomic) IBOutlet UILabel *value3lb;
@property (weak, nonatomic) IBOutlet UILabel *value4lb;
@property (weak, nonatomic) IBOutlet UILabel *value5lb;
@property (weak, nonatomic) IBOutlet UILabel *value6lb;
@property (weak, nonatomic) IBOutlet UILabel *value7lb;
@property (weak, nonatomic) IBOutlet UILabel *value8lb;
@property (weak, nonatomic) IBOutlet UILabel *value9lb;

@property (weak, nonatomic) IBOutlet UILabel *status1lb;
@property (weak, nonatomic) IBOutlet UILabel *status2lb;
@property (weak, nonatomic) IBOutlet UILabel *status3lb;
@property (weak, nonatomic) IBOutlet UILabel *status4lb;
@property (weak, nonatomic) IBOutlet UILabel *status5lb;
@property (weak, nonatomic) IBOutlet UILabel *status6lb;
@property (weak, nonatomic) IBOutlet UILabel *status7lb;
@property (weak, nonatomic) IBOutlet UILabel *status8lb;
@property (weak, nonatomic) IBOutlet UILabel *status9lb;
@property (weak, nonatomic) IBOutlet UIImageView *recodeImageView;
-(void)setInfoWithItem:(HealthDetailsItem *)item;

@end
