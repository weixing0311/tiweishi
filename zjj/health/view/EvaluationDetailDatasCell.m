//
//  EvaluationDetailDatasCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "EvaluationDetailDatasCell.h"
@implementation EvaluationDetailDatasCell
{
    UIButton * selectedBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UIColor *)returnColorWithLevel:(int)level
{
    switch (level) {
        case 1:
        return[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
            break;
        case 2:
            return[UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1];
            break;
        case 3:
            return[UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1];
            break;
           
        default:
            break;
    }
    return nil;
}

- (IBAction)showprogress:(UIButton *)sender {
    
    UIButton *button = (UIButton *)sender;
    if (selectedBtn ==button) {
        if (selectedBtn.selected ==YES) {
            selectedBtn.selected =NO;
        }else{
            selectedBtn.selected =YES;
        }
        selectedBtn=nil;
        return;
    }
    selectedBtn.selected = NO;
    selectedBtn = button;
    selectedBtn.selected = YES;
}

-(void)setUpWithItem:(HealthDetailsItem *)hItem
{

    if (self.tag ==0) {
        self.title1Label.text = @"BMI";
        self.value1Label.text = [NSString stringWithFormat:@"%.1f",hItem.bmi];
        self.value1Label.textColor = [self returnColorWithLevel:hItem.bmiLevel];
        self.selectMark1ImageView.hidden = YES;
        
        self.title2Label.text = @"体脂率";
        self.value2Label.text = [NSString stringWithFormat:@"%.1f%%",hItem.mFat];
        self.value2Label.textColor = [self returnColorWithLevel:hItem.fatWeightLevel];
        self.selectMark2ImageView.hidden = YES;
        
        self.title3Label.text = @"脂肪量";
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.fatPercentage];
        self.value3Label.textColor = [self returnColorWithLevel:hItem.fatPercentageLevel];
        self.selectMark3ImageView.hidden = YES;
        
        self.title4Label.text = @"水分";
        self.value4Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.mWater];
        self.value4Label.textColor = [self returnColorWithLevel:hItem.waterLevel];
        self.selectMark4ImageView.hidden = YES;

    }else{
        self.title1Label.text = @"蛋白质";
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.proteinWeight];
        self.value1Label.textColor = [self returnColorWithLevel:hItem.waterLevel];
        self.selectMark1ImageView.hidden = YES;
        
        self.title2Label.text = @"肌肉";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.muscleWeight];
        self.value2Label.textColor = [self returnColorWithLevel:hItem.muscleLevel];
        self.selectMark2ImageView.hidden = YES;
        
        self.title3Label.text = @"骨骼肌";
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.mBone];
        self.value3Label.textColor = [self returnColorWithLevel:hItem.boneLevel];
        self.selectMark3ImageView.hidden = YES;
        
        self.title4Label.text = @"内脏脂肪";
        self.value4Label.text = [NSString stringWithFormat:@"%.1f",hItem.visceralFatPercentage];
        self.value4Label.textColor = [self returnColorWithLevel:hItem.visceralFatPercentageLevel];
        self.selectMark4ImageView.hidden = YES;

    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
