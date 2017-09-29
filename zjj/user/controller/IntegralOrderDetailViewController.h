//
//  IntegralOrderDetailViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/25.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
@protocol orderDetailViewDelegate;

@interface IntegralOrderDetailViewController : JFABaseTableViewController

@property (nonatomic,copy)NSString * orderNo;
@property (nonatomic,assign)id<orderDetailViewDelegate>delegate;
@end
@protocol orderDetailViewDelegate <NSObject>

-(void)orderChange;

@end

