//
//  NSDate+CustomDate.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NSDate+CustomDate.h"

@implementation NSDate (CustomDate)
-(NSString*)yyyymmddhhmmss
{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *string= [outputFormatter stringFromDate:self];
    return string;
}
-(NSString*)mmddhhmm
{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"MM月dd日 hh:mm:ss"];
    NSString *string= [outputFormatter stringFromDate:self];
    return string;
}
-(NSString *)yyyymmdd
{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string= [outputFormatter stringFromDate:self];
    return string;

}
-(NSString*)mmdd
{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"MM月dd日"];
    NSString *string= [outputFormatter stringFromDate:self];
    return string;
}

@end
