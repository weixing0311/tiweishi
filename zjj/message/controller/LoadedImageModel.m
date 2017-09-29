//
//  LoadedImageModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "LoadedImageModel.h"
static LoadedImageModel * imageModel;
@implementation LoadedImageModel
+(LoadedImageModel *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageModel = [[LoadedImageModel alloc]init];
    });
    return imageModel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loadedImageArray = [NSMutableArray array];
    }
    return self;
}
-(void)setInfoWithDict:(NSDictionary *)dict
{
    self.releaseTime = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"releaseTime"]];
    self.content = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"content"]];
    self.uid = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"id"]];
    self.title = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"title"]];
    self.pictures = [NSMutableArray arrayWithArray:[dict safeObjectForKey:@"pictures"]];
    self.movieStr = [dict safeObjectForKey:@"videoPath"];
    
    self.isRelease = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"isRelease"]];
    self.shareNum = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"shareNum"]];
    
    self.rowHieght = [self CalculateCellHieghtWithContent:[dict safeObjectForKey:@"content"] images:self.pictures];
}

-(float)CalculateCellHieghtWithContent:(NSString *)contentStr images:(NSArray * )images
{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};
    
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(JFA_SCREEN_WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    float imageHeight = 0.0f;
    
    
    int totalColumns = 0;
    if (images.count==2||images.count==4) {
        totalColumns =2;
    }else{
        totalColumns =3;
    }

    
    CGFloat cellW = (JFA_SCREEN_WIDTH-40)/3;
    
    if (images.count<1)
    {
        imageHeight = 0;
    }
    else if (images.count>0&& images.count<=3)
    {
        imageHeight =cellW;
    }
    else if (images.count>3&&images.count<=6)
    {
        imageHeight = cellW*2+10;
    }
    else{
        imageHeight = cellW*3+20;
    }
    
    return size.height+imageHeight+105;
    
}

@end
