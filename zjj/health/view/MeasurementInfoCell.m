//
//  MeasurementInfoCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MeasurementInfoCell.h"

@implementation MeasurementInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setUpCellWithItem:(HealthItem *)item
{
    self.dateLabel.   text = [self getDateWithString:item.createTime];
    self.timeLabel.   text = [self getTimeWithString:item.createTime];
    self.weightlabel. text = [NSString stringWithFormat:@"%.1fkg",item.weight];
    self.neifatLabel. text = [NSString stringWithFormat:@"%.1f",item.visceralFatPercentage];
    self.bodyFatLabel.text = [NSString stringWithFormat:@"%.1f",item.fatWeight];
}

-(NSString *)getDateWithString:(NSString *)str
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"MM月dd日"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
}
-(void)getweekWithString:(NSString *)str
{
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:inputDate];
}
-(NSString *)getTimeWithString:(NSString *)str
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"hh:mm"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
