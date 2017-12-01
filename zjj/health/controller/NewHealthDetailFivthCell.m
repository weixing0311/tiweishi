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
    self.status1Label.layer.cornerRadius = 2;
    self.status2Label.layer.masksToBounds = YES;
    self.status2Label.layer.cornerRadius = 2;
    self.status3Label.layer.masksToBounds = YES;
    self.status3Label.layer.cornerRadius = 2;

    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    self.currItem = item;
    if (self.tag ==1) {//BMI 体重 体脂率
        self.title1Label.text = @"体脂率";
        self.value1Label.text = [NSString stringWithFormat:@"%.1f%%",item.fatPercentage];
        self.status1Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_FATPERCENT item:item];


        self.title2Label.text = @"脂肪量";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.fatWeight];
        self.status2Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_FAT item:item];
        
        self.title3Label.text = @"内脏脂肪";
        self.value3Label.text = [NSString stringWithFormat:@"%.1f",item.visceralFatPercentage];
        self.status3Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_VISCERALFAT item:item];

        
    }else if(self.tag==2){//蛋白质  水分  脂肪量
        self.title1Label.text = @"肌肉";
        self.value1Label.text = [NSString stringWithFormat:@"%.1fkg",item.muscleWeight];
        self.status1Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_MUSCLE item:item];

        self.title2Label.text = @"蛋白质";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.proteinWeight];
        self.status2Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_PROTEIN item:item];
        
        self.title3Label.text = @"骨量";
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",item.boneWeight];
        self.status3Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_BONE item:item];


        
    }else{//肌肉  基础代谢  内脏脂肪
        self.title1Label.text = @"BMI";
        self.value1Label.text = [NSString stringWithFormat:@"%.1f",item.bmi];
        self.status1Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_BMI item:item];


        self.title2Label.text = @"骨骼肌";
        self.value2Label.text = [NSString stringWithFormat:@"%.1fkg",item.boneMuscleWeight];
        self.status2Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_BONEMUSCLE item:item];

        self.title3Label.text = @"水分";
        self.value3Label.text = [NSString stringWithFormat:@"%.1fkg",item.waterWeight];
        self.status3Label.text = [self getHealthDetailStatusTextWithStatus:IS_MODEL_WATER item:item];

        
    }
    
    self.status1Label.backgroundColor = [self getColorWithString:self.status1Label.text];
    self.status2Label.backgroundColor = [self getColorWithString:self.status2Label.text];
    self.status3Label.backgroundColor = [self getColorWithString:self.status3Label.text];

}
-(void)setDetailViewContentWithButtonIndex:(NSInteger)index
{
    float currX;
    switch (index) {
        case 1:
            self.headerImageView.image = getImage(@"fat%1_");
            self.headerNamelb.text = @"体脂率";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f%%",self.currItem.fatPercentage];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            
            self.sliderBgImageView.image = getImage(@"sliderBg2_");
            
            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f%%",self.currItem.fatPercentageMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f%%",self.currItem.fatPercentageMax];
            
            currX = [self getlocationDianL:self.currItem.fatPercentage  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 2:
           
            self.headerImageView.image = getImage(@"fat1_");
            self.headerNamelb.text = @"脂肪量";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.fatWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            self.sliderBgImageView.image = getImage(@"sliderBg2_");

            self.sliderLislb.text =[NSString stringWithFormat:@"%.1fkg",self.currItem.fatWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1fkg",self.currItem.fatWeightMax];
            
            
            
            currX = [self getlocationDianL:self.currItem.fatWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];


            break;
        case 3:
            self.headerImageView.image = getImage(@"fei1_");
            self.headerNamelb.text = @"内脏脂肪";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.visceralFatPercentage];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            self.sliderBgImageView.image = getImage(@"sliderBg4_");
            
            self.sliderLislb.text =@"10";
            self.sliderMorlb.text = @"14";
            
            currX = [self getlocationDianL:self.currItem.visceralFatPercentage Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 4:
            
            self.headerImageView.image = getImage(@"jirou1_");
            self.headerNamelb.text = @"肌肉";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.muscleWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            self.sliderBgImageView.image = getImage(@"sliderBg3_");
            
            self.sliderLislb.text =[NSString stringWithFormat:@"%.1fkg",self.currItem.muscleWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1fkg",self.currItem.muscleWeightMax];
            
            currX = [self getlocationDianL:self.currItem.muscleWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];


            break;
        case 5:
            self.headerImageView.image = getImage(@"danBZ1_");
            self.headerNamelb.text = @"蛋白质";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.proteinWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            self.sliderBgImageView.image = getImage(@"sliderBg3_");
            
            self.sliderLislb.text =[NSString stringWithFormat:@"%.1fkg",self.currItem.proteinWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1fkg",self.currItem.proteinWeightMax];
            
            currX = [self getlocationDianL:self.currItem.proteinWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 6:

            self.headerImageView.image = getImage(@"bone1_");
            self.headerNamelb.text = @"骨量";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            self.sliderBgImageView.image = getImage(@"sliderBg3_");
            self.sliderLislb.text = [NSString stringWithFormat:@"%.1fkg",self.currItem.boneWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1fkg",self.currItem.boneWeightMax];
            
            currX = [self getlocationDianL:self.currItem.boneWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];


            break;
        case 7:
            self.headerImageView.image = getImage(@"BMI1_");
            self.headerNamelb.text = @"BMI";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.bmi];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            
            self.sliderLislb.text = @"18.5";
            self.sliderMorlb.text = @"24";
            self.sliderBgImageView.image = getImage(@"sliderBg2_");
            currX = [self getlocationDianL:self.currItem.bmi  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 8:
            self.headerImageView.image = getImage(@"boneMuscle1_");
            self.headerNamelb.text = @"骨骼肌";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeight];
            self.sliderBgImageView.image = getImage(@"sliderBg3_");

            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;

            self.sliderLislb.text =[NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1f",self.currItem.boneMuscleWeightMax];

            currX = [self getlocationDianL:self.currItem.boneMuscleWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];

            break;
        case 9:
            self.headerImageView.image = getImage(@"water1_");
            self.headerNamelb.text = @"水分";
            self.headerValuelb.text = [NSString stringWithFormat:@"%.1f",self.currItem.waterWeight];
            self.secondTitle.text = self.headerNamelb.text;
            self.secondHeadImage.image = self.headerImageView.image;
            self.sliderBgImageView.image = getImage(@"sliderBg3_");
            
            self.sliderLislb.text =[NSString stringWithFormat:@"%.1fkg",self.currItem.waterWeightMin];
            self.sliderMorlb.text = [NSString stringWithFormat:@"%.1fkg",self.currItem.waterWeightMax];
            
            currX = [self getlocationDianL:self.currItem.waterWeight  Withleft:[self.sliderLislb.text floatValue] right:[self.sliderMorlb.text floatValue]];


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
    
    if (index==3) {
        _leftlb.text = @"正常";
        _midlb.text = @"超标";
        _rightlb.text = @"高";
    }else{
        _leftlb.text = @"偏低";
        _midlb.text = @"正常";
        _rightlb.text = @"偏高";

    }
    
    
    self.headerContentlb.text = [[HealthDetailsItem instance]getinstructionsWithType:index];
    self.headerContentlb.adjustsFontSizeToFitWidth =YES;
    NSString * contentStr =[[HealthDetailsItem instance]getHealthDetailShuoMingWithStatus:index item:self.currItem];
    self.secondContent.text = contentStr;
    self.sliderIconImage.frame = CGRectMake(30+currX, self.sliderBgView.bounds.size.height/2-10, 20, 20);

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




-(double)getlocationDianL:(float)dian Withleft:(float)min right:(float)max
{
    float width = JFA_SCREEN_WIDTH-60;//总长度
    float start  = min-(max-min);//起始位置数值
    float end    = max+(max-min);//终点位置数值
    float one     = width/(end-start); //单点数值所占长度
    
    
    if (dian<start||dian==start) {
        return 0;
    }
    else if (dian>end||dian==end) {
        return width;
    }else{
        DLog(@"点坐标:--%f  min%.1f max %.1f",(dian-start)*one,(min-start)*one,(max-start)*one);
        return (dian-start)* one;
    }
    
}


-(UIColor *)getColorWithString:(NSString *)string
{
    
    if ([string isEqualToString:@"偏低"]||[string isEqualToString:@"偏高"]||[string isEqualToString:@"超标"]||[string isEqualToString:@"低"]) {
        return warningColor;
    }
    else if ([string isEqualToString:@"正常"])
    {
        return normalColor;
    }else{
        return seriousColor;
    }
    
//    if (CGColorEqualToColor(color.CGColor, normalColor.CGColor)) {
//        return @"正常";
//    }else if (CGColorEqualToColor(color.CGColor, warningColor.CGColor))
//    {
//        return @"偏低";
//    }else{
//        return @"高";
//    }
}

-(NSString *)getHealthDetailStatusTextWithStatus:(isMyType)myType item:(HealthDetailsItem*)item
{
    //    SubProjectItem * subItem = [[SubProjectItem alloc]init];
    //肌肉\骨骼肌\水分\蛋白质\骨重判定标准
    switch (myType) {
        case IS_MODEL_BMI:
            switch (item.bmiLevel) {
                case 1:
                    return @"偏低";
                    break;
                case 2:
                    return @"正常";
                    break;
                case 3:
                    return @"高";
                    break;
                case 4:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
        case IS_MODEL_FATPERCENT:
            switch (item.fatPercentageLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                case 3:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_MODEL_FAT:
            switch (item.fatWeightLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                case 3:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_MODEL_WATER:
            switch (item.waterLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_MODEL_PROTEIN:
            switch (item.proteinLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                default:
                    break;
            }
            
            
            break;
        case IS_MODEL_MUSCLE:
            switch (item.muscleLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;

                    
                default:
                    break;
            }
            
            
            break;
        case IS_MODEL_BONEMUSCLE:
            switch (item.boneMuscleLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;

                default:
                    break;
            }
            break;
            
            
        case IS_MODEL_VISCERALFAT:
            switch (item.visceralFatPercentageLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"超标";
                    break;
                case 3:
                    return @"高";
                    break;
                    
                default:
                    break;
            }
            break;
        case IS_MODEL_BONE:
            switch (item.boneLevel) {
                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                default:
                    break;
            }
            break;
        case IS_MODEL_BMR:
            switch (item.bmrLevel) {

                case 1:
                    return @"正常";
                    break;
                case 2:
                    return @"低";
                    break;
                case 3:
                    return @"高";
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
