//
//  TZSDistributionDetailViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
@protocol distributionDetailDelegate;
@interface TZSDistributionDetailViewController : JFABaseTableViewController
@property (nonatomic,copy)NSString * orderNo;
@property (nonatomic,assign)id<distributionDetailDelegate>delegate;
@end
@protocol  distributionDetailDelegate <NSObject>

-(void)distributionOrderChange;

@end
