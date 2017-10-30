//
//  ClearCecheModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/30.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ClearCecheModel.h"

@implementation ClearCecheModel



- (double)getSizeWithFilePath:(NSString *)path{
    
    // 1.获得文件夹管理者
    
    NSFileManager *manger = [NSFileManager defaultManager];
    
    // 2.检测路径的合理性
    
    BOOL dir = NO;
    
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
    
    if (!exits) return 0;
    
    // 3.判断是否为文件夹
    
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        
        NSArray *subpaths = [manger subpathsAtPath:path];
        
        int totalSize = 0;
        
        for (NSString *subpath in subpaths) {
            
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            
            BOOL dir = NO;
            
            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            
            if (!dir) { // 子路径是个文件
                
                NSDictionary *attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                
                totalSize += [attrs[NSFileSize] intValue];
                
            }
            
        }
        
        return totalSize / (1024 * 1024.0);
        
    } else { // 文件
        
        NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];
        
        return [attrs[NSFileSize] intValue]/ (1024.0 * 1024.0) ;//
        
    }
    
}

-(void)getcecheSize
{
    NSString * cachePath = [NSTemporaryDirectory()stringByAppendingString:@"MediaCache"];
    double videoSize =  [self getSizeWithFilePath:cachePath];
    double imageSize = [[SDImageCache sharedImageCache] getSize];
    double totalSize = videoSize +imageSize;
    DLog(@"缓存---%.3f",totalSize);
}
//清除缓存
-(void)ClearCeche
{
     // 文件路径---视频
    NSString * cachePath = [NSTemporaryDirectory()stringByAppendingString:@"MediaCache"];
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];

    [[SDImageCache sharedImageCache] clearMemory];

}
@end
