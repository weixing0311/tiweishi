//
//  HistoryCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol historyCellDelegate;
@interface HistoryCell : UITableViewCell
@property (nonatomic,assign) id<historyCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;
@property (weak, nonatomic) IBOutlet UILabel *tzlLb;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (weak, nonatomic) IBOutlet UILabel *value1lb;

@property (weak, nonatomic) IBOutlet UILabel *value2lb;

@property (weak, nonatomic) IBOutlet UILabel *value3lb;
@property (weak, nonatomic) IBOutlet UILabel *second3Lb;

@property (weak, nonatomic) IBOutlet UILabel *value4lb;

@property (weak, nonatomic) IBOutlet UILabel *value5lb;
@property (weak, nonatomic) IBOutlet UILabel *second5Lb;

@property (weak, nonatomic) IBOutlet UILabel *value6lb;
@property (weak, nonatomic) IBOutlet UILabel *second6Lb;

@property (weak, nonatomic) IBOutlet UILabel *value7lb;
@property (weak, nonatomic) IBOutlet UILabel *second7Lb;

@property (weak, nonatomic) IBOutlet UILabel *value8lb;
@property (weak, nonatomic) IBOutlet UILabel *second8Lb;

@property (weak, nonatomic) IBOutlet UILabel *value9lb;
@property (weak, nonatomic) IBOutlet UILabel *second9Lb;

@property (weak, nonatomic) IBOutlet UILabel *value10lb;
@property (weak, nonatomic) IBOutlet UILabel *second10Lb;

@property (weak, nonatomic) IBOutlet UILabel *value11lb;
@property (weak, nonatomic) IBOutlet UILabel *second11Lb;

@property (weak, nonatomic) IBOutlet UILabel *value12lb;
@property (weak, nonatomic) IBOutlet UILabel *second12Lb;

@property (weak, nonatomic) IBOutlet UILabel *value13lb;

-(void)setInfoWithDict:(NSDictionary *)infoDict isHidden:(BOOL)isHidden;

@end
@protocol historyCellDelegate <NSObject>
-(void)showCellTabWithCell:(HistoryCell*)cell;
-(void)didChooseWithCell:(HistoryCell *)cell;
@end
