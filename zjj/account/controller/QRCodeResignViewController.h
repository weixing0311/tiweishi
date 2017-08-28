//
//  QRCodeResignViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/8/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JFABaseTableViewController.h"
@protocol qrcodeDelegate;
@interface QRCodeResignViewController : JFABaseTableViewController
@property (nonatomic,assign)id<qrcodeDelegate>delegate;
@end
@protocol qrcodeDelegate <NSObject>

-(void)getQrCodeInfo:(NSString * )infoStr;

@end
