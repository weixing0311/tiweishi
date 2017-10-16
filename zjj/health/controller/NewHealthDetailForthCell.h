//
//  NewHealthDetailForthCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"

@interface NewHealthDetailForthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstlb;
@property (weak, nonatomic) IBOutlet UILabel *secondlb;
@property (weak, nonatomic) IBOutlet UILabel *thirdlb;
-(void)setInfoWithDict:(HealthDetailsItem *)item;
@end
