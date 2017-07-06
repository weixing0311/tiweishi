//
//  JFASubNetWorkErrorView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol subNetWorkDelegate <NSObject>
-(void)didRefreshInfo;
@end

@interface JFASubNetWorkErrorView : UIView
@property (nonatomic, assign)id<subNetWorkDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame bgimage:(UIImage*)bgimage;
@end
