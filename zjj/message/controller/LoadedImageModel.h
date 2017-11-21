//
//  LoadedImageModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadedImageModel : NSObject
+(LoadedImageModel *)shareInstance;
@property (nonatomic,copy)NSString * releaseTime;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSMutableArray * pictures;
@property (nonatomic,copy)NSString * isRelease;
@property (nonatomic,copy)NSString * shareNum;
@property (nonatomic,copy)NSString * movieStr;
@property (nonatomic,assign)float  rowHieght;
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
