//
//  MyVouchers2Cell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/7/20.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MyVouchers2Cell.h"

@implementation MyVouchers2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.secondlb.adjustsFontSizeToFitWidth = YES;
    self.titlelb.adjustsFontSizeToFitWidth = YES;
    self.pricelb.adjustsFontSizeToFitWidth = YES;
    
    
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xfe9833).CGColor, (__bridge id)HEXCOLOR(0xfec230).CGColor];
    gradientLayer.locations = @[@0.5, @0.8,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH-20, 80);
    [self.bgView.layer addSublayer:gradientLayer];

    [self setlayout];
    
    
    
}

-(void)setModel:(MyVouchersCell2Model *)model
{
    _model = model;
    
    self.titlelb.text = model.grantName;
    NSString * startTime = [model.validStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符
    NSString * endTime  = [model.validEndTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符
    self.pricelb.text = model.startAmount;
    self.timelb.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    
    self.statuslb.text = @"旅游券";
    self.thirdlb.text = @"使用规则";
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentlb.text = [NSString stringWithFormat:@"%@",model.context];
    
    if ([model.showContent isEqualToString:@"open"]) {
        self.contentlb.hidden = NO;
        self.showContentbtn.selected = YES;
    }else{
        self.contentlb.hidden = YES;
        self.showContentbtn.selected = NO;

    }

    

    [self setupAutoHeightWithBottomView:self.contentlb bottomMargin:20];

}







- (IBAction)showContent:(id)sender {
    if (self.showContentbtn.selected ==YES) {
        self.showContentbtn.selected = NO;
    }
    else
    {
        self.showContentbtn.selected = YES;
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showContentInfoWithCell:)]) {
        [self.delegate showContentInfoWithCell:self];
    }
}
- (IBAction)didUserVouchers:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(userTheVoucherWithCell:)]) {
        [self.delegate userTheVoucherWithCell:self];
    }

}


-(void)setlayout
{
    self.bigbgView.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(110);
    
    self.bgView.sd_layout
    .topSpaceToView(self.bigbgView, 0)
    .leftSpaceToView(self.bigbgView, 0)
    .rightSpaceToView(self.bigbgView, 0)
    .heightIs(80);
    
    self.contentInfoView.sd_layout
    .topSpaceToView(self.bigbgView, 0)
    .leftSpaceToView(self.bigbgView, 0)
    .rightSpaceToView(self.bigbgView, 0)
    .heightIs(80);

    self.tapView.sd_layout
    .topSpaceToView(self.contentInfoView, 0)
    .leftSpaceToView(self.bigbgView, 0)
    .rightSpaceToView(self.bigbgView, 0)
    .heightIs(30);
    
    self.contentlb.sd_layout
    .topSpaceToView(self.bigbgView, 10)
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .autoHeightRatio(0);

    
    
    self.leftView_.sd_layout
    .topSpaceToView(self.contentInfoView, 0)
    .leftSpaceToView(self.contentInfoView, 0)
    .bottomSpaceToView(self.contentInfoView, 0)
    .widthEqualToHeight();

    

    _linelb.sd_layout
    .topSpaceToView(self.leftView_, 0)
    .rightSpaceToView(self.leftView_, 0)
    .bottomSpaceToView(self.leftView_, 0)
    .widthIs(1);
    
    self.pricelb.sd_layout
    .centerXEqualToView(self.leftView_)
    .centerYEqualToView(self.leftView_)
    .heightIs(18);
    [self.pricelb setSingleLineAutoResizeWithMaxWidth:55];
    self.pricelb.textAlignment = NSTextAlignmentCenter;
    
    self.unitlb.sd_layout
    .rightSpaceToView(self.pricelb, 2)
    .bottomEqualToView(self.pricelb)
    .heightIs(10)
    .widthIs(12);

    
    self.statuslb.sd_layout
    .topSpaceToView(self.contentInfoView, 10)
    .leftSpaceToView(self.leftView_, 10)
    .widthIs(50)
    .heightIs(15);
    
    self.titlelb.sd_layout
    .centerXEqualToView(_statuslb)
    .leftSpaceToView(self.statuslb, 5)
    .rightSpaceToView(self.contentInfoView, 10)
    .heightIs(15);

    self.useBtn.sd_layout
    .bottomSpaceToView(self.contentInfoView, 10)
    .rightSpaceToView(self.contentInfoView, 10)
    .widthIs(55)
    .heightIs(25);
    
    self.timelb.sd_layout
    .leftSpaceToView(self.leftView_, 10)
    .rightSpaceToView(self.useBtn, 10)
    .centerXEqualToView(self.useBtn)
    .heightIs(10);
    
    self.thirdlb.sd_layout
    .leftSpaceToView(self.tapView, 10)
    .centerXEqualToView(self.tapView)
    .heightIs(15);
    
    
    self.showContentbtn.sd_layout
    .centerXEqualToView(self.thirdlb)
    .rightSpaceToView(self.tapView, 10)
    .widthIs(30)
    .heightIs(30);
    
    [self setupAutoWidthWithRightView:self.contentlb rightMargin:20];
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
