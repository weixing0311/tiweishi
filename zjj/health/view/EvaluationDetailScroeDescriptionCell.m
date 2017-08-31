//
//  EvaluationDetailScroeDescriptionCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "EvaluationDetailScroeDescriptionCell.h"
#import "UIImageView+AFNetworking.h"

@implementation EvaluationDetailScroeDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.headImageView.layer.borderWidth = 1;

    // Initialization code
}
-(void)setUpinfoWithItem
{
    if (![HealthDetailsItem instance].DataId) {
        return;
    }
    NSString * headURLStr = [SubUserItem shareInstance].headUrl;
    [self. headImageView sd_setImageWithURL:[NSURL URLWithString:headURLStr]placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    self.nameLabel.text = [SubUserItem shareInstance].nickname;
    self.timeLabel.text = [NSString stringWithFormat:@"生成日期：%@",[HealthDetailsItem instance].createTime];
    self.bodyAgeLabel.text = [NSString stringWithFormat:@"身体年龄：%d",[HealthDetailsItem instance].bodyAge];
    self.bmrLabel.text = [NSString stringWithFormat:@"基础代谢：%.0f",[HealthDetailsItem instance].bmr];
    self.ageLabel.text = [NSString stringWithFormat:@"年龄：%d",[UserModel shareInstance].age];
    self.heightLabel.text =[NSString stringWithFormat:@"身高：%.1fcm",[UserModel shareInstance].heigth];
    switch ([HealthDetailsItem instance].weightLevel) {
        case 1:
            self.weightStatusLabel.text = [NSString stringWithFormat:@"偏瘦"];
            self.weightStatusLabel.textColor = HEXCOLOR(0xf4a519);
            break;
        case 2:
            self.weightStatusLabel.text = [NSString stringWithFormat:@"正常"];
            self.weightStatusLabel.textColor = HEXCOLOR(0x41bf7c);
            break;
        case 3:
            self.weightStatusLabel.text = [NSString stringWithFormat:@"轻度肥胖"];
            self.weightStatusLabel.textColor = HEXCOLOR(0xf4a519);
            break;
        case 4:
            self.weightStatusLabel.text = [NSString stringWithFormat:@"中度肥胖"];
            self.weightStatusLabel.textColor = HEXCOLOR(0xf4a519);
            break;
        case 5:
            self.weightStatusLabel.text = [NSString stringWithFormat:@"重度肥胖"];
            self.weightStatusLabel.textColor = HEXCOLOR(0xe84849);
            break;
        case 6:
            self.weightStatusLabel.text = [NSString stringWithFormat:@"极度肥胖"];
            self.weightStatusLabel.textColor = HEXCOLOR(0xe84849);
            break;
            
        default:
            break;
    }
    
    
    // 体重
    NSMutableAttributedString * weightAttStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].weight]];
    
    [weightAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(weightAttStr.length-4, 4)];
    [weightAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, 2)];

    self.weightLabel.attributedText = weightAttStr;
    
    // 趋势提示
    if  ([HealthDetailsItem instance].weight) {
        float weightChange = [HealthDetailsItem instance].weight-[HealthDetailsItem instance].lastWeight;
        self.trendLabel.text = [NSString stringWithFormat:@"%.1fkg",fabsf(weightChange) ];
        self.trendArrowImageView.image =[UIImage imageNamed:weightChange > 0 ?@"trand_up_icon" : @"trand_down_icon"];
        self.trendArrowImageView.hidden = NO;
    }
    else {
        self.trendArrowImageView.hidden = YES;
        self.trendLabel.text = @"-";
    }
    
    //显示中间大圆圈
    if ([HealthDetailsItem instance].weightLevel==1||[HealthDetailsItem instance].weightLevel==3||[HealthDetailsItem instance].weightLevel==4) {
        self.weightBgImageView.image =[UIImage imageNamed:@"warning_bg"];
    }
    else if ([HealthDetailsItem instance].weightLevel==5||[HealthDetailsItem instance].weightLevel==6) {
        self.weightBgImageView.image =[UIImage imageNamed:@"danger_bg"];
    }
    else {
        self.weightBgImageView.image =[UIImage imageNamed:@"health_bg"];
    }
    
    
    
    NSString * tisStr = [NSString stringWithFormat:@"本次%d项检查中有%d项预警%d项警告%d项正常",[HealthDetailsItem instance].normal+[HealthDetailsItem instance].serious+[HealthDetailsItem instance].warn,[HealthDetailsItem instance].warn,[HealthDetailsItem instance].serious,[HealthDetailsItem instance].normal];
    
    NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:tisStr];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 2)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(2, 1)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(3, 5)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1] range:NSMakeRange(8, 1)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(9, 3)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1] range:NSMakeRange(12, 1)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(13, 3)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(16, 1)];
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(tisStr.length-3, 3)];
    
    self.scaleResultStatusLabel.attributedText = tisString;
    self.scaleResultStatusLabel.adjustsFontSizeToFitWidth = YES;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
