//
//  NewHealthDetailFivthCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailFivthCell.h"
#import "HealthModel.h"

#define warningColor   [UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1]
#define normalColor    [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1]
#define seriousColor   [UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1]

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
        self.status1Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_BMI item:item];

        self.title2Label.text = @"脂肪量";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.fatWeight];
        self.status2Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_FAT item:item];
        
        self.title3Label.text = @"体脂率";
        self.value3Label.text = [NSString stringWithFormat:@"%.1f%%",item.fatPercentage];
        self.status3Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_FATPERCENT item:item];
        
        
    }else if(self.tag==2){//蛋白质  水分  脂肪量
        self.title1Label.text = @"蛋白质";
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",item.proteinWeight];
        self.status1Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_PROTEIN item:item];
        
        self.title2Label.text = @"骨骼肌";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.boneMuscleWeight];
        self.status2Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_BONEMUSCLE item:item];

        self.title3Label.text = @"水分";
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",item.waterWeight];
        self.status3Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_WATER item:item];

        
    }else{//肌肉  基础代谢  内脏脂肪
        
        self.title1Label.text = @"肌肉";
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",item.muscleWeight];
        self.status1Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_MUSCLE item:item];

        self.title2Label.text = @"基础代谢";
        self.value2Label.text = [NSString stringWithFormat:@"%.1f",item.bmr];
        self.status2Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_WATER item:item];

        
        
        self.title3Label.text = @"内脏脂肪";
        self.value3Label.text = [NSString stringWithFormat:@"%.1f",item.visceralFatPercentage];
        self.status3Label.backgroundColor = [self getHealthDetailColorWithStatus:IS_MODEL_VISCERALFAT item:item];

    }
    
    self.status1Label.text = [self getTextWithColor:self.status1Label.backgroundColor];
    self.status2Label.text = [self getTextWithColor:self.status2Label.backgroundColor];
    self.status3Label.text = [self getTextWithColor:self.status3Label.backgroundColor];

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
           
            self.headerImageView.image = getImage(@"fat1_");
            self.headerNamelb.text = @"脂肪量";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            
            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.fatWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeightMax];
            
            currX = [self getlocationDianL:self.currItem.fatWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];


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
            self.headerImageView.image = getImage(@"bone1_");
            self.headerNamelb.text = @"骨骼肌";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            
            self.sliderLislb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeightMax];
            
            currX = [self getlocationDianL:self.currItem.boneMuscleWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 6:
            
            self.headerImageView.image = getImage(@"water1_");
            self.headerNamelb.text = @"水分";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.waterWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            
            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.waterWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.waterWeightMax];
            
            currX = [self getlocationDianL:self.currItem.waterWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];


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


-(NSString *)getTextWithColor:(UIColor *)color
{
    
    if (CGColorEqualToColor(color.CGColor, normalColor.CGColor)) {
        return @"正常";
    }else if (CGColorEqualToColor(color.CGColor, warningColor.CGColor))
    {
        return @"偏低";
    }else{
        return @"高";
    }
}

-(UIColor *)getHealthDetailColorWithStatus:(isMyType)myType item:(HealthDetailsItem*)item
{
    //    SubProjectItem * subItem = [[SubProjectItem alloc]init];
    switch (myType) {
        case IS_MODEL_BMI:
            switch (item.bmiLevel) {
                case 1:
                    return warningColor;
                    break;
                case 2:
                    return normalColor;
                    break;
                case 3:
                    return seriousColor;
                    break;
                case 4:
                    return warningColor;
                    break;
                    
                default:
                    break;
            }
        case IS_MODEL_FATPERCENT:
            switch (item.fatPercentageLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                case 3:
                    return seriousColor;
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_MODEL_FAT:
            switch (item.fatWeightLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                case 3:
                    return seriousColor;
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_MODEL_WATER:
            switch (item.waterLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_MODEL_PROTEIN:
            switch (item.proteinLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                default:
                    break;
            }
            
            
            break;
        case IS_MODEL_MUSCLE:
            switch (item.muscleLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                    
                    
                default:
                    break;
            }
            
            
            break;
        case IS_MODEL_BONEMUSCLE:
            switch (item.boneMuscleLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                    
                default:
                    break;
            }
            break;
            
            
        case IS_MODEL_VISCERALFAT:
            switch (item.visceralFatPercentageLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                case 3:
                    return seriousColor;
                    break;
                default:
                    break;
            }
            break;
        case IS_MODEL_BONE:
            switch (item.boneLevel) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
