//
//  EvaluationDetailExtendCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/14.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailSliderCell.h"

@implementation HealthDetailSliderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithBtnTag:(NSInteger)btag celltag:(NSInteger )cTag;
{
    
    if (btag ==3&&cTag ==1) {
        self.markBgImageView.image = [UIImage imageNamed:@"markBg2"];
    }else{
        self.markBgImageView.image = [UIImage imageNamed:@"markBg"];

    }
    CGRect rect = self.markIcon.frame;
    float y =rect.origin.y;
    switch (cTag) {
        case 0:
            switch (btag) {
                case 1:
                    self.markLowLabel.text = [NSString stringWithFormat:@"18.5"];
                    self.markHighLabel.text =[NSString stringWithFormat:@"24.0"];
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].bmi ];
                    break;
                case 2:
                    self.markHighLabel.text =[NSString stringWithFormat:@"%.1f%%",[HealthDetailsItem instance].fatWeightMax];
                    self.markLowLabel.text =[NSString stringWithFormat:@"%.1f%%",[HealthDetailsItem instance].fatWeightMin];
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].mFat ];
    

                    
                    break;
                case 3:
                    self.markHighLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatPercentageMin];
                    self.markLowLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatPercentageMin];
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].fatPercentage ];

                    break;
                case 4:
                    self.markHighLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].waterWeightMin];
                    self.markLowLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].waterWeightMax];
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].mWater ];

                    break;
                    
                default:
                    break;
            }
            break;
         case 1:
            switch (btag) {
                case 1:
                    self.markLowLabel.text = [NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].proteinWeightMin];
                    self.markHighLabel.text = [NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].proteinWeightMax];
                    
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].proteinWeight ];

                    break;
                case 2:
                    self.markHighLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].boneWeightMax];
                    self.markLowLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].boneWeightMin];
                    
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].muscleWeight ];

                    break;
                case 3:
                    self.markHighLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatPercentageMin];
                    self.markLowLabel.text =[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatPercentageMin];
                    
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].mBone ];

                    
                    break;
                case 4:
                    self.markHighLabel.text = [NSString stringWithFormat:@"10.0"];
                    self.markLowLabel.text  = [NSString stringWithFormat:@"14.0"];
                    
                    
                    y = [self getLocationWithMax:[self.markHighLabel.text floatValue] info:[HealthDetailsItem instance].visceralFatPercentage ];

                    break;
                    
                default:
                    break;
            }
           
            break;
        default:
            break;
    }
    rect =CGRectMake(rect.origin.x,y , rect.size.width, rect.size.height);
    self.markIcon.frame = rect;

}

-(float)getLocationWithMax:(float)maxdd info:(float)locinfo
{
    float width = self.markBgImageView.frame.size.width;

    float onedd = width*3/4*maxdd;
    float locdd = onedd * locinfo+20;
    return locdd;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
