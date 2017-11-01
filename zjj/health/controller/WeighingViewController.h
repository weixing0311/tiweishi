//
//  WeighingViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
@protocol weightingDelegate;
@interface WeighingViewController : JFABaseTableViewController
@property(nonatomic,assign)id<weightingDelegate>delegate;
@end
@protocol weightingDelegate <NSObject>

-(void)weightingSuccessWithSubtractMaxWeight:(NSString *)subtractMaxWeight dataId:(NSString *)dataId;
@end
