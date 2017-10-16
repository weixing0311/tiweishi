//
//  NewHealthDetailHeaderCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"

@interface NewHealthDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknamelb;
@property (weak, nonatomic) IBOutlet UILabel *value1lb;
@property (weak, nonatomic) IBOutlet UILabel *value2lb;
-(void)setInfoWithDict:(HealthDetailsItem *)item;
@end
