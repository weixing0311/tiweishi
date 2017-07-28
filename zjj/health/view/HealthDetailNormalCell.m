//
//  EvaluationDetailDatasCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailNormalCell.h"
#import "HealthDetailSliderCell.h"
#import "HealthModel.h"
@implementation HealthDetailNormalCell
{
    UIView * view;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}


- (IBAction)showprogress:(UIButton *)sender {
    
    if (self.tag ==2) {
        return;
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(getButtonDidClickCount:withCell:)]) {
        [self.delegate getButtonDidClickCount:sender  withCell:self];
    }

    
    
}


-(void)buildTableView
{
    if (!_tableview) {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 117, JFA_SCREEN_WIDTH, 125) style:UITableViewStylePlain];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        self.tableview.userInteractionEnabled = NO;
        self.tableview.scrollEnabled = NO;
        [self.contentView addSubview:self.tableview];
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

    }else if(self.tag==1){
        self.title1Label.text = @"蛋白质";
        self.title2Label.text = @"肌肉";
        self.title3Label.text = @"骨骼肌";
        self.title4Label.text = @"内脏脂肪";


        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.proteinWeight];
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.muscleWeight];
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.boneMuscleWeight];
        self.value4Label.text = [NSString stringWithFormat:@"%.1f",hItem.visceralFatPercentage];

        
        self.value1Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_PROTEIN];
        
        self.value2Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_MUSCLE];
        
        self.value3Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_BONEMUSCLE];
        
        self.value4Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_VISCERALFAT];
        
        
        self.selectMark1ImageView.hidden = YES;
        self.selectMark2ImageView.hidden = YES;
        self.selectMark3ImageView.hidden = YES;
        self.selectMark4ImageView.hidden = YES;

    }else{
        self.title1Label.text = @"标准体重";
        self.title2Label.text = @"体重控制量";
        self.title3Label.text = @"去脂体重";
        self.title4Label.text = @"去脂控制量";
        
        
        
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.standardWeight];
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.weightControl];
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.lbm];
        self.value4Label.text = [NSString stringWithFormat:@"%.1fkg",hItem.fatControl];

        
        
        self.value1Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
        self.value2Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
        self.value3Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
        
        
        self.value4Label.textColor = [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];

        self.selectMark1ImageView.hidden = YES;
        self.selectMark2ImageView.hidden = YES;
        self.selectMark3ImageView.hidden = YES;
        self.selectMark4ImageView.hidden = YES;

        
        
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
