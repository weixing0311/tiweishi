//
//  HistoryHeaderView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryHeaderView.h"

@implementation HistoryHeaderView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.calendarView = [[DAYCalendarView alloc]initWithFrame:self.riView.bounds];
    [self.riView addSubview:self.calendarView];

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
