//
//  GuanZViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/22.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JFABaseTableViewController.h"
typedef enum {
    IS_FUNS,
    IS_GZ,
    IS_SEARCH,
}PAGETYPE;

@interface GuanZViewController : JFABaseTableViewController
@property (nonatomic,assign)PAGETYPE pageType;
@property (nonatomic,strong)NSMutableDictionary * dict;
@end
