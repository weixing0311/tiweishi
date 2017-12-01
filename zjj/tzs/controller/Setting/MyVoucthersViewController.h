//
//  MyVoucthersViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
typedef enum {
    IS_FROM_CONFIRM =1,
    IS_FROM_TZSDG = 2,
    IS_FROM_SHOPDG =3,
    IS_FROM_MINE =4,
    IS_FROM_SHOP =5,
    IS_FROM_TZS =6,
}isFromType;
@protocol myVoucthersDelegate;
@interface MyVoucthersViewController : JFABaseTableViewController
@property (nonatomic,copy)NSString * productArr;
@property (nonatomic,assign)int pageNum;
@property (nonatomic,assign)id<myVoucthersDelegate>delegate;
@property (nonatomic,assign)isFromType myType;
@property (nonatomic,strong)NSMutableDictionary * chooseDict;
@end

@protocol myVoucthersDelegate <NSObject>
-(void)getVoucthersToUseWithId:(NSDictionary * )voucthersId;
@end
