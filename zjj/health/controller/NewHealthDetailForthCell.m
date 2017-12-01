//
//  NewHealthDetailForthCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailForthCell.h"
#import "HealthModel.h"
@implementation NewHealthDetailForthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(HealthDetailsItem *)item
{
    float fatWeightV =0.0;
    float visceral = 0.0;
    int sex = [UserModel shareInstance].gender;
    if (sex ==1) {
        fatWeightV = 22.0f;
        visceral = 8;
    }else{
        visceral = 6;
        fatWeightV = 24.0f;
    }
    

    float target1 = item.standardWeight-item.weight;

    float target2 = fatWeightV-item.fatPercentage;

    float target3 = (fatWeightV*item.standardWeight-item.fatPercentage*item.weight)/100;

    float target4 = visceral -item.visceralFatPercentage;
    
    if (target2>0) {
        self.statusFatLabel.text = @"增脂";
    }else if (target2<0)
    {
        self.statusFatLabel.text = @"减脂";
    }else
    {
        self.statusFatLabel.text = @"";
    }

    
    
    
    self.target1label.text =[NSString stringWithFormat:@"%@%.1fkg",target1>0?@"+":@"",target1];
    self.target2label.text =[NSString stringWithFormat:@"%@%.1f%%",target2>0?@"+":@"",target2];
    self.target3label.text =[NSString stringWithFormat:@"%@%.1fkg",target3>0?@"+":@"",target3];
    self.target4label.text =[NSString stringWithFormat:@"%@%.1f",target4>0?@"+":@"",target4];
    
    self.my1Label.text = [NSString stringWithFormat:@"%.1fkg",item.weight];
    self.my2Label.text = [NSString stringWithFormat:@"%.1f%%",item.fatPercentage];
    self.my3Label.text = [NSString stringWithFormat:@"%.1fkg",item.fatWeight];
    self.my4Label.text = [NSString stringWithFormat:@"%.1f",item.visceralFatPercentage];

    self.my1Label.textColor = [[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_WEIGHT item:item];
    self.my2Label.textColor = [[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_FATPERCENT item:item];
    self.my3Label.textColor = [[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_FAT item:item];
    self.my4Label.textColor = [[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_VISCERALFAT item:item];

    
    self.value1Label.text =[NSString stringWithFormat:@"%.1fkg",item.standardWeight];
    self.value2Label.text =[NSString stringWithFormat:@"%.1f%%",fatWeightV];
    self.value3Label.text =[NSString stringWithFormat:@"%.1fkg",item.standardWeight *fatWeightV/100];
    self.value4Label.text =[NSString stringWithFormat:@"%.1f",visceral];

    
    
    
    
    
    
    
    
}

- (IBAction)diddaka:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShareImage)]) {
        
        [self.delegate didShareImage];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
