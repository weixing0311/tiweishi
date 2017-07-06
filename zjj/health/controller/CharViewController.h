//
//  CharViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface CharViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)didRed:(id)sender;
- (IBAction)didAdd:(id)sender;
- (IBAction)lengthSegment:(UISegmentedControl *)sender;
- (IBAction)listSegment:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UIView *superChartView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *listSegment;

@property (weak, nonatomic) IBOutlet UISegmentedControl *lenghtSegment;
@end
