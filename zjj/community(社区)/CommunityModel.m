//
//  CommunityModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/26.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommunityModel.h"


static CommunityModel * imageModel;
@implementation CommunityModel
+(CommunityModel *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageModel = [[CommunityModel alloc]init];
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
    self.headurl = [dict safeObjectForKey:@"headimgurl"];
    self.releaseTime = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"createTime"]];
    self.content = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"content"]];
    self.userId = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"userId"]];
    self.uid = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"id"]];
    self.title = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"nickName"]];
    [self setInPictureWithDict:dict];
    self.movieStr = [dict safeObjectForKey:@"videoPath"];
    self.movieImageStr = [dict safeObjectForKey:@"videoImg"];
    self.isRelease = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"isRelease"]];
    self.shareNum = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"shareNum"]];
    
    self.greatnum = [dict safeObjectForKey:@"greatnum"];
    self.forwardingnum = [dict safeObjectForKey:@"forwardingnum"];
    self.commentnum = [dict safeObjectForKey:@"commentnum"];

    
    self.rowHieght = [self CalculateCellHieghtWithContent:[dict safeObjectForKey:@"content"] images:self.pictures];
}
-(NSMutableArray *)thumbArray
{
    if (!_thumbArray) {
        _thumbArray = [NSMutableArray new];
    }
    return _thumbArray;
}
-(void)setInPictureWithDict:(NSDictionary *)dict
{
    self.pictures = [NSMutableArray array];
    for ( int i =1; i<10; i++) {
        NSString * url  =[dict safeObjectForKey:[NSString stringWithFormat:@"picture%d",i]];
        if (url&&url.length>5) {
            [self.pictures addObject:url];
        }
    }
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
    
    if (self.movieStr.length>5) {
        imageHeight = (JFA_SCREEN_WIDTH-20)*0.7;
    }else{
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
    }
    return size.height+imageHeight+105;
    
}
@end
