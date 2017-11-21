//
//  HistoryHeaderView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCalendarPicker.h"

@interface HistoryHeaderView : UIView
@property (nonatomic,strong)SZCalendarPicker *calendarPicker;
@property (weak, nonatomic) IBOutlet UIView *riView;
@end


