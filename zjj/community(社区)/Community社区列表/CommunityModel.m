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
    
    NSString * contentStr = [[dict safeObjectForKey:@"content"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    self.content = [NSString stringWithFormat:@"%@",contentStr];
    self.userId = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"userId"]];
    self.uid = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"id"]];
    self.title = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"nickName"]];
    self.movieStr = [dict safeObjectForKey:@"videoPath"];
    self.movieImageStr = [dict safeObjectForKey:@"videoImg"];
    self.isRelease = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"isRelease"]];
    self.shareNum = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"shareNum"]];
    self.isFollow  =[dict safeObjectForKey:@"isFollow"];
    self.greatnum = [dict safeObjectForKey:@"greatnum"];
    self.forwardingnum = [dict safeObjectForKey:@"forwardingnum"];
    self.commentnum = [dict safeObjectForKey:@"commentnum"];
    self.isFabulous = [dict safeObjectForKey:@"isFabulous"];
    self.level      = [dict safeObjectForKey:@"gradeId"];
    self.topNum     = [dict safeObjectForKey:@"topNum"];
    [self setInPictureWithDict:dict];

    self.rowHieght = [self CalculateCellHieghtWithContent:contentStr images:self.pictures];

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
    if (!self.pictures) {
        self.pictures = [NSMutableArray array];
    }
    [self.pictures removeAllObjects];
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
    paragraph.lineSpacing = 5;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};
    
    CGSize size;
    if (contentStr.length>0) {
        size = [contentStr boundingRectWithSize:CGSizeMake(JFA_SCREEN_WIDTH-40, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    }else{
        size = CGSizeMake(0, 0);
    }
    
    float imageHeight = 0.0f;
    
    if (self.movieStr.length>5) {
        imageHeight = (JFA_SCREEN_WIDTH-40)*0.6;
    }
    else
    {
        if (images.count<1)
        {
            imageHeight = 0;
        }
        else if (images.count==1)
        {
            imageHeight = (JFA_SCREEN_WIDTH-40)*0.6;
        }
        else if (images.count>1&& images.count<=3)
        {
            imageHeight =(JFA_SCREEN_WIDTH-20)/3;
        }
        else if (images.count>3&&images.count<=6)
        {
            if (images.count ==4)
            {
                imageHeight = JFA_SCREEN_WIDTH-50;
            }
            else
            {
                imageHeight = ((JFA_SCREEN_WIDTH-20)/3-10)*2+10;
            }
        }
        else
        {
            imageHeight = ((JFA_SCREEN_WIDTH-40)/3)*3;
        }
    }
    return size.height+imageHeight+140;
    
}
@end
