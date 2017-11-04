//
//  HistoryCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryCell.h"
#import "ShareHealthItem.h"
#define warningColor   [UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1]
#define normalColor    [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1]
#define seriousColor   [UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1]

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.daysLabel.adjustsFontSizeToFitWidth = YES;
}
-(void)setInfoWithDict:(NSDictionary *)infoDict  isHidden:(BOOL)isHidden
{
    
    NSString * weightStr = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"weight"]floatValue]];
    NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:weightStr];

    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEXCOLOR(0xcccccc)};
    
    [tisString addAttributes:dic range:NSMakeRange(tisString.length-2, 2)];
    
    self.weightlb.attributedText = tisString;
    
    
    
    
    self.tzlLb.text = [NSString stringWithFormat:@"%.1f%%",[[infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
    self.timeLb.text = [self getTimeWithString:[infoDict safeObjectForKey:@"createTime"]];
    self.daysLabel.text = [[infoDict safeObjectForKey:@"createTime"]yyyymmdd];

    self.infoView.hidden = isHidden;
    if (isHidden ==NO) {
        
        self.statusImageView.image = getImage(@"historyHealthStatus2_");
        
        self.value1lb.text = [NSString stringWithFormat:@"%.0f",[[infoDict safeObjectForKey:@"bodyAge"]floatValue]];//AGE
        
        self.value2lb.text = [NSString stringWithFormat:@"%.0f",[[infoDict safeObjectForKey:@"bmr"]floatValue]];//代谢
        
        self.value3lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"weight"]floatValue]];
        
        self.value4lb.text = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"weightLevel"]];
        
        self.value5lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
        
        self.value6lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"fatWeight"]floatValue]];
        
        self.value7lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"muscleWeight"]floatValue]];
        
        self.value8lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"bmi"]floatValue]];
        
        self.value9lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"proteinWeight"]floatValue]];
        
        self.value10lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"boneMuscleWeight"]floatValue]];
        
        self.value11lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"waterWeight"]floatValue]];
        
        self.value12lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"visceralFatPercentage"]floatValue]];
        
        self.value13lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"standardWeight"]floatValue]];

        
        self.second3Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"weightLevel"]intValue] status:IS_BODYWEIGHT];
        self.second3Lb.backgroundColor = [self getColorWithLevel:self.second3Lb.text];

        
        self.second4lb.text = [self getwl:[[infoDict objectForKey:@"weightLevel"]intValue]];

        if ([self.value4lb.text intValue]==1||[self.value4lb.text intValue]==3||[self.value4lb.text intValue]==4) {
            self.second4lb.backgroundColor = warningColor;
        }else if ([self.value4lb.text intValue]==2)
        {
            self.second4lb.backgroundColor = normalColor;
        }
        else{
            self.second4lb.backgroundColor = seriousColor;
        }
        
        
        self.second5Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"fatPercentageLevel"]intValue] status:IS_FATPERCENT];
        self.second5Lb.backgroundColor = [self getColorWithLevel:self.second5Lb.text];

        
        self.second6Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"fatWeightLevel"]intValue] status:IS_FAT];
        self.second6Lb.backgroundColor = [self getColorWithLevel:self.second6Lb.text];

        
        
        
        self.second7Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"muscleLevel"]intValue] status:IS_SAME];
        self.second7Lb.backgroundColor = [self getColorWithLevel:self.second7Lb.text];

        self.second8Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"bmiLevel"]intValue] status:IS_BMI];
        
        self.second8Lb.backgroundColor = [self getColorWithLevel:self.second8Lb.text];

        
        self.second9Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"proteinLevel"]intValue] status:IS_SAME];
        self.second9Lb.backgroundColor = [self getColorWithLevel:self.second9Lb.text];

        
        self.second10Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"boneMuscleLevel"]intValue] status:IS_SAME];
        self.second10Lb.backgroundColor = [self getColorWithLevel:self.second10Lb.text];

        
        
        self.second11Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"waterLevel"]intValue] status:IS_SAME];
        self.second11Lb.backgroundColor = [self getColorWithLevel:self.second11Lb.text];

        
        
        self.second12Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"visceralFatPercentageLevel"]intValue] status:IS_VISCERALFAT];
        self.second12Lb.backgroundColor = [self getColorWithLevel:self.second12Lb.text];


        
    }else{
        self.statusImageView.image = getImage(@"historyHealthStatus1_");

    }

    
}
-(UIColor *)getColorWithLevel:(NSString *)levelStr
{
    if ([levelStr isEqualToString:@"正常"]) {
        return normalColor;
    }else if([levelStr isEqualToString:@"低"]||[levelStr isEqualToString:@"偏瘦"]||[levelStr isEqualToString:@"偏低"]){
        return warningColor;
    }
    else {
        return seriousColor;
    }
}


-(NSString *)getwl:(int )weightLevel
{
    
    NSString * levelStr;
    switch (weightLevel) {
        case 1:
            levelStr = [NSString stringWithFormat:@"偏瘦"];
            break;
        case 2:
            levelStr = [NSString stringWithFormat:@"正常"];
            break;
        case 3:
            levelStr = [NSString stringWithFormat:@"偏胖"];
            break;
        case 4:
            levelStr = [NSString stringWithFormat:@"偏胖"];
            break;
        case 5:
            levelStr = [NSString stringWithFormat:@"超重"];
            break;
        case 6:
            levelStr = [NSString stringWithFormat:@"超重"];
            break;
            
        default:
            break;
    }
    return levelStr;
    
}
-(NSString *)getTimeWithString:(NSString *)str
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"hh:mm"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
    
}
- (IBAction)didClickChoose:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didChooseWithCell:)]) {
        [self.delegate didChooseWithCell:self];
    }
}
- (IBAction)didShowDetailInfo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showCellTabWithCell:)]) {
        [self.delegate showCellTabWithCell:self];
    }else{
        DLog(@"代理未执行");
    }
}

- (IBAction)didDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteWithCell:)]) {
        [self.delegate didDeleteWithCell:self];
    }else{
        DLog(@"代理未执行");
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
