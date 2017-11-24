//
//  NewHealthDetailHeaderCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailHeaderCell.h"
#define warningColor   [UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1]
#define normalColor    [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1]
#define seriousColor   [UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1]

@implementation NewHealthDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nicknamelb.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:getImage(@"head_default")options:SDWebImageRetryFailed];
    self.nicknamelb.text = [SubUserItem shareInstance].nickname;
    
    self.heightlb.text =[NSString stringWithFormat:@"身高:%d",item.height];
    self.agelb.text =[NSString stringWithFormat:@"年龄:%d",item.age];
    
    self.bmrlb.text = [NSString stringWithFormat:@"基础代谢:%.1f",item.bmr];
    
//    if (item.weightLevel==1||item.weightLevel==3||item.weightLevel==4) {
//        self.bmrlb.textColor = warningColor;
//
//    }else if (item.weightLevel==2)
//    {
//        self.bmrlb.textColor = normalColor;
//    }
//    else if (item.weightLevel==5||item.weightLevel==6)
//    {
//        self.bmrlb.textColor = seriousColor;
//    }
    self.bodyAgelb.text = [NSString stringWithFormat:@"身体年龄:%d",item.bodyAge];
    
    
//    self.value1lb.text = [NSString stringWithFormat:@"身高:%d",item.height];
//    self.value2lb.text = [NSString stringWithFormat:@"体型:%@  身体年龄:%d",[self getBodyStatusWithLevel:item.weightLevel],item.bodyAge];
    self.value2lb.adjustsFontSizeToFitWidth = YES;

}

-(NSString *)getBodyStatusWithLevel:(int)level
{
    switch (level) {
        case 1:
            return  [NSString stringWithFormat:@"偏瘦"];
            break;
        case 2:
            return  [NSString stringWithFormat:@"标准"];
            break;
        case 3:
            return   [NSString stringWithFormat:@"偏胖"];
            break;
        case 4:
            return  [NSString stringWithFormat:@"偏胖"];
            break;
        case 5:
            return   [NSString stringWithFormat:@"超重"];
            break;
        case 6:
            return   [NSString stringWithFormat:@"超重"];
            break;
        default:
            return @"";
            break;
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
