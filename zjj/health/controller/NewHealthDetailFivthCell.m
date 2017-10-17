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


        self.title2Label.text = @"骨骼肌";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.boneMuscleWeight];
        self.value2Label.textColor = [[HealthModel shareInstance] getHealthDetailColorWithStatus:IS_MODEL_BONEMUSCLE];

        
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
    float currX;
    switch (index) {
        case 1:
            self.headerImageView.image = getImage(@"BMI1_");
            self.headerNamelb.text = @"BMI";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.bmi];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            
            self.sliderLislb.text = @"18.5";
            self.sliderMorlb.text = @"24";
            
            currX = [self getlocationDianL:self.currItem.bmi  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 2:
            
            self.headerImageView.image = getImage(@"bone1_");
            self.headerNamelb.text = @"骨骼肌";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            self.sliderLislb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeightMax];
            
            currX = [self getlocationDianL:self.currItem.boneMuscleWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 3:
            self.headerImageView.image = getImage(@"fat%1_");
            self.headerNamelb.text = @"体脂率";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            
            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.fatWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeightMax];
            
            currX = [self getlocationDianL:self.currItem.fatWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 4:
            self.headerImageView.image = getImage(@"danBZ1_");
            self.headerNamelb.text = @"蛋白质";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.proteinWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.proteinWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.proteinWeightMax];
            
            currX = [self getlocationDianL:self.currItem.proteinWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 5:
            self.headerImageView.image = getImage(@"water1_");
            self.headerNamelb.text = @"水分";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.waterWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.waterWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.waterWeightMax];
            
            currX = [self getlocationDianL:self.currItem.waterWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 6:
            self.headerImageView.image = getImage(@"fat1_");
            self.headerNamelb.text = @"脂肪量";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.fatWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeightMax];
            
            currX = [self getlocationDianL:self.currItem.fatWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];


            break;
        case 7:
            self.headerImageView.image = getImage(@"jirou1_");
            self.headerNamelb.text = @"肌肉";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.muscleWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.muscleWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.muscleWeightMax];
            
            currX = [self getlocationDianL:self.currItem.muscleWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 8:
            self.headerImageView.image = getImage(@"daiX1_");
            self.headerNamelb.text = @"基础代谢";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.bmr];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            currX = [self getlocationDianL:self.currItem.visceralFatPercentage  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 9:
            self.headerImageView.image = getImage(@"fei_");
            self.headerNamelb.text = @"内脏脂肪";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.visceralFatPercentage];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            self.sliderLislb.text =@"10";
            self.sliderMorlb.text = @"14";
            
            currX = [self getlocationDianL:self.currItem.visceralFatPercentage Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;

        default:
            self.headerImageView.image = getImage(@"");
            self.headerNamelb.text = @"";
            self.secondTitle.text = @"";
            self.secondHeadImage.image = self.headerImageView.image;
            
            self.sliderLislb.text =@"";
            self.sliderMorlb.text = @"";
            
            currX = 30;

            break;
    }
    self.headerContentlb.text = [[HealthDetailsItem instance]getinstructionsWithType:index];
    self.headerContentlb.adjustsFontSizeToFitWidth =YES;
    NSString * contentStr =[[HealthDetailsItem instance]getHealthDetailShuoMingWithStatus:index item:self.currItem];
    self.secondContent.text = contentStr;
    self.sliderIconImage.frame = CGRectMake(currX, self.sliderBgView.bounds.size.height/2-10, 20, 20);

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




-(float)getlocationDianL:(float)dian Withleft:(float)left right:(float)right
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
