//
//  BaseSservice.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseSservice : NSObject
+ (instancetype)sharedManager;
//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

-(NSString*)JFADomin;

-(id)getPostResponseSerSerializer;

-(id)getPostRequestSerializer;

-(NSURLSessionTask*)post:(NSString*)url
               paramters:(NSDictionary*)paramters
                 success:(void (^)(NSURLSessionDataTask *  task, NSDictionary *   responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *  task, NSError *  error))failure;
-(NSURLSessionTask*)post1:(NSString*)url
               paramters:(NSMutableDictionary *)paramters
                 success:(requestSuccessBlock)success
                 failure:(requestFailureBlock)failure;
-(id)getGetResponseSerSerializer;

-(id)getGetRequestSerializer;

-(NSURLSessionTask*)get:(NSString*)url
              paramters:(NSDictionary*)paramters
                success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;

-(NSURLSessionTask*)postImage:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                    imageData:(NSData *)imageData
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure;
@end
