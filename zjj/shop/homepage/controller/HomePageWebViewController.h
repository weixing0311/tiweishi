//
//  HomePageWebViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFABaseTableViewController.h"
@interface HomePageWebViewController : JFABaseTableViewController
@property (nonatomic, copy)NSString * urlStr;
@property (nonatomic,assign)BOOL isShare;
@property (nonatomic,copy)NSString * contentStr;
@property (nonatomic,copy)NSString * titleStr;
@property (nonatomic,copy)NSString * imageUrl;
@property (nonatomic,strong)UIProgressView * progressView;
@end
