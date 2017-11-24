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

    progressRing = [[RingProgressView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.progressView addSubview:progressRing];
    
    
    
}

-(void)setCellInfoWithDict:(NSDictionary *)dic
{
    self.titlelb.text = [dic safeObjectForKey:@"grantName"];
    self.timelb.text = [NSString stringWithFormat:@"有效期至:%@",[dic safeObjectForKey:@"receiveEndTime"]];
    
    double receiveNum =[[dic safeObjectForKey:@"receiveNum"]doubleValue];
    double grantNum = [[dic safeObjectForKey:@"grantNum"]doubleValue];
    
    
    self.countlb.text = [NSString stringWithFormat:@"%d",[[dic safeObjectForKey:@"grantNum"]intValue]-[[dic safeObjectForKey:@"receiveNum"]intValue]];
    
    self.lastCountlb.text = [NSString stringWithFormat:@"%.0f%%",(grantNum-receiveNum)/grantNum*100];
    
    
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
        self.faceValuelb.text = [NSString stringWithFormat:@"%.0f折",[[dic safeObjectForKey:@"discountAmount"]floatValue]*10];
    }else{
        self.faceValuelb.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"discountAmount"]];
    }
    
    self.headImageView.image = getImage(@"default");
    
    //useRange//使用范围 0全部商品 1脂将军饼干 2 体脂称
    int userRange = [[dic safeObjectForKey:@"useRange"]intValue];
    if (userRange ==1) {
        self.limit2lb.text =@"仅限脂将军饼干使用";
    }
    else if(userRange ==2)
    {
        self.limit2lb.text = @"仅限脂将军饼干使用";
    }else
    {
        self.limit2lb.text = @"(无限制)";
    }
    
    int startAmount = [[dic safeObjectForKey:@"startAmount"]intValue];
    if (!startAmount||startAmount ==0) {
        self.limitlb.text = @"(无限制)";
    }else{
        self.limitlb.text = [NSString stringWithFormat:@"满%d可用",startAmount];
    }

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
