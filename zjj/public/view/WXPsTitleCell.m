//
//  WXPsTitleCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/25.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WXPsTitleCell.h"

@implementation WXPsTitleCell
{
    int zhetimeout;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.paypriceLabel.adjustsFontSizeToFitWidth = YES;
}

-(void)setTimeLabelText:(NSString *)text
{
    [self countDownWithtimeInterval:text ];
}
-(void)updateTimeInVisibleCellsWithString:(int)str{
    if (str <=0) {
        self.lastTime.text = [NSString stringWithFormat:@"付款已超时"];
    }
    else
    {
        self.lastTime.text = [NSString stringWithFormat:@"剩余时间%@",[self getNowTimeWithString:zhetimeout]];
    }
}
-(NSString *)getNowTimeWithString:(int )aTimeString{
    int  timeInterval = aTimeString;
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"活动已经结束！";
    }
    if (days) {
        return [NSString stringWithFormat:@"%@天 %@小时 %@分", dayStr,hoursStr, minutesStr];
        //        return [NSString stringWithFormat:@"%@天 %@小时 %@分 %@秒", dayStr,hoursStr, minutesStr,secondsStr];
        
    }
    return [NSString stringWithFormat:@"%@小时 %@分",hoursStr , minutesStr];
    //    return [NSString stringWithFormat:@"%@小时 %@分 %@秒",hoursStr , minutesStr,secondsStr];
    
}

-(void)countDownWithtimeInterval:(NSString *)timeInterval {
    
    zhetimeout =[timeInterval intValue]/1000 ;
    if (zhetimeout!=0) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshTimeLabel:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
-(void)refreshTimeLabel:(NSTimer *)timer
{
    
    zhetimeout--;
    if (!zhetimeout||zhetimeout<=0) {
        [_timer invalidate];
        self.lastTime.text = @"补货结束";
    }
    [self updateTimeInVisibleCellsWithString:zhetimeout];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
