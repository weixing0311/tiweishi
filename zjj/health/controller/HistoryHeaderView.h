//
//  HistoryHeaderView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daysquare.h"

@interface HistoryHeaderView : UIView
@property (nonatomic,strong)DAYCalendarView * calendarView;
@property (weak, nonatomic) IBOutlet UIView *riView;
@end


