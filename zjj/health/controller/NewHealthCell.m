//
//  NewHealthCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/5.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthCell.h"

@implementation NewHealthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.minView.layer.borderWidth= 2;
    self.minView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;

    // Initialization code
    
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:kShowGuidePage1]) {
        self.guide1View.hidden = NO;
    }

    [self.guide1View addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didshowNextGuild:)]];
    [self.Guide2View addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didshowNextGuild:)]];

}
-(void)refreshPageInfoWithItem:(HealthItem*)item
{
    
    if (item==nil) {
        self.weightlb.text = @"0.0kg";
        self.lessWeightLb.text = @"-";
        self.trendArrowImageView.hidden = YES;
        self.fatStatuslb.text = @"";
        self.resignTimelb.text = @"";
        self.redFatlb.text = @"";
        
    }
    [UserModel shareInstance].userDays = item.userDays;
    self.resignTimelb.text = [NSString stringWithFormat:@"已使用脂将军%d天",item.userDays];
    self.redFatlb.text = [NSString stringWithFormat:@"已减%.1fkg",item.subtractWeight*100/100];
    
    [self.userHeaderView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
    
    self.weightlb.text = [NSString stringWithFormat:@"%.1f",item.weight];
    
    if (item.weight) {
        float weightChange = item.weight - item.lastWeight;
        DLog(@"%f--%f",item.weight,item.lastWeight);
        self.lessWeightLb.text = [NSString stringWithFormat:@"%.1fkg",fabsf(weightChange)];
        self.trendArrowImageView.image =[UIImage imageNamed:weightChange>0?@"trand_up_icon":@"trand_down_icon"];
        self.trendArrowImageView.hidden = NO;
    }
    else {
        self.trendArrowImageView.hidden = YES;
        self.lessWeightLb.text = @"-";
    }
    switch (item.weightLevel) {
        case 1:
            self.fatStatuslb.text = [NSString stringWithFormat:@"偏瘦"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 2:
            self.fatStatuslb.text = [NSString stringWithFormat:@"正常"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0x41bf7c);
            break;
        case 3:
            self.fatStatuslb.text = [NSString stringWithFormat:@"轻度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 4:
            self.fatStatuslb.text = [NSString stringWithFormat:@"中度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 5:
            self.fatStatuslb.text = [NSString stringWithFormat:@"重度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xe84849);
            break;
        case 6:
            self.fatStatuslb.text = [NSString stringWithFormat:@"极度肥胖"];
            //            self.fatStatuslb.textColor = HEXCOLOR(0xe84849);
            break;
            
        default:
            break;
    }
    
}
- (IBAction)didClickNext:(UIButton *)sender {
    
    if (sender.tag==1) {
        self.Guide2View.hidden =NO;
        self.guide1View.hidden = YES;
        
    }else if (sender.tag==2){
        self.guide3View.hidden = NO;
        self.Guide2View.hidden =YES;
    }
}

-(void)didshowNextGuild:(UIGestureRecognizer*)gest
{
    if (gest.view ==self.guide1View) {
        self.Guide2View.hidden =NO;
        self.guide1View.hidden = YES;
        
    }else if (gest.view ==self.Guide2View){
        self.guide3View.hidden = NO;
        self.Guide2View.hidden =YES;
    }
    
}

- (IBAction)didStop:(id)sender {
    self.guide1View.hidden = YES;
    self.Guide2View.hidden = YES;
    self.guide3View.hidden = YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kShowGuidePage1];

    
}
- (IBAction)didFinish:(id)sender {
    self.guide1View.hidden = YES;
    self.Guide2View.hidden = YES;
    self.guide3View.hidden = YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kShowGuidePage1];
    
}

- (IBAction)didClickHeader:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowUserList)]) {
        [self.delegate didShowUserList];
    }
    
}

- (IBAction)didClickRight:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didShowSHuoming)]) {
        [self.delegate didShowSHuoming];
    }

}

- (IBAction)didWeight:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didWeighting)]) {
        [self.delegate didWeighting];
    }

}

- (IBAction)didEnterDetail:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didEnterDetailVC)]) {
        [self.delegate didEnterDetailVC];
    }

}
- (IBAction)didEnterHistory:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didEnterRightVC)]) {
        [self.delegate didEnterRightVC];
    }

}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
