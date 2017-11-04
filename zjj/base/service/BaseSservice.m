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

        manager.requestSerializer.timeoutInterval = 30;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        manager.securityPolicy.allowInvalidCertificates = NO;
    }
    return self;
}
-(NSString*)JFADomin
{
    return kMyBaseUrl;
}

-(id)getPostResponseSerSerializer
{
    return [AFHTTPResponseSerializer serializer];
}

-(id)getPostRequestSerializer
{
    return [AFHTTPRequestSerializer serializer];
}


-(NSURLSessionTask*)postDebugWithUrl:(NSString*)url
               paramters:(NSDictionary*)paramters
{
    
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];
    DLog(@"request.Url-%@",[NSString stringWithFormat:@"%@%@",[self JFADomin],url]);
    DLog(@"Debug蓝牙上传message:%@",paramters);
    NSURLSessionTask * task = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"Debug蓝牙数据上传成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"Debug蓝牙数据上传失败:%@",error);

    }];
    return task;

}

-(NSURLSessionTask*)post1:(NSString*)url
           HiddenProgress:(BOOL)isHidden
               paramters:(NSMutableDictionary *)paramters
                 success:(requestSuccessBlock)success
                 failure:(requestFailureBlock)failure
{
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];
    DLog(@"request.Url-%@",[NSString stringWithFormat:@"%@%@",[self JFADomin],url]);
    
    ///去除连接中的空行
     url= [url stringByReplacingOccurrencesOfString:@" " withString:@""];

    
//    [SVProgressHUD show];
    
    NSURLSessionTask * task = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        int  code =[[dic safeObjectForKey:@"code"]intValue];
        DLog(@"%@--%@--%@",dic ,[dic objectForKey:@"code"],[dic objectForKey:@"message"]);
       
        
        if (code  ==601) {//登录失效
            [SVProgressHUD dismiss];
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
        }else{
            if (code==602) {//登录失效
                [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
                
            }else{
                
                if (statusStr&&[statusStr isEqualToString:@"success"]) {
                    success(dic);
                }else{
                    [SVProgressHUD dismiss];
                    if (isHidden==YES) {
                        
                    }else{
                        [[UserModel shareInstance] showInfoWithStatus:[dic objectForKey:@"message"]];

                    }
                    NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
                    
                    failure(error);
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        
        DLog(@"error--%ld-%@",(long)error.code,[error.userInfo safeObjectForKey:@"NSLocalizedDescription"]);

        if ([error code] ==-1009) {
            [[UserModel shareInstance] showInfoWithStatus:@"连接失败，请检查网络"];
            
//            return ;
        }
        
        if ([error code] ==-1001) {
            [[UserModel shareInstance] showInfoWithStatus:@"连接失败，请检查网络"];
//            return;
        }
        if ([error code]==-1011) {
            [[UserModel shareInstance]showInfoWithStatus:@"页面丢失--404"];
        }
        failure(error);
    }];    return task;
}

-(NSURLSessionTask*)postImage:(NSString*)url
                paramters:(NSMutableDictionary *)paramters
                    imageData:(NSData *)imageData
                    imageName:(NSString *)imageName//@"headimgurl.png"
                  success:(requestSuccessBlock)success
                  failure:(requestFailureBlock)failure
{
    if (!manager) {
        manager =[AFHTTPSessionManager manager];
    }
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];

    [SVProgressHUD show];
    
    NSURLSessionTask * task =[manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData&&imageData.length>1) {
            [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"%@.png",imageName] mimeType:@"image/png"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        [SVProgressHUD showProgress:uploadProgress.localizedDescription status:@"Loading"];

        DLog(@"上传进度--%@",uploadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [SVProgressHUD dismiss];
        
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        DLog(@"%@--%@",dic ,[dic objectForKey:@"message"]);
        int  code =[[dic safeObjectForKey:@"code"]intValue];

        
        if (code  ==601) {//登录失效
            [SVProgressHUD dismiss];
            [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
        }else{
            if (code==602) {//登录失效
                [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
                
            }else{
                if (statusStr&&[statusStr isEqualToString:@"success"]) {
                    success(dic);
                }else{
                    [SVProgressHUD dismiss];
                    [[UserModel shareInstance] showInfoWithStatus:[dic objectForKey:@"message"]];
                    NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
                    
                    failure(error);
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([error code] ==-1005) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接失败，请检查网络"];
        }
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


#pragma mark 上传单张图片
- (NSURLSessionTask*)uploadImageWithPath:(NSString *)path image:(UIImage *)image params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    NSArray *array = [NSArray arrayWithObject:image];
   NSURLSessionTask * task = [self uploadImageWithPath:path photos:array params:params success:success failure:failure];
    return task;
}

#pragma mark 上传图片
- (NSURLSessionTask*)uploadImageWithPath:(NSString *)path photos:(NSArray *)photos params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    if (!manager) {
        manager =[AFHTTPSessionManager manager];
    }
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];

    [SVProgressHUD showProgress:-1 status:@"上传中..."];
    
  NSURLSessionTask* task =  [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],path] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

      
        for (int i = 0; i < photos.count; i ++) {

            NSString *fileName=[NSString stringWithFormat:@"picture_t%d.png",i+1];
            UIImage *image = photos[i];
            NSData * imageData = UIImageJPEGRepresentation(image,1);
            
           NSInteger length = [imageData length]/1024/1024;

            if (length>1) {
                imageData = UIImageJPEGRepresentation(image, 1/length);
            }

            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"picture_t%d",i+1] fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"uploadProgress is %lld,总字节 is %lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);

        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary * dic = [NSDictionary dictionary];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dic = responseObject;
        }else{
            dic =  [self dictionaryWithData:responseObject];
        }
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        DLog(@"%@--%@",dic ,[dic objectForKey:@"message"]);
        int  code =[[dic safeObjectForKey:@"code"]intValue];
        
        
        if (code  ==601) {//登录失效
            [SVProgressHUD dismiss];
            [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
        }else{
            if (code==602) {//登录失效
                [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
                
            }else{
                if (statusStr&&[statusStr isEqualToString:@"success"]) {
                    success(dic);
                }else{
                    [SVProgressHUD dismiss];
                    [[UserModel shareInstance] showInfoWithStatus:[dic objectForKey:@"message"]];
                    NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
                    
                    failure(error);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        if (failure == nil) return ;
        failure(error);
    }];
    return task;
}






-(NSURLSessionTask*)get:(NSString*)url
              paramters:(NSDictionary*)paramters
                success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    
    
    NSURLSessionTask* task = [manager GET:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters success:^(NSURLSessionTask *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(operation,error);
    }];
    
    return task;
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


-(NSURLSessionTask*)postMovie:(NSString*)url
                    paramters:(NSMutableDictionary *)paramters
                    movieData:(NSData *)movieData
                     videoImg:(NSData*)videoData
                    movieName:(NSString *)movieName//@"headimgurl.png"
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure
{
    if (!manager) {
        manager =[AFHTTPSessionManager manager];
    }
    [manager.requestSerializer setValue:[UserModel shareInstance].userId?[UserModel shareInstance].userId:@"" forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];
    [manager.requestSerializer setValue:[UserModel shareInstance].token?[UserModel shareInstance].token:@"" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UserModel shareInstance] getVersion] forHTTPHeaderField:@"version"];
    
    [SVProgressHUD show];
    
    NSURLSessionTask * task =[manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (movieData&&movieData.length>1) {
            [formData appendPartWithFileData:movieData name:@"picture_t10" fileName:@"picture_t10.mp4" mimeType:@"video/mp4"];
        }
        [formData appendPartWithFileData:videoData name:@"videoImg" fileName:@"videoImg.png" mimeType:@"image/png"];

        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        DLog(@"上传进度--%@",uploadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary * dic = [self dictionaryWithData:responseObject];
        
        NSString * statusStr =[dic safeObjectForKey:@"status"];
        DLog(@"%@--%@",dic ,[dic objectForKey:@"message"]);
        int  code =[[dic safeObjectForKey:@"code"]intValue];
        
        
        if (code  ==601) {//登录失效
            [SVProgressHUD dismiss];
            [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
        }else{
            if (code==602) {//登录失效
                [(AppDelegate *)[UIApplication sharedApplication].delegate loignOut];
                
            }else{
                if (statusStr&&[statusStr isEqualToString:@"success"]) {
                    success(dic);
                }else{
                    [SVProgressHUD dismiss];
                    [[UserModel shareInstance] showInfoWithStatus:[dic objectForKey:@"message"]];
                    NSError * error = [[NSError alloc]initWithDomain:NSURLErrorDomain code:[[dic objectForKey:@"code"]intValue] userInfo:dic];
                    
                    failure(error);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if ([error code] ==-1005) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接失败，请检查网络"];
        }
        failure(error);
        
    }];
    
    return task;

}



@end
