//
//  HistoryCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryCell.h"
#import "ShareHealthItem.h"
@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(NSDictionary *)infoDict
{
    
    self.weightlb.text =[NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"weight"]floatValue]];
    self.tzlLb.text = [NSString stringWithFormat:@"%.1f%%",[[infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
    self.timeLb.text = [self getTimeWithString:[infoDict safeObjectForKey:@"createTime"]];
    if ([infoDict safeObjectForKey:@"isSelected"]) {
        self.showBtn.selected =YES;
        self.infoView.hidden = NO;
    }else{
        self.showBtn.selected =NO;
        self.infoView.hidden = YES;
    }

    
    self.value1lb.text = [NSString stringWithFormat:@"%.0f",[[infoDict safeObjectForKey:@"bodyAge"]floatValue]];//AGE
    self.value2lb.text = [NSString stringWithFormat:@"%.0f",[[infoDict safeObjectForKey:@"bmr"]floatValue]];//代谢
    self.value3lb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"weight"]floatValue]];
    
    self.value4lb.text = [self getwl:[[infoDict objectForKey:@"weightLevel"]intValue]];
    self.value5lb.text = [NSString stringWithFormat:@"%.1f%%",[[infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
    
    
    self.value6lb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"fatWeight"]floatValue]];
    self.value7lb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"muscleWeight"]floatValue]];
    self.value8lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"bmi"]floatValue]];
    self.value9lb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"proteinWeight"]floatValue]];
    self.value10lb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"boneMuscleWeight"]floatValue]];
    self.value11lb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"waterWeight"]floatValue]];
    self.value12lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"visceralFatPercentage"]floatValue]];
    self.value13lb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"standardWeight"]floatValue]];
//    self.value13lb.text = [dict safeObjectForKey:@""];

    self.second3Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"weightLevel"]intValue] status:IS_BODYWEIGHT];
    self.second5Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"visceralFatPercentageLevel"]intValue] status:IS_SAME];
    self.second6Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"fatWeightLevel"]intValue] status:IS_SAME];
    self.second7Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"muscleLevel"]intValue] status:IS_SAME];
    self.second8Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"bmiLevel"]intValue] status:IS_BMI];
    self.second9Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"proteinLevel"]intValue] status:IS_SAME];
    self.second10Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"boneMuscleLevel"]intValue] status:IS_SAME];
    self.second11Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"waterLevel"]intValue] status:IS_SAME];
    self.second12Lb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"visceralFatPercentageLevel"]intValue] status:IS_VISCERALFAT];

    
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
    NSLog(@"date= %@", inputDate);
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
