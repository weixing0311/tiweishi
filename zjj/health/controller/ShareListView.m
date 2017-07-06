//
//  ShareTrendView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShareTrendView.h"
#import "ShareHealthItem.h"
#import "NSString+dateWithString.h"
#import "ShareTrendCell.h"
#import "NSDate+CustomDate.h"
@implementation ShareTrendView
{
    NSMutableArray * _dataArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.layer.borderWidth = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _dataArray = [NSMutableArray array];
    [self createInfo];
    [self.tableView reloadData];
}

-(void)setInfoWithArr:(NSMutableArray *) arr
{
    [_dataArray addObjectsFromArray:[self paixuWithArr:arr]];

    ShareHealthItem * item1 = [_dataArray objectAtIndex:0];
    ShareHealthItem * item2 = [_dataArray objectAtIndex:1];
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl]];
    self.nameLabel.text = [SubUserItem shareInstance].nickname;
    
    self.date1Label.text = [item1.createTime yyyymmdd];
    
    self.date2Label.text = [item2.createTime yyyymmdd];
    
    
    
    
    
    self.dateCountLabel.text = [NSString stringWithFormat:@"%d",[self gettimeXWithTime1:item1.createTime time2:item2.createTime]];
    
        
        // 减脂量
    
    float fatChangeWeight = item1.fatWeight -item2.fatWeight;
    NSMutableAttributedString * fatChangeWeightAttStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1fkg",fabsf(fatChangeWeight)]];
    [fatChangeWeightAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(fatChangeWeightAttStr.length-3, 3)];
    
    self.fatChangeLabel.attributedText = fatChangeWeightAttStr;
        self.fatChangeNameLabel.text = fatChangeWeight <= 0 ? @"减脂" : @"增脂";
        
        // 减重量
    
    
    float weightChange = item1.weight -item2.weight;
    NSMutableAttributedString * WeightChangeAttStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1fkg",fabsf(weightChange)]];
    [fatChangeWeightAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(fatChangeWeightAttStr.length-3, 3)];
    
    self.weightChangeLabel.attributedText = WeightChangeAttStr;
    self.weightChangeNameLabel.text = WeightChangeAttStr <= 0 ? @"减重" : @"增重";

    
     self.generateTimeLabel.text = [NSString stringWithFormat:@"%@",[[NSDate date] yyyymmddhhmmss]];

//    if qrCodeImage != nil {
//        self.qrCodeImageView.image = qrCodeImage!
//    }
    
//    return view
//}



}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ShareTrendCell";
    ShareTrendCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray * arr =[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil];
        cell = [arr lastObject];
    }
    NSDictionary * dic =[_dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dic safeObjectForKey:@"title"];
    cell.value1Label.text = [dic safeObjectForKey:@"value1"];
    cell.value2Label.text = [dic safeObjectForKey:@"value2"];
    cell.value1StatusLabel.text = [dic safeObjectForKey:@"level1"];
    cell.value2StatusLabel.text = [dic safeObjectForKey:@"level2"];
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
-(int)gettimeXWithTime1:(NSString *)tiem1 time2:(NSString *)time2
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:tiem1];
    NSDate *endD = [date dateFromString:time2];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int day = (int)value / (24 * 3600);
    return  day;
}

-(NSArray *)paixuWithArr:(NSMutableArray *)arr
{
    NSArray *sortArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        ShareHealthItem * item1 = obj1;
        ShareHealthItem * item2 = obj2;
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
        
        NSDate *date1= [dateFormatter dateFromString:item1.createTime];
        NSDate *date2= [dateFormatter dateFromString:item2.createTime];
        
        
        
        NSComparisonResult result = [date1 compare:date2];
        return  result = NSOrderedAscending;
//        if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
//            
//            return NSOrderedDescending;//降序
//            
//        }else if (date1 == [date1 laterDate: date2]) {
//            return NSOrderedAscending;//升序
//            
//        }else{
//            return NSOrderedSame;//相等  
//        }  
        
    }];
    return sortArray;
}

-(void)createInfo
{
    
    ShareHealthItem * item1 = _dataArray[0];
    ShareHealthItem * item2 = _dataArray[1];

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
    NSString *boneMuscle1 =[[ShareHealthItem shareInstance] getHeightWithLevel:item1.boneLevel status:IS_SAME];
    NSString *boneMuscle2 =[[ShareHealthItem shareInstance] getHeightWithLevel:item2.boneLevel status:IS_SAME];

    
    
    
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"身体年龄",@"title",item1.bodyAge,@"value1",item2.bodyAge,@"value2", nil];
    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"基础代谢 ",@"title",item1.bmr,@"value1",item2.bmr,@"value2", nil];

    NSDictionary * dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"体重(kg)",@"title",item1.weight,@"value1",item2.weight,@"value2",weightStatus1,@"level1",weightStatus2,@"level2", nil];

    NSDictionary * dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"肥胖等级",@"title",[self getwl:item1.weightLevel],@"value1",[self getwl:item2.weightLevel],@"value2",weightStatus1,@"level1",weightStatus1,@"level2", nil];

    NSDictionary * dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@"体脂率(%)",@"title",item1.fatPercentage,@"value1",item2.fatPercentage,@"value2",fatpercent1,@"level1",fatpercent2,@"level2", nil];

    NSDictionary * dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@"脂肪量(kg)",@"title",item1.fatWeight,@"value1",item2.fatWeight,@"value2", fatLevel1,@"level1",fatLevel2,@"level2",nil];

    NSDictionary * dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@"BMI",@"title",item1.bmi,@"value1",item2.bmi,@"value2", BMI1,@"level1",BMI2,@"level2",nil];

    NSDictionary * dic8 = [NSDictionary dictionaryWithObjectsAndKeys:@"蛋白质(kg)",@"title",item1.proteinWeight,@"value1",item2.proteinWeight,@"value2",protein1,@"level1",protein2,@"level2", nil];

    NSDictionary * dic9 = [NSDictionary dictionaryWithObjectsAndKeys:@"骨骼肌(kg)",@"title",item1.bodyAge,@"value1",item2.bodyAge,@"value2",boneMuscle1,@"level1",boneMuscle2,@"level2", nil];


    
    [_dataArray addObject:dic1];
    [_dataArray addObject:dic2];
    [_dataArray addObject:dic3];
    [_dataArray addObject:dic4];
    [_dataArray addObject:dic5];
    [_dataArray addObject:dic6];
    [_dataArray addObject:dic7];
    [_dataArray addObject:dic8];
    [_dataArray addObject:dic9];
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
            levelStr = [NSString stringWithFormat:@"轻度肥胖"];
            break;
        case 4:
            levelStr = [NSString stringWithFormat:@"中度肥胖重"];
            break;
        case 5:
            levelStr = [NSString stringWithFormat:@"重度肥胖"];
            break;
        case 6:
            levelStr = [NSString stringWithFormat:@"极度肥胖"];
            break;
            
        default:
            break;
    }
    return levelStr;

}

@end
