//
//  NewHealthDetailFivthCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailFivthCell.h"
#import "HealthModel.h"
@implementation NewHealthDetailFivthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.status1Label.layer.masksToBounds = YES;
    self.status1Label.layer.cornerRadius = 5;
    self.status2Label.layer.masksToBounds = YES;
    self.status2Label.layer.cornerRadius = 5;
    self.status3Label.layer.masksToBounds = YES;
    self.status3Label.layer.cornerRadius = 5;

    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    self.currItem = item;
    if (self.tag ==1) {//BMI 体重 体脂率
        self.title1Label.text = @"BMI";
        self.value1Label.text = [NSString stringWithFormat:@"%.1f",item.bmi];
        self.value1Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_BMI];


        self.title2Label.text = @"体重";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.weight];
        self.value2Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_BODYWEIGHT];

        
        self.title3Label.text = @"体脂率";
        self.value3Label.text = [NSString stringWithFormat:@"%.1f%%",item.fatPercentage];
        self.value3Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_FATPERCENT];
        
        
    }else if(self.tag==2){//蛋白质  水分  脂肪量
        self.title1Label.text = @"蛋白质";
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",item.proteinWeight];
        self.value1Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_PROTEIN];

        self.title2Label.text = @"水分";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.waterWeight];
        self.value2Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_WATER];

        
        
        
        self.title3Label.text = @"脂肪量";
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",item.fatWeight];
        self.value3Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_FAT];

        
        
        
    }else{//肌肉  基础代谢  内脏脂肪
        
        self.title1Label.text = @"肌肉";
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",item.muscleWeight];
        self.value1Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_MUSCLE];

        self.title2Label.text = @"基础代谢";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.bmr];
        self.value2Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_WATER];

        
        
        self.title3Label.text = @"内脏脂肪";
        self.value3Label.text = [NSString stringWithFormat:@"%.1f",item.visceralFatPercentage];
        self.value3Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_VISCERALFAT];

    }

}
-(void)setDetailViewContentWithButtonIndex:(NSInteger)index
{
    
    switch (index) {
        case 1:
            self.headerImageView.image = getImage(@"BMI1_");
            self.headerNamelb.text = @"BMI";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.bmi];

            break;
        case 2:
            self.headerImageView.image = getImage(@"BMI1_");
            self.headerNamelb.text = @"体重";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.weight];

            break;
        case 3:
            self.headerImageView.image = getImage(@"fat%1_");
            self.headerNamelb.text = @"体脂率";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.visceralFatPercentage];

            break;
        case 4:
            self.headerImageView.image = getImage(@"danBZ1_");
            self.headerNamelb.text = @"蛋白质";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.proteinWeight];

            break;
        case 5:
            self.headerImageView.image = getImage(@"water1_");
            self.headerNamelb.text = @"水分";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.waterWeight];

            break;
        case 6:
            self.headerImageView.image = getImage(@"fat1_");
            self.headerNamelb.text = @"脂肪量";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeight];

            break;
        case 7:
            self.headerImageView.image = getImage(@"jirou1_");
            self.headerNamelb.text = @"肌肉";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.muscleWeight];

            break;
        case 8:
            self.headerImageView.image = getImage(@"daiX1_");
            self.headerNamelb.text = @"基础代谢";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.bmr];

            break;
        case 9:
            self.headerImageView.image = getImage(@"fei_");
            self.headerNamelb.text = @"内脏脂肪";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.visceralFatPercentage];

            break;

        default:
            break;
    }
    
}

- (IBAction)didClickFirst:(id)sender {
    int isShow =0;
    if (self.detailView.hidden ==YES) {
        isShow = 1;
    }else{
        isShow = 2;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickItemWithTag:showDetail:cell:)]) {
        [self.delegate didClickItemWithTag:1 showDetail:isShow cell:self];
    }
}

- (IBAction)didClickSecond:(id)sender {
    int isShow =0;
    if (self.detailView.hidden ==YES) {
        isShow = 1;
    }else{
        isShow = 2;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickItemWithTag:showDetail:cell:)]) {
        [self.delegate didClickItemWithTag:2 showDetail:isShow cell:self];
    }

}

- (IBAction)didClickThird:(id)sender {
    int isShow =0;
    if (self.detailView.hidden ==YES) {
        isShow = 1;
    }else{
        isShow = 2;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickItemWithTag:showDetail:cell:)]) {
        [self.delegate didClickItemWithTag:3 showDetail:isShow cell:self];
    }

}


-(float)getlocationDianL:(float)dian WithDian:(float)left right:(float)right
{
    float width = (JFA_SCREEN_WIDTH -60)/3;

    if (dian<left) {
        float loW = 30+(width/left*dian);
        return loW;
    }
    else if (dian>left &&dian<right)
    {
        float loW = 30+width +(width/(right-left)*(dian-left));
        return loW;
    }else{
        float loW = 30+width*2+(width/50*(dian-right));
        return loW;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
