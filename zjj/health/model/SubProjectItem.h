//
//  SubProjectItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubProjectItem : NSObject
+(SubProjectItem *)shareInstance;
@property (nonatomic,copy  )NSString * shareText;
@property (nonatomic,strong)UIColor  * healthColor;
@property (nonatomic,copy  )NSString * DetailText;
//@property (nonatomic,copy  )NSString * 
@end
