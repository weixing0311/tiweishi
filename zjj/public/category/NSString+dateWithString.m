//
//  NSString+dateWithString.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NSString+dateWithString.h"
#import "NSDate+CustomDate.h"
@implementation NSString (dateWithString)
-(NSString*)yyyymmdd
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:self];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
}



-(NSString*)mmdd
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:self];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"MM-dd"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
}
-(NSString*)mmddhhmm
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:self];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"MM月dd日 HH:mm:ss"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
}



-(NSString *)getdateCount
{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSDate *  date = [dateFormatter dateFromString:self];
    NSString * str = [dateFormatter stringFromDate:date];
    return str;

}
-(NSString *)getDateAndMonthWithString:(NSString *)str
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"MM月dd日"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
}

-(NSString *)getDateWithString:(NSString *)str
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"dd"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
}




-(void)getweekWithString:(NSString *)str
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
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
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"hh:mm"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
    
}

-(NSDate *)dateyyyymmddhhmmss
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:self];
    return inputDate;
}



+(NSString *)getNowTimeWithString:(NSString *)aTimeString{

    
    int timeInterval = [aTimeString intValue]/1000;
    
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
        return [NSString stringWithFormat:@"%@天 %@小时 %@分 %@秒", dayStr,hoursStr, minutesStr,secondsStr];
    }
    return [NSString stringWithFormat:@"%@小时 %@分 %@秒",hoursStr , minutesStr,secondsStr];
}
- (NSString *) compareCurrentTime
{
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:self];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
//    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        int currHours = [[[NSDate date]HH] intValue];
        if (temp>currHours) {
            result = [self yyyymmdd];
        }else{
            result = [NSString stringWithFormat:@"%ld小时前",temp];
        }
    }
    
    else if((temp = temp/24) <30){
        result = [self yyyymmdd];
//        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [self yyyymmdd];

//        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        result = [self yyyymmdd];

//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

@end
