//
//  HealthMainCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthMainCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "HealthModel.h"
#import "NSString+dateWithString.h"

@implementation HealthMainCell
{
    CBCentralManager *CM;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.title1Label.adjustsFontSizeToFitWidth = YES;
    self.title2Label.adjustsFontSizeToFitWidth = YES;
    self.title3Label.adjustsFontSizeToFitWidth = YES;
    self.title4Label.adjustsFontSizeToFitWidth = YES;
    
    
    
    // Initialization code
}
-(void)setUpInfo:(HealthItem*)item
{
    self.emptyInfoLabel.hidden = YES;
    // 体重
    NSMutableAttributedString * weightAttStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1fkg", item.weight]];
    DLog(@"%@",weightAttStr);
    [weightAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(weightAttStr.length - 3, 3)];
    [weightAttStr addAttribute:NSFontAttributeName  value: [UIFont systemFontOfSize:25]  range: NSMakeRange(0, 2)];
    self.weightLabel.attributedText = weightAttStr;
    
    // 内脂
    NSMutableAttributedString *  visceralFatWeightAttStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f", item.visceralFatPercentage]] ;
    self.visceralFatWeightLabel.attributedText = visceralFatWeightAttStr;
    
    // 内脂警告判断
    self.visceralFatWeightLabel.textColor = [[HealthModel shareInstance]getHealthHeaderColorWithStatus:IS_MODEL_VISCERALFAT item:item];

    if (item.visceralFatPercentageLevel == 2) {
        self.warningTipLabel.hidden = NO;
        self.warningTipImageView.hidden = NO;
        
        self.warningTipLabel.text = @"预警";
        self.warningTipImageView.image = [UIImage imageNamed:@"warning_tip_bg"];
    }
    else if (item.visceralFatPercentageLevel == 3) {
        self.warningTipLabel.hidden =  NO;
        self.warningTipImageView.hidden =  NO;
        
        self.warningTipLabel.text = @"警告";
        self.warningTipImageView.image = [UIImage imageNamed:@"danger_tip_bg"];
    }
    else {
        self.warningTipLabel.hidden = YES;
        self.warningTipImageView.hidden = YES;
    }
    
    // 体脂
    NSMutableAttributedString * fatWeightAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1fkg", item.fatWeight]];
    
    [fatWeightAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(fatWeightAttStr.length - 4, 4)];
    [weightAttStr addAttribute:NSFontAttributeName  value: [UIFont systemFontOfSize:22]  range: NSMakeRange(0, 2)];

    self.fatWeight.attributedText = fatWeightAttStr;

    
    
    // 体脂 警告判断
    
    
    if (item.fatWeightLevel == 2) {
        self.dangerTipLabel.hidden = NO;
        self.dangerTipImageView.hidden = NO;
        
        self.dangerTipLabel.text = @"预警";
        self.dangerTipImageView.image = [UIImage imageNamed:@"warning_tip_bg"];
    }
    else if (item.fatWeightLevel == 3) {
        self.dangerTipLabel.hidden = NO;
        self.dangerTipImageView.hidden = NO;
        
        self.dangerTipLabel.text = @"警告";
        self.dangerTipImageView.image = [UIImage imageNamed:@"danger_tip_bg"];
    }
    else {
        self.dangerTipLabel.hidden = YES;
        self.dangerTipImageView.hidden = YES;
    }
    self.fatWeight.textColor = [[HealthModel shareInstance]getHealthHeaderColorWithStatus:IS_MODEL_FAT item:item];
    
    
    // 趋势提示
    if (item.weight) {
        float weightChange = item.weight - item.lastWeight;
        DLog(@"%f--%f",item.weight,item.lastWeight);
        self.trendLabel.text = [NSString stringWithFormat:@"%.1fkg",fabsf(weightChange)];
        self.trendArrowImageView.image =[UIImage imageNamed:weightChange>0?@"trand_up_icon":@"trand_down_icon"];
        self.trendArrowImageView.hidden = NO;
    }
    else {
        self.trendArrowImageView.hidden = YES;
        self.trendLabel.text = @"-";
    }
    DLog(@"%@", self.trendArrowImageView);
    if (item.weightLevel==1||item.weightLevel==3||item.weightLevel==4) {
        self.weightBgImageView.image = [UIImage imageNamed:@"warning_bg"];
        [self.scaleButton setBackgroundImage:[UIImage imageNamed:@"warning_button"] forState:UIControlStateNormal];
    }
    else if (item.weightLevel==5||item.weightLevel==6) {
        self.weightBgImageView.image = [UIImage imageNamed:@"danger_bg"];
        [self.scaleButton setBackgroundImage:[UIImage imageNamed:@"danger_button"] forState:UIControlStateNormal];

    }
    else {
        self.weightBgImageView.image = [UIImage imageNamed:@"health_bg"];
        [self.scaleButton setBackgroundImage:[UIImage imageNamed:@"health_button"] forState:UIControlStateNormal];
    }
    
    self.heightLabel.text = [NSString stringWithFormat:@"身高：%.0fcm",[UserModel shareInstance].heigth];
    self.agelabel.text = [NSString stringWithFormat:@"年龄：%d",[UserModel shareInstance].age];
    self.bmrLabel.text = [NSString stringWithFormat:@"基础代谢: %.0f",item.bmr];
    self.bmrAgeLabel.text = [NSString stringWithFormat:@"身体年龄: %.0f",item.bodyAge];
    self.timeLabel.text = [item.createTime yyyymmdd];
    
    self.title1Label.text = @"最佳体重";
    self.title2Label.text = @"最佳体脂率";
    self.title3Label.text = @"最佳体脂";
    self.title4Label.text = @"最佳内脂";
    
    float fatWeightV =0.0;
    float visceral = 0.0;
    int sex = [UserModel shareInstance].gender;
    if (sex ==1) {
        fatWeightV = 0.2f;
        visceral = 8;
    }else{
        visceral = 6;
        fatWeightV = 0.24f;
    }
    
    
    
    float target1 = item.standardWeight-item.weight<=0?item.standardWeight-item.weight:-0;
    float target2 = fatWeightV*100-item.fatPercentage*100<=0?fatWeightV*100-item.fatPercentage*100:-0;
    float target3 = target2 <=0?fatWeightV*item.standardWeight-item.fatPercentage*item.weight:-0;
    float target4 = visceral -item.visceralFatPercentage<=0?visceral-item.visceralFatPercentage:-0;

    self.value1Label.text =[NSString stringWithFormat:@"%.1fkg",target1];
    self.value2Label.text =[NSString stringWithFormat:@"%.1f%%",target2];
    self.value3Label.text =[NSString stringWithFormat:@"%.1fkg",target3];
    self.value4Label.text =[NSString stringWithFormat:@"%.1f",target4];

    self.target1label.text =[NSString stringWithFormat:@"%.1fkg",item.standardWeight];
    self.target2label.text =[NSString stringWithFormat:@"%.1f%%",fatWeightV*100];
    self.target3label.text =[NSString stringWithFormat:@"%.1fkg",item.standardWeight *fatWeightV];
    self.target4label.text =[NSString stringWithFormat:@"%.1f",visceral];

    
    

    
    
    self.value1Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
    self.value2Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
    self.value3Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
    self.value4Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
    
    
    self.target1label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
    self.target2label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
    self.target3label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
    self.target4label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];

    
}



-(void)clearView
{
    self.weightLabel.text = @"0kg";
    self.visceralFatWeightLabel.text = @"0kg";
    self.fatWeight.text = @"0kg";
    self.trendLabel.text = @"0kg";
    
    self.dangerTipImageView.hidden = YES;
    self.dangerTipLabel.hidden = YES;
    
    self.warningTipImageView.hidden = YES;
    self.warningTipLabel.hidden = YES;
    
    self.weightBgImageView.image = [UIImage imageNamed:@"health_bg"];
    [self.scaleButton setBackgroundImage:[UIImage imageNamed:@"health_button"] forState:UIControlStateNormal];
    self.emptyInfoLabel.hidden = NO;
    self.timeLabel.text = @"";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initBlueTooth
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    });
}

- (IBAction)didScale:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didUpdateinfo)]) {
        [self.delegate didUpdateinfo];
    }
    NSLog(@"上秤");
}
- (IBAction)showWeight:(id)sender {
    NSLog(@"进入下级页面");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterDetailView)]) {
        [self.delegate enterDetailView];
    }
}

- (IBAction)didShare:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShare)]) {
        [self.delegate didShare];
    }
}
- (IBAction)didEnterChart:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEnterChart)]) {
        [self.delegate didEnterChart];
    }
}
@end
