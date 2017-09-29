//
//  CommunityViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface CommunityViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)didClickSegment:(UISegmentedControl *)sender;

@end
