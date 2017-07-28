//
//  EvaluationDetailDatasCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailSelectedCell.h"
#import "HealthDetailSliderCell.h"
#import "HealthModel.h"
@implementation HealthDetailSelectedCell
{
    UIView * view;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}



- (IBAction)showprogress:(UIButton *)sender {
    
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(getBtnDidClickCount:withCell:)]) {
        [self.delegate getBtnDidClickCount:sender  withCell:self];
    }
    

}



-(void)setUpWithItem:(HealthDetailsItem *)hItem
{

    if (self.tag ==0) {
        self.title1Label.text = @"BMI";
        self.title2Label.text = @"体脂率";
        self.title3Label.text = @"脂肪量";
        self.title4Label.text = @"水分";

        self.value1Label.text = [NSString stringWithFormat:@"%.1f",hItem.bmi];
        self.value2Label.text = [NSString stringWithFormat:@"%.1f%%",hItem.fatPercentage];
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.fatWeight];

        self.value4Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.waterWeight];

        
        
        self.value1Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_BMI];
        
        self.value2Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_FATPERCENT];
        
        self.value3Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_FAT];
        
        self.value4Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_WATER];
        
        
        
        self.selectMark1ImageView.hidden = YES;
        self.selectMark2ImageView.hidden = YES;
        self.selectMark3ImageView.hidden = YES;
        self.selectMark4ImageView.hidden = YES;
        
    }else{
        self.title1Label.text = @"蛋白质";
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.proteinWeight];
        self.value1Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_PROTEIN];
        self.selectMark1ImageView.hidden = YES;
        
        self.title2Label.text = @"肌肉";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.muscleWeight];
        self.value2Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_MUSCLE];
        self.selectMark2ImageView.hidden = YES;
        
        self.title3Label.text = @"骨骼肌";
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.boneMuscleWeight];
        self.value3Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_BONEMUSCLE];
        self.selectMark3ImageView.hidden = YES;
        
        self.title4Label.text = @"内脏脂肪";
        self.value4Label.text = [NSString stringWithFormat:@"%.1f",hItem.visceralFatPercentage];
        self.value4Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_VISCERALFAT];
        self.selectMark4ImageView.hidden = YES;
        
    }
}

-(void)setSliderInfoWithdict:(NSMutableDictionary *)dict
{
    self.markBgImageView.image = [UIImage imageNamed:[dict safeObjectForKey:@"markBg"]];
    self.markLowLabel.text =[dict safeObjectForKey:@"lowText"];
    self.markHighLabel.text =[dict safeObjectForKey:@"HeightText"];
    self.evaluationLabel.textColor = [dict safeObjectForKey:@"color"];
    self.evaluationLabel.text = [dict safeObjectForKey:@"info"];
    
    float x = [[dict safeObjectForKey:@"x"]floatValue];
    
    if (x<21) {
        x=21;
    }
    if (x>JFA_SCREEN_WIDTH-36) {
        x=JFA_SCREEN_WIDTH-36;
    }
    self.markIcon.frame = CGRectMake(x, 142, 30, 30);
}

-(float)getLocationWithMax:(float)maxdd info:(float)locinfo
{
    float width = self.markBgImageView.frame.size.width;
    
    float onedd = width/4*3/maxdd;
    float locdd = onedd * locinfo+20;
    return locdd;
    


}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
