//
//  HistoryBigCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryBigCell.h"
#import "HistoryInfoCell.h"
#import "ShareHealthItem.h"
@implementation HistoryBigCell
{
    NSDictionary * infoDict ;
    int tabRow;
}
- (void)awakeFromNib {
    [super awakeFromNib];

    self.listTableview.delegate = self;
    self.listTableview.dataSource= self;
    self.listTableview.bounces =NO;
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.listTableview setTableFooterView:view];

    // Initialization code
    infoDict = [NSDictionary dictionary];
}
- (IBAction)didShowDetailInfo:(id)sender {
    if (!infoDict||[infoDict allKeys].count<1) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(showCellTabWithCell:)]) {
        [self.delegate showCellTabWithCell:self];
    }else{
        DLog(@"代理未执行");
    }
}
-(void)setInfoWithDict:(NSDictionary *)dict
{
    infoDict = [NSDictionary dictionaryWithDictionary:dict];
    self.weightlb.text =[NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"weight"]floatValue]];
    self.tzlLb.text = [NSString stringWithFormat:@"%.1f%%",[[infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
    self.timeLb.text = [self getTimeWithString:[infoDict safeObjectForKey:@"createTime"]];
    if ([dict safeObjectForKey:@"isSelected"]) {
        self.showBtn.selected =YES;
        self.listTableview.hidden = NO;
    }else{
        self.showBtn.selected =NO;
        self.listTableview.hidden = YES;
    }
    [self.listTableview reloadData];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"HistoryInfoCell";
    HistoryInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {

        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil]lastObject];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.headImageView.image  = getImage(@"age_");
            cell.titlelb.text = @"身体年龄";
            cell.valuelb.text = [NSString stringWithFormat:@"%.0f",[[infoDict safeObjectForKey:@"bodyAge"]floatValue]];
            cell.secondLb.hidden = YES;

            
            break;
        case 1:
            cell.headImageView.image  = getImage(@"daiX_");
            cell.titlelb.text = @"基础代谢";
            cell.valuelb.text = [NSString stringWithFormat:@"%.0f",[[infoDict safeObjectForKey:@"bmr"]floatValue]];
            cell.secondLb.hidden = YES;

            
            break;
        case 2:
            cell.headImageView.image  = getImage(@"weight_");
            cell.titlelb.text = @"体重";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"weight"]floatValue]];
            cell.secondLb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"weightLevel"]intValue] status:IS_BODYWEIGHT];
            cell.secondLb.hidden = NO;

            break;
        case 3:
            cell.headImageView.image  = getImage(@"fatBody_");
            cell.titlelb.text = @"肥胖等级";
            cell.valuelb.text = [self getwl:[[infoDict objectForKey:@"weightLevel"]intValue]];
            cell.secondLb .hidden = YES;
            break;
        case 4:
            cell.headImageView.image  = getImage(@"fat%_");
            cell.titlelb.text = @"体脂率";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f%%",[[infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"visceralFatPercentageLevel"]intValue] status:IS_SAME];
            cell.secondLb.hidden = NO;

            break;
        case 5:
            cell.headImageView.image  = getImage(@"fat_");
            cell.titlelb.text = @"脂肪重量";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"fatWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"fatWeightLevel"]intValue] status:IS_SAME];
            cell.secondLb.hidden = NO;

            break;
        case 6:
            cell.headImageView.image  = getImage(@"jirou_");
            cell.titlelb.text = @"肌肉";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"muscleWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"muscleLevel"]intValue] status:IS_SAME];
            cell.secondLb.hidden = NO;

            break;
        case 7:
            cell.headImageView.image  = getImage(@"BMI_");
            cell.titlelb.text = @"BMI";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"bmi"]floatValue]];
            cell.secondLb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"bmiLevel"]intValue] status:IS_BMI];
            ;
            cell.secondLb.hidden = NO;

            break;
        case 8:
            cell.headImageView.image  = getImage(@"danBZ_");
            cell.titlelb.text = @"蛋白质";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"proteinWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"proteinLevel"]intValue] status:IS_SAME];
            cell.secondLb.hidden = NO;

            break;
        case 9:
            cell.headImageView.image  = getImage(@"bone_");
            cell.titlelb.text = @"骨骼肌";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"boneMuscleWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"boneMuscleLevel"]intValue] status:IS_SAME];
            cell.secondLb.hidden = NO;

            break;
        case 10:
            cell.headImageView.image  = getImage(@"water_");
            cell.titlelb.text = @"水分";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[infoDict safeObjectForKey:@"waterWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"waterLevel"]intValue] status:IS_SAME];
            
            cell.secondLb.hidden = NO;

            break;
        case 11:
            cell.headImageView.image  = getImage(@"fei_");
            cell.titlelb.text = @"内脏脂肪";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"visceralFatPercentage"]floatValue]];
            cell.secondLb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[infoDict safeObjectForKey:@"visceralFatPercentageLevel"]intValue] status:IS_VISCERALFAT];
            cell.secondLb.hidden = NO;

            break;
        case 12:
            cell.headImageView.image  = getImage(@"weight_");
            cell.titlelb.text = @"正常体重";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[infoDict safeObjectForKey:@"standardWeight"]floatValue]];
            cell.secondLb.hidden = YES;
            break;
            
        default:
            break;
    }
    
    return cell;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
