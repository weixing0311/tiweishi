//
//  IntegralOrderCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *oldpricelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UIButton *bigBtn;
- (IBAction)didClickBigBtn:(id)sender;

@end
