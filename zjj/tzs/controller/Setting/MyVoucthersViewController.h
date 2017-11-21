//
//  MyVoucthersViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@protocol myVoucthersDelegate;
@interface MyVoucthersViewController : JFABaseTableViewController
@property (nonatomic,copy)NSString * productArr;
@property (nonatomic,assign)BOOL isFromOrder;
@property (nonatomic,assign)id<myVoucthersDelegate>delegate;
@end

@protocol myVoucthersDelegate <NSObject>
-(void)getVoucthersToUseWithId:(NSDictionary * )voucthersId;
@end
