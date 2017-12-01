//
//  ShareDataDetailView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShareDetailView.h"

#define warningColor   [UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1]
#define normalColor    [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1]
#define seriousColor   [UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1]

@implementation ShareDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.headImageView.layer.borderWidth = 1;
    self.recodeImageView.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    self.recodeImageView.layer.borderWidth = 1;

    
    
    self.status1lb.layer.masksToBounds = YES;
    self.status1lb.layer.cornerRadius = 2;
    self.status2lb.layer.masksToBounds = YES;
    self.status2lb.layer.cornerRadius = 2;
    self.status3lb.layer.masksToBounds = YES;
    self.status3lb.layer.cornerRadius = 2;
    self.status4lb.layer.masksToBounds = YES;
    self.status4lb.layer.cornerRadius = 2;
    self.status5lb.layer.masksToBounds = YES;
    self.status5lb.layer.cornerRadius = 2;
    self.status6lb.layer.masksToBounds = YES;
    self.status6lb.layer.cornerRadius = 2;
    self.status7lb.layer.masksToBounds = YES;
    self.status7lb.layer.cornerRadius = 2;
    self.status8lb.layer.masksToBounds = YES;
    self.status8lb.layer.cornerRadius = 2;
    self.status9lb.layer.masksToBounds = YES;
    self.status9lb.layer.cornerRadius = 2;

    
    
//    _recodeImageView.image = [UIImage imageWithData:[UserModel shareInstance].qrcodeImageData];
    
    [self.recodeImageView getImageWithUrl:[UserModel shareInstance].qrcodeImageUrl getImageFinish:^(UIImage *image, NSError *error) {
        if (error) {
            self.recodeImageView.image = getImage(@"shareQRCode") ;
            return ;
        }
        self.recodeImageView.image = image;
        
    }];

    
//    [self setInfo];

}
-(void)setInfoWithItem:(HealthDetailsItem *)item
{
    
    [self.headImageView getImageWithUrl:[SubUserItem shareInstance].headUrl getImageFinish:^(UIImage *image, NSError *error) {
        if (!error) {
            self.headImageView.image = image;
        }else{
            self.headImageView.image = getImage(@"head_default");
        }
    }];
    
    
    
    
    
    
    self.nicknamelb.text = [SubUserItem shareInstance].nickname;
    
    self.heightlb.text =[NSString stringWithFormat:@"身高:%d",item.height];
    self.agelb.text =[NSString stringWithFormat:@"年龄:%d",item.age];
    
    self.bodylb.text = [NSString stringWithFormat:@"体型:%@",[self getBodyStatusWithLevel:item.weightLevel]];
    
    self.bodyAgelb.text = [NSString stringWithFormat:@"%d",item.bodyAge];
    
    if (item.weightLevel==1||item.weightLevel==3||item.weightLevel==4) {
        self.bodylb.textColor = warningColor;
        
    }else if (item.weightLevel==2)
    {
        self.bodylb.textColor = normalColor;
    }
    else if (item.weightLevel==5||item.weightLevel==6)
    {
        self.bodylb.textColor = seriousColor;
    }
    self.bodyAgelb.text = [NSString stringWithFormat:@"身体年龄:%d",item.bodyAge];

    self.weightlb.text = [NSString stringWithFormat:@"体重:%.1fkg",item.weight];
    self.contentlb.text = [NSString stringWithFormat:@"在社群中排名第%d位，已超过社群%.0f%%的用户",item.ranking,item.percent];
    
    
    NSString * scoreStr =[NSString stringWithFormat:@"%.1f分",item.myScore];
    NSMutableAttributedString * scoreSStr = [[NSMutableAttributedString alloc]initWithString:scoreStr];
    [scoreSStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(scoreSStr.length-1, 1)];

    self.scorelb.attributedText = scoreSStr;
    self.scorelb.adjustsFontSizeToFitWidth = YES;
    
    NSString * tisStr = [NSString stringWithFormat:@"本次%d项检查中有%d项预警%d项警告%d项正常",item.normal+item.serious+item.warn,item.warn,item.serious,item.normal];
    
    int normalLenght;
    int warnLenght;
    int seriouslenght;
    if (item.normal==10) {
        normalLenght =2;
    }else{
        normalLenght =1;
    }
    if (item.warn==10) {
        warnLenght =2;
    }else{
        warnLenght =1;
    }
    if (item.serious==10) {
        seriouslenght =2;
    }else{
        seriouslenght =1;
    }
    
    
    int lenght =0;
    
    NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:tisStr];
    
    //总共
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 2)];
    
    lenght +=2;
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(lenght, 2)];
    lenght +=2;
    
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 5)];
    lenght +=5;
    
    //warn
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1] range:NSMakeRange(lenght, warnLenght)];
    lenght+=warnLenght;
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 3)];
    lenght+=3;
    //serious
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1] range:NSMakeRange(lenght, seriouslenght)];
    lenght+=seriouslenght;
    
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(lenght, 3)];
    lenght+=3;
    //normal
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1] range:NSMakeRange(lenght, normalLenght)];
    lenght+=normalLenght;
    [tisString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(tisStr.length-3, 3)];
    self.tclb.attributedText = tisString;
    self.bglb.text = [self getContentWithItem:item];
    [self setCurrInfo:item];
    
}
-(NSString *)getBodyStatusWithLevel:(int)level
{
    switch (level) {
        case 1:
            return  [NSString stringWithFormat:@"偏瘦"];
            break;
        case 2:
            return  [NSString stringWithFormat:@"标准"];
            break;
        case 3:
            return   [NSString stringWithFormat:@"偏胖"];
            break;
        case 4:
            return  [NSString stringWithFormat:@"偏胖"];
            break;
        case 5:
            return   [NSString stringWithFormat:@"超重"];
            break;
        case 6:
            return   [NSString stringWithFormat:@"超重"];
            break;
        default:
            return @"";
            break;
    }
    
}

-(void)setCurrInfo:(HealthDetailsItem *)item
{
        self.value1lb.text = [NSString stringWithFormat:@"%.1f",item.bmi];
        self.status1lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_BMI item:item];
        
        self.value2lb.text = [NSString stringWithFormat:@"%.1fkg",item.fatWeight];
        self.status2lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_FAT item:item];
        
        self.value3lb.text = [NSString stringWithFormat:@"%.1f%%",item.fatPercentage];
        self.status3lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_FATPERCENT item:item];
        
        
        self.value4lb.text = [NSString stringWithFormat:@"%.1fkg",item.proteinWeight];
        self.status4lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_PROTEIN item:item];
        
        self.value5lb.text = [NSString stringWithFormat:@"%.1fkg",item.boneWeight];
        self.status5lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_BONE item:item];
        
        self.value6lb.text = [NSString stringWithFormat:@"%.1fkg",item.waterWeight];
        self.status6lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_WATER item:item];
        
        
        
        self.value7lb.text = [NSString stringWithFormat:@"%.1fkg",item.muscleWeight];
        self.status7lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_MUSCLE item:item];
        
        self.value8lb.text = [NSString stringWithFormat:@"%.1f",item.bmr];
        self.status8lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_WATER item:item];
        
        self.value9lb.text = [NSString stringWithFormat:@"%.1f",item.visceralFatPercentage];
        self.status9lb.text = [self getHealthDetailTextWithStatus:IS_MODEL_VISCERALFAT item:item];
    
    self.status1lb.backgroundColor = [self getColorWithString:self.status1lb.text];
    self.status2lb.backgroundColor = [self getColorWithString:self.status2lb.text];
    self.status3lb.backgroundColor = [self getColorWithString:self.status3lb.text];
    self.status4lb.backgroundColor = [self getColorWithString:self.status4lb.text];
    self.status5lb.backgroundColor = [self getColorWithString:self.status5lb.text];
    self.status6lb.backgroundColor = [self getColorWithString:self.status6lb.text];
    self.status7lb.backgroundColor = [self getColorWithString:self.status7lb.text];
    self.status8lb.backgroundColor = [self getColorWithString:self.status8lb.text];
    self.status9lb.backgroundColor = [self getColorWithString:self.status9lb.text];

}




-(NSString *)getContentWithItem:(HealthDetailsItem *)item
{
    if (item.weight-item.lastWeight==0) {
        switch (item.weightLevel) {
            case 1:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于偏瘦身材，可以考虑补充营养，进行锻炼，毕竟过于消瘦也不好奥。",item.weight,item.fatPercentage];
                break;
            case 2:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于标准身材，您的体型很标准，继续保持，如果您对自己有更高要求，可以运动锻炼，进行增肌塑形。",item.weight,item.fatPercentage];
                
                break;
            case 3:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于偏胖人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];
                
                break;
            case 4:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于偏胖人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];
                
                break;
            case 5:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于超重人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];
                
                break;
            case 6:
                return [NSString stringWithFormat:@"您的体重%.1fkg，体脂率%.1f%%，属于超重人群，建议您每餐少油少盐，并进行适当运动以减轻身体负担。",item.weight,item.fatPercentage];
                
                break;
                
            default:
                break;
        }
    }else{
        switch (item.weightLevel) {
            case 1:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，提醒您补充营养也要把握好尺度，不要被肥胖趁虚而入奥。",fabsf(item.weight-item.lastWeight)];
                    
                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，建议您保证三餐必须的营养摄入，不要为了身材而不顾健康奥。",fabsf(item.weight-item.lastWeight)];
                    
                }
                break;
            case 2:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%1.fkg，建议您注意饮食，不要被肥胖趁虚而入奥。",fabsf(item.weight-item.lastWeight)];
                    
                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，建议您保证三餐必须的营养摄入，不要为了身材而不顾健康奥。",fabsf(item.weight-item.lastWeight)];
                    
                }
                break;
            case 3:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",fabsf(item.weight-item.lastWeight)];
                    
                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",fabsf(item.weight-item.lastWeight)];
                    
                }
                break;
            case 4:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",fabsf(item.weight-item.lastWeight)];
                    
                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",fabsf(item.weight-item.lastWeight)];
                    
                }
                break;
            case 5:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",fabsf(item.weight-item.lastWeight)];
                    
                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",fabsf(item.weight-item.lastWeight)];
                    
                }
                break;
            case 6:
                if (item.weight-item.lastWeight>0) {
                    return [NSString stringWithFormat:@"与首次相比，体重上升%.1fkg，建议您注意饮食，每餐少油少盐，并进行适当运动以减轻身体负担。",fabsf(item.weight-item.lastWeight)];
                    
                }else{
                    return [NSString stringWithFormat:@"与首次相比，体重下降%.1fkg，继续加油，坚持下去你就会收获更好的自己。",fabsf(item.weight-item.lastWeight)];
                    
                }
                break;
                
            default:
                return @"";
                break;
        }
    }
    return @"";
    
}
-(NSString *)getHealthDetailTextWithStatus:(isMyType)myType item:(HealthDetailsItem*)item
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
                    return @"偏高";
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
                    return @"偏高";
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
            
        default:
            break;
    }
    return nil;
}
-(UIColor *)getColorWithString:(NSString *)string
{
    
    if ([string isEqualToString:@"偏低"]||[string isEqualToString:@"偏高"]||[string isEqualToString:@"超标"]) {
        return warningColor;
    }
    else if ([string isEqualToString:@"正常"])
    {
        return normalColor;
    }else{
        return seriousColor;
    }
    
}

@end
