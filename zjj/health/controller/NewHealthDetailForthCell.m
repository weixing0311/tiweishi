//
//  NewHealthDetailForthCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailForthCell.h"

@implementation NewHealthDetailForthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    NSString * tisStr = [NSString stringWithFormat:@"本次%d项检查中有%d项预警%d项警告%d项正常",item.normal+item.serious+item.warn,item.warn,item.serious,item.normal];
    
    NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:tisStr];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 2)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(2, 2)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(4, 5)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1] range:NSMakeRange(9, 1)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(10, 3)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1] range:NSMakeRange(13, 1)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(14, 3)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(17, 1)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(tisStr.length-3, 3)];
    self.secondlb.attributedText = tisString;
    self.secondlb.adjustsFontSizeToFitWidth = YES;
    
    self.firstlb.text = [self getContentWithItem:item];
    
    
}

-(NSString *)getContentWithItem:(HealthDetailsItem *)item
{
    if (item.weight-item.lastWeight==0) {
        switch (item.weightLevel) {
            case 1:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于偏瘦身材，可以考虑补充营养，进行锻炼，毕竟过于消瘦也不好奥。",item.weight,item.fatPercentage];
                break;
            case 2:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于标准身材，您的体型很标准，继续保持，如果您对自己有更高要求，可以运动锻炼，进行增肌塑形。",item.weight,item.fatPercentage];

                break;
            case 3:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于偏胖人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];

                break;
            case 4:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于偏胖人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];

                break;
            case 5:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于超重人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];

                break;
            case 6:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于超重人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];

                break;

            default:
                break;
        }
    }else{
        switch (item.weightLevel) {
            case 1:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，提醒您补充营养也要把握好尺度，不要被肥胖趁虚而入奥。",item.weight];

                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，建议您保证三餐必须的营养摄入，不要为了身材而不顾健康奥。",item.weight];

                }
                break;
            case 2:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%1.fkg，建议您注意饮食，不要被肥胖趁虚而入奥。",item.weight];

                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，建议您保证三餐必须的营养摄入，不要为了身材而不顾健康奥。",item.weight];

                }
                break;
            case 3:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight];

                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",item.weight];

                }
                break;
            case 4:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight];

                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",item.weight];

                }
                break;
            case 5:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight];

                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",item.weight];

                }
                break;
            case 6:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight];

                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",item.weight];

                }
                break;

            default:
                return @"";
                break;
        }
    }
    return @"";

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
