//
//  NewHealthDetailThirdCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDetailsItem.h"

@protocol NewHealthDetailThirdDelegate;


@interface NewHealthDetailThirdCell : UITableViewCell
@property (nonatomic,assign)id<NewHealthDetailThirdDelegate>delegate;
-(void)setInfoWithDict:(HealthDetailsItem *)item;
@end



@protocol NewHealthDetailThirdDelegate <NSObject>
-(void)didShareImage;
@end
