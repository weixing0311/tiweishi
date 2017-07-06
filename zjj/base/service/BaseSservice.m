//
//  BaseSservice.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BaseSservice.h"
#import "AppDelegate.h"
#import "LoignViewController.h"

@implementation BaseSservice
{
    AFHTTPSessionManager* manager;
}
+ (instancetype)sharedManager {
    static BaseSservice *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 请求超时设定
        manager=[AFHTTPSessionManager manager];
        manager.responseSerializer=[self getPostResponseSerSerializer];
        manager.requestSerializer=[self getPostRequestSerializer];

        manager.requestSerializer.timeoutInterval = 5;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}
-(NSString*)JFADomin
{
    //测试域名
    return @"http://192.168.0.130:8101/";
    //x
//    return @"http://192.168.0.115:8080/";
}

-(id)getPostResponseSerSerializer
{
    return [AFHTTPResponseSerializer serializer];
}

-(id)getPostRequestSerializer
{
    return [AFHTTPRequestSerializer serializer];
}


-(NSURLSessionTask*)post:(NSString*)url
               paramters:(NSDictionary*)paramters
                 success:(void (^)(NSURLSessionDataTask *  task, NSDictionary *  responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *  error))failure
{
    
    
    NSURLSessionTask * task = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        DLog(@"%@--%@",dic ,[dic objectForKey:@"message"]);
        int  code = [[dic objectForKey:@"code"]intValue];
        if (code ==601) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kdidReLoign object:nil];
        }
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    return task;
}
-(NSURLSessionTask*)post1:(NSString*)url
               paramters:(NSMutableDictionary *)paramters
                 success:(requestSuccessBlock)success
                 failure:(requestFailureBlock)failure
{
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];
    DLog(@"request.Url-%@",[NSString stringWithFormat:@"%@%@",[self JFADomin],url]);
    
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate showHUD:hotwheels message:@"加载中.." detai:nil Hdden:NO];
    
    
    NSURLSessionTask * task = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate hiddenHUD];
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        int  code =[[dic safeObjectForKey:@"code"]intValue];
        DLog(@"%@--%@--%@",dic ,[dic objectForKey:@"code"],[dic objectForKey:@"message"]);
       
        
        if (code  ==601) {
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
            
        }else{

        
        if (statusStr&&[statusStr isEqualToString:@"success"]) {
            success(dic);
        }else{
            
            NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
            failure(error);
        }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate hiddenHUD];
        failure(error);
    }];
    return task;
}

-(NSURLSessionTask*)postImage:(NSString*)url
                paramters:(NSMutableDictionary *)paramters
                imageData:(NSData *)imageData
                  success:(requestSuccessBlock)success
                  failure:(requestFailureBlock)failure
{
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];

    
    NSURLSessionTask * task =[manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"headimgurl" fileName:@"headimgurl.png" mimeType:@"image/png"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"上传进度--%@",uploadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        DLog(@"%@--%@",dic ,[dic objectForKey:@"message"]);
        
        if (statusStr&&[statusStr isEqualToString:@"success"]) {
            success(dic);
        }else{
            
            NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
            failure(error);
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);

    }];
    
    return task;
}
-(id)getGetResponseSerSerializer
{
    return [AFHTTPResponseSerializer serializer];
}

-(id)getGetRequestSerializer
{
    return [AFHTTPRequestSerializer serializer];
}

-(NSURLSessionTask*)get:(NSString*)url
              paramters:(NSDictionary*)paramters
                success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    
    
    NSURLSessionTask* operation = [manager GET:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters success:^(NSURLSessionTask *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(operation,error);
    }];
    
    return operation;
}
- (NSDictionary *)dictionaryWithData:(NSData*)data {
    
    if (!data) {
        return nil;
    }
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
@end
