//
//  NewHealthDetailSecondCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailSecondCell.h"

@implementation NewHealthDetailSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    NSString * tisStr = [NSString stringWithFormat:@"本次%d项检查中有%d项预警%d项警告%d项正常",item.normal+item.serious+item.warn,item.warn,item.serious,item.normal];
    
    int normalLenght;
    int warnLenght;
    int seriouslenght;
    if (item.normal==10) {
        normalLenght =2;
    }else{
        normalLenght =1;
    }
    if (item.warn==10) {
        warnLenght =2;
    }else{
        warnLenght =1;
    }
    if (item.serious==10) {
        seriouslenght =2;
    }else{
        seriouslenght =1;
    }
    
    
    int lenght =0;
    
    NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:tisStr];
    
    //总共
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 2)];
    
    lenght +=2;
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(lenght, 2)];
    lenght +=2;
    
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 5)];
    lenght +=5;
    
    //warn
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1] range:NSMakeRange(lenght, warnLenght)];
    lenght+=warnLenght;
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 3)];
    lenght+=3;
    //serious
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1] range:NSMakeRange(lenght, seriouslenght)];
    lenght+=seriouslenght;
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 3)];
    lenght+=3;
    //normal
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(lenght, normalLenght)];
    lenght+=normalLenght;
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(tisStr.length-3, 3)];
    self.titleLb.attributedText = tisString;
    self.titleLb.adjustsFontSizeToFitWidth = YES;
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
