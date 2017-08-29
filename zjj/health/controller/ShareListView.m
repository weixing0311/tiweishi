//
//  ShareTrendView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShareListView.h"
#import "ShareHealthItem.h"
#import "NSString+dateWithString.h"
#import "ShareTrendListCell.h"
#import "NSDate+CustomDate.h"
@implementation ShareListView

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.layer.borderWidth = 1;
    

    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.infoArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
}

-(void)setInfoWithArr:(NSMutableArray *) arr
{
//    [self paixuWithArr:arr];
    self.infoArray = [NSMutableArray arrayWithArray:[arr sortedArrayWithOptions:NSSortStable usingComparator:^ NSComparisonResult (ShareHealthItem *  m1,ShareHealthItem * m2){
        
//        return item1.createTime.compare(item2.createTime) == .orderedAscending
        return [m1.createTime compare:m2.createTime]==NSOrderedDescending;
    }]];

 
    ShareHealthItem * item1 = [self.infoArray objectAtIndex:0];
    ShareHealthItem * item2 = [self.infoArray objectAtIndex:1];

    

    
    _qrCodeImageView.image = [UIImage imageWithData:[UserModel shareInstance].qrcodeImageData];
    
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].qrcodeImageUrl ]placeholderImage:[UIImage imageNamed:@"head_default"]];

    self.nameLabel.text = [SubUserItem shareInstance].nickname;
    
    self.date1Label.text = [item1.createTime yyyymmdd];
    
    self.date2Label.text = [item2.createTime yyyymmdd];
    
    
    
    
    self.dateCountLabel.text = [NSString stringWithFormat:@"%d",[self gettimeXWithTime1:item1.createTime time2:item2.createTime]];
    
    
    // 减脂量
    
    float fatChangeWeight = [[NSString stringWithFormat:@"%.1f",item2.fatWeight]floatValue] -[[NSString stringWithFormat:@"%.1f",item1.fatWeight]floatValue];
    
    NSMutableAttributedString * fatChangeWeightAttStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1fkg",fabsf(fatChangeWeight)]];
    [fatChangeWeightAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(fatChangeWeightAttStr.length-3, 3)];
    
    self.fatChangeLabel.attributedText = fatChangeWeightAttStr;
    self.fatChangeNameLabel.text = fatChangeWeight <= 0 ? @"减脂" : @"增脂";
    
    // 减重量
    
    
    float weightChange = item2.weight -item1.weight;
    NSMutableAttributedString * WeightChangeAttStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1fkg",fabsf(weightChange)]];
    [WeightChangeAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(WeightChangeAttStr.length-3, 3)];
    
    self.weightChangeLabel.attributedText = WeightChangeAttStr;
    self.weightChangeNameLabel.text = weightChange <= 0 ? @"减重" : @"增重";
    
    
    self.generateTimeLabel.text = [NSString stringWithFormat:@"%@",[[NSDate date] mmddhhmm]];
    self.generateTimeLabel.adjustsFontSizeToFitWidth = YES;
    //    if qrCodeImage != nil {
    //        self.qrCodeImageView.image = qrCodeImage!
    //    }
    
    //    return view
    //}
    
    [self createInfoWithItem1:item1 Item2:item2];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ShareTrendListCell";
    ShareTrendListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray * arr =[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil];
        cell = [arr lastObject];
    }
    self.infoArray = [NSMutableArray arrayWithArray:[self.infoArray sortedArrayWithOptions:NSSortStable usingComparator:^ NSComparisonResult (ShareHealthItem *  m1,ShareHealthItem * m2){
        
        //        return item1.createTime.compare(item2.createTime) == .orderedAscending
        return [m1.createTime compare:m2.createTime]==NSOrderedDescending;
    }]];

    NSDictionary * dic =[_dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dic safeObjectForKey:@"title"];
    cell.value1Label.text = [dic safeObjectForKey:@"value1"];
    cell.value2Label.text = [dic safeObjectForKey:@"value2"];
    cell.value1StatusLabel.text = [dic safeObjectForKey:@"level1"];
    cell.value2StatusLabel.text = [dic safeObjectForKey:@"level2"];
    
    if (indexPath.row ==0||indexPath.row==1) {
        cell.value1StatusBgView.hidden = YES;
        cell.value2StatusBgView.hidden = YES;
    }else{
        cell.value1StatusBgView.hidden = NO;
        cell.value2StatusBgView.hidden = NO;

    }
    
    
    if ([[dic objectForKey:@"value1"]floatValue]-[[dic objectForKey:@"value2"]floatValue]<0) {
//        cell.value2TrendImageView.hidden = NO;
        if ([cell.value1StatusLabel.text isEqualToString:@"正常"]) {
        cell.value2TrendImageView.image = [UIImage imageNamed:@"arrow_health_up"];
        }else{
            cell.value2TrendImageView.image = [UIImage imageNamed:@"arrow_warning_up"];
        }
    }else if ([[dic objectForKey:@"value1"]floatValue]-[[dic objectForKey:@"value2"]floatValue]>0)
    {
//        cell.value2TrendImageView.hidden = NO;
        if ([cell.value1StatusLabel.text isEqualToString:@"正常"]) {
            cell.value2TrendImageView.image = [UIImage imageNamed:@"arrow_health_down"];
        }else{
            cell.value2TrendImageView.image = [UIImage imageNamed:@"arrow_warning_down"];
        }
 
    }else{
        cell.value2TrendImageView.hidden = YES;
    }
    
    
    if ([cell.value1StatusLabel.text isEqualToString:@"正常"]) {
        cell.value1StatusBgView.backgroundColor =HEXCOLOR(0x39D19F);
    }else{
        cell.value1StatusBgView.backgroundColor = HEXCOLOR(0xE46F48);
    }
    if ([cell.value2StatusLabel.text isEqualToString:@"正常"]) {
        cell.value2StatusBgView.backgroundColor =HEXCOLOR(0x39D19F);
    }else{
        cell.value2StatusBgView.backgroundColor = HEXCOLOR(0xE46F48);
    }
    
    return cell;
}
-(int)gettimeXWithTime1:(NSDate *)tiem1 time2:(NSDate *)time2
{
    
    
    NSTimeInterval start = [tiem1 timeIntervalSince1970]*1;
    NSTimeInterval end = [time2 timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int day = round(value / (24 * 3600));
    return  day;
}




-(void)createInfoWithItem1:(ShareHealthItem *)item1 Item2:(ShareHealthItem *)item2
{
    

    //体重
    NSString * weightStatus1 = [[ShareHealthItem shareInstance] getHeightWithLevel:item1.weightLevel status:IS_BODYWEIGHT];
    NSString * weightStatus2 = [[ShareHealthItem shareInstance] getHeightWithLevel:item2.weightLevel status:IS_BODYWEIGHT];

    //体脂
    NSString *fatpercent1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.fatPercentageLevel status:IS_FATPERCENT];
    NSString *fatpercent2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.fatPercentageLevel status:IS_FATPERCENT];

    //脂肪量
    NSString *fatLevel1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.fatWeightLevel status:IS_FAT];
    NSString *fatLevel2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.fatWeightLevel status:IS_FAT];

    //BMI
    NSString *BMI1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.bmiLevel status:IS_BMI];
    NSString *BMI2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.bmiLevel status:IS_BMI];

//    蛋白质
    NSString *protein1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.proteinLevel status:IS_SAME];
    NSString *protein2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.proteinLevel status:IS_SAME];
//骨骼肌
    NSString *boneMuscle1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.boneMuscleLevel status:IS_SAME];
    NSString *boneMuscle2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.boneMuscleLevel status:IS_SAME];
//水分
    NSString *water1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.waterLevel status:IS_SAME];
    NSString *water2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.waterLevel status:IS_SAME];
//内脂
    NSString *viscerlFat1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.visceralFatPercentageLevel status:IS_VISCERALFAT];
    NSString *viscerlFat2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.visceralFatPercentageLevel status:IS_VISCERALFAT];
    //肌肉
    NSString *muscle1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.muscleLevel status:IS_SAME];
    NSString *muscle2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.muscleLevel status:IS_SAME];
    
    
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"身体年龄",@"title",
                           [NSString stringWithFormat:@"%d",item1.bodyAge],@"value1",
                           [NSString stringWithFormat:@"%d",item2.bodyAge],@"value2", nil];
    
    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"基础代谢 ",@"title",
                           [NSString stringWithFormat:@"%.0f",item1.bmr],@"value1",
                           [NSString stringWithFormat:@"%.0f",item2.bmr],@"value2", nil];

    NSDictionary * dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"体重(kg)",@"title",
                           [NSString stringWithFormat:@"%.1f",item1.weight],@"value1",
                           [NSString stringWithFormat:@"%.1f",item2.weight],@"value2",
                           weightStatus1,@"level1",
                           weightStatus2,@"level2", nil];

    NSDictionary * dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"肥胖等级",@"title",
                           [self getwl:item1.weightLevel],@"value1",
                           [self getwl:item2.weightLevel],@"value2",
                           weightStatus1,@"level1",
                           weightStatus2,@"level2", nil];

    NSDictionary * dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@"体脂率(%)",@"title",
                           [NSString stringWithFormat:@"%.1f",item1.fatPercentage*100],@"value1",
                           [NSString stringWithFormat:@"%.1f",item2.fatPercentage*100],@"value2",
                           fatpercent1,@"level1",
                           fatpercent2,@"level2", nil];

    NSDictionary * dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@"脂肪量(kg)",@"title",
                           [NSString stringWithFormat:@"%.1f",item1.fatWeight],@"value1",
                           [NSString stringWithFormat:@"%.1f",item2.fatWeight],@"value2",
                           fatLevel1,@"level1",
                           fatLevel2,@"level2",nil];

    NSDictionary * dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@"BMI",@"title",
                           [NSString stringWithFormat:@"%.1f",item1.bmi],@"value1",
                           [NSString stringWithFormat:@"%.1f",item2.bmi],@"value2",
                           BMI1,@"level1",
                           BMI2,@"level2",nil];

    NSDictionary * dic8 = [NSDictionary dictionaryWithObjectsAndKeys:@"蛋白质(kg)",@"title",
                           [NSString stringWithFormat:@"%.1f",item1.proteinWeight],@"value1",
                           [NSString stringWithFormat:@"%.1f",item2.proteinWeight],@"value2",
                           protein1,@"level1",
                           protein2,@"level2", nil];

    NSDictionary * dic9 = [NSDictionary dictionaryWithObjectsAndKeys:@"骨骼肌(kg)",@"title",
                           [NSString stringWithFormat:@"%.1f",item1.boneMuscleWeight],@"value1",
                           [NSString stringWithFormat:@"%.1f",item2.boneMuscleWeight],@"value2",
                           boneMuscle1,@"level1",
                           boneMuscle2,@"level2", nil];
//水分
    NSDictionary * dic10 = [NSDictionary dictionaryWithObjectsAndKeys:@"水分(kg)",@"title",
                            [NSString stringWithFormat:@"%.1f",item1.waterWeight],@"value1",
                            [NSString stringWithFormat:@"%.1f",item2.waterWeight],@"value2",
                            water1,@"level1",
                            water2,@"level2", nil];
    
//    内脏脂肪
        NSDictionary * dic11 = [NSDictionary dictionaryWithObjectsAndKeys:@"内脂指数",@"title",
                                [NSString stringWithFormat:@"%.1f",item1.visceralFatPercentage],@"value1",
                                [NSString stringWithFormat:@"%.1f",item2.visceralFatPercentage],@"value2",
                                viscerlFat1,@"level1",
                                viscerlFat2,@"level2", nil];
//    肌肉
        NSDictionary * dic12 = [NSDictionary dictionaryWithObjectsAndKeys:@"肌肉(kg)",@"title",
                                [NSString stringWithFormat:@"%.1f",item1.muscleWeight],@"value1",
                                [NSString stringWithFormat:@"%.1f",item2.muscleWeight],@"value2",
                                muscle1,@"level1",
                                muscle2,@"level2", nil];
    
    [_dataArray addObject:dic1];
    [_dataArray addObject:dic2];
    [_dataArray addObject:dic3];
    [_dataArray addObject:dic4];
    [_dataArray addObject:dic5];
    [_dataArray addObject:dic6];
    [_dataArray addObject:dic7];
    [_dataArray addObject:dic8];
    [_dataArray addObject:dic9];
    [_dataArray addObject:dic10];
    [_dataArray addObject:dic11];
    [_dataArray addObject:dic12];

    [self.tableView reloadData];

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

@end
