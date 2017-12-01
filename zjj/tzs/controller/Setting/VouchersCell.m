//
//  VouchersCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersCell.h"
#import "RingProgressView.h"
@implementation VouchersCell
{
    RingProgressView * progressRing ;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.borderWidth= 2;
    self.headImageView.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    self.titlelb.adjustsFontSizeToFitWidth = YES;
    if (IS_IPHONE5) {
        self.faceValuelb.font = [UIFont systemFontOfSize:18];
    }
    self.limit2lb.adjustsFontSizeToFitWidth = YES;

    progressRing = [[RingProgressView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.progressView addSubview:progressRing];
    
    
    
}

-(void)setCellInfoWithDict:(NSDictionary *)dic
{
    self.titlelb.text = [dic safeObjectForKey:@"grantName"];
    
    NSString * startTime = [[dic safeObjectForKey:@"validStartTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符
    NSString * endTime = [[dic safeObjectForKey:@"receiveEndTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符

    self.timelb.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    
    double receiveNum =[[dic safeObjectForKey:@"receiveNum"]doubleValue];
    double grantNum = [[dic safeObjectForKey:@"grantNum"]doubleValue];
    
    
    self.countlb.text = [NSString stringWithFormat:@"%d",[[dic safeObjectForKey:@"grantNum"]intValue]-[[dic safeObjectForKey:@"receiveNum"]intValue]];
    
    self.lastCountlb.text = [NSString stringWithFormat:@"%.0f%%",receiveNum/grantNum*100];
    
    
    progressRing.progressValue  = [[dic safeObjectForKey:@"receiveNum"]floatValue]/[[dic safeObjectForKey:@"grantNum"]floatValue];
    [progressRing  reSetMyProgressView];
    
    NSString * isReceive = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"isReceive"]];
    if ([isReceive isEqualToString:@"0"]) {
        self.getBtn.selected = NO;
        self.getBtn.backgroundColor = [UIColor redColor];
    }else{
        self.getBtn.selected = YES;
        self.getBtn.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    
    
    int type = [[dic safeObjectForKey:@"type"]intValue];
    if (type ==2) {
        self.faceValuelb.text = [NSString stringWithFormat:@"%@折",[self formatFloat:[[dic safeObjectForKey:@"discountAmount"]floatValue]*10]];
    }
    else if(type==4)
    {
        self.faceValuelb.text = @"免运费";
    }

    else{
        self.faceValuelb.text = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"discountAmount"]];
    }
    
//    self.headImageView.image = getImage(@"default");
    
    //useRange//使用范围 0全部商品 1脂将军饼干 2 体脂称
//    int userRange = [[dic safeObjectForKey:@"useRange"]intValue];
//    if (userRange ==1) {
//        self.limit2lb.text =@"仅限脂将军饼干使用";
//    }
//    else if(userRange ==2)
//    {
//        self.limit2lb.text = @"仅限脂将军饼干使用";
//    }else
//    {
//        self.limit2lb.text = @"(无限制)";
//    }
    NSArray * products = [dic safeObjectForKey:@"products"];
    if (products.count<1) {
        self.headImageView .image = getImage(@"vouchersAll_");
    }else{
        self.headImageView.image = getImage(@"vouchersGoods_");
    }
    self.limit2lb.text = [self getlimitWithArr:products];
    
    
    int startAmount = [[dic safeObjectForKey:@"startAmount"]intValue];
    if (!startAmount||startAmount ==0) {
        self.limitlb.text = @"无限制";
    }else{
        self.limitlb.text = [NSString stringWithFormat:@"满%d元可用",startAmount];
    }

}


-(void)refreshProgressWithDict:(NSDictionary *)dic
{
    double receiveNum =[[dic safeObjectForKey:@"receiveNum"]doubleValue];
    double grantNum = [[dic safeObjectForKey:@"grantNum"]doubleValue];

    progressRing.progressValue  = [[dic safeObjectForKey:@"receiveNum"]floatValue]/[[dic safeObjectForKey:@"grantNum"]floatValue];
    self.lastCountlb.text = [NSString stringWithFormat:@"%.0f%%",receiveNum/grantNum*100];
    [progressRing  reSetMyProgressView];

}

-(void)changeGetBtnStatus:(int)status
{
    switch (status) {
        case 1:
            [self.getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
            [self.getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.getBtn setBackgroundColor:[UIColor redColor]];
            self.getBtn.userInteractionEnabled = YES;
            break;
        case 2:
            [self.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
            [self.getBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            [self.getBtn setBackgroundColor:HEXCOLOR(0xeeeeee)];
            self.getBtn.userInteractionEnabled = NO;
            break;
        case 3:
            [self.getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
            [self.getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.getBtn setBackgroundColor:[UIColor redColor]];
            self.getBtn.userInteractionEnabled = NO;
            break;

        default:
            break;
    }
}


-(NSString*)getlimitWithArr:(NSArray *)arr
{
    NSString * limitStr = @"";
    if (!arr&&arr.count<1) {
        limitStr = @"(无限制)";
        return limitStr;
    }
    if (arr.count>0) {
    for (int i =0; i<arr.count; i++) {
        NSDictionary * dic = [arr objectAtIndex:i];
        limitStr = [NSString stringWithFormat:@"%@%@%@",limitStr,i==0?@"":@",",[dic safeObjectForKey:@"productName"]];
    }
        limitStr = [NSString stringWithFormat:@"(仅限%@使用)",limitStr];
    }
    return limitStr;
}

- (NSString *)formatFloat:(float)f
{
    int fi=(int)f;
    if(f==fi)
        return [NSString stringWithFormat:@"%d",fi];
    else
        return [NSString stringWithFormat:@"%.1f",f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickGetVouchers:(id)sender {
    if (self.getBtn.selected ==YES) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didClickGetVouchersWithCell:)]) {
        [self.delegate didClickGetVouchersWithCell:self];
    }
}
@end
