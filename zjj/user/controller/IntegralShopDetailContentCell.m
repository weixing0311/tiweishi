//
//  IntegralShopDetailContentCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralShopDetailContentCell.h"

@implementation IntegralShopDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [UIImageView new];
        [self.contentView addSubview:self.headImageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];

        self.gradeLabel = [UILabel new];
        self.gradeLabel.font = [UIFont systemFontOfSize:14];
        self.gradeLabel.textAlignment = NSTextAlignmentLeft;
        self.gradeLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.gradeLabel];
        
        self.priceLabel = [UILabel new];
        self.priceLabel.font = [UIFont systemFontOfSize:15];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.textColor = [UIColor redColor];
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.priceLabel];
        
        self.countLabel = [UILabel new];
        self.countLabel.font = [UIFont systemFontOfSize:14];
        self.countLabel.textAlignment = NSTextAlignmentRight;
        self.countLabel.adjustsFontSizeToFitWidth = YES;
        self.countLabel.textColor  = [UIColor redColor];
        [self.contentView addSubview:self.countLabel];
        
        self.title1Label = [UILabel new];
        self.title1Label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.title1Label];
        
        self.content1Label = [UILabel new];
        self.content1Label.numberOfLines = 0;

        self.content1Label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.content1Label];
        
        self.title2Label = [UILabel new];
        self.title2Label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.title2Label];
        
        self.content2Label = [UILabel new];
        self.content2Label.numberOfLines = 0;

        self.content2Label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.content2Label];
        
        self.countView = [UILabel new];
        
        [self buildCountView];
        
        self.line1View = [UILabel new];
        self.line1View.backgroundColor = HEXCOLOR(0xeeeeee);
        [self.contentView addSubview:self.line1View];
        
        self.line2View = [UILabel new];
        self.line2View.backgroundColor = HEXCOLOR(0xeeeeee);
        [self.contentView addSubview:self.line2View];

        [self setup];
    }
    return self;
}




-(void)setup
{
    self.headImageView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .heightIs(JFA_SCREEN_WIDTH);
    
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 80)
    .topSpaceToView(self.headImageView, 10)
    .autoHeightRatio(0);

    self.countLabel.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.headImageView, 10)
    .leftSpaceToView(self.title1Label, 10)
    .heightIs(15);

    

    self.gradeLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.titleLabel, 10)
    .widthIs(80)
    .heightIs(15);
    

    self.priceLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.gradeLabel, 10)
    .widthIs(JFA_SCREEN_WIDTH-120)
    .heightIs(30);
    
    self.countView.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.titleLabel, 15)
    .widthIs(104)
    .heightIs(32);


    self.line1View.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.priceLabel, 10)
    .heightIs(10);
    
    self.title1Label.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.line1View, 10)
    .heightIs(20);
    
    self.content1Label.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.title1Label, 10)
    .autoHeightRatio(0);

    self.line2View.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.content1Label, 10)
    .heightIs(10);

    self.title2Label.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.line2View, 10)
    .heightIs(20);
    
    self.content2Label.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.title2Label, 10)
    .autoHeightRatio(0);

    [self setupAutoHeightWithBottomView:self.content2Label bottomMargin:10];

}
-(void)setModel:(IntegralShopDetailModel *)model
{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:getImage(@"default")];
    self.titleLabel.text  = model.viceTitle;
    self.gradeLabel.text = [NSString stringWithFormat:@"%@级以上",model.grade];
    self.countLabel.text = [NSString stringWithFormat:@"限购%@件",model.restrictionNum];
    self.priceLabel.text = [NSString stringWithFormat:@"%@积分+%@元",model.productIntegral,model.productPrice];
    self.title1Label.text = @"商品详情";
    self.content1Label.text = model.productInformation;
    self.title2Label.text = @"注意事项";
    self.content2Label.text = model.note;
}

-(void)buildCountView
{
    _countView =[UIView new];
    _countView .backgroundColor = HEXCOLOR(0xeeeeee);
    
    UIButton * redBtn = [[UIButton alloc]initWithFrame:CGRectMake(1, 1, 30, 30)];
    [redBtn setTitle:@"-" forState:UIControlStateNormal];
    redBtn.backgroundColor = [UIColor whiteColor];
    [redBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [redBtn addTarget:self action:@selector(didClickRed) forControlEvents:UIControlEventTouchUpInside];
    [_countView addSubview:redBtn];

    
    
    self.mindCountBtn = [[UIButton alloc]initWithFrame:CGRectMake(32, 1, 40, 30)];
    [self.mindCountBtn setTitle:@"1" forState:UIControlStateNormal];
    self.mindCountBtn.backgroundColor = [UIColor whiteColor];
    [self.mindCountBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [self.mindCountBtn addTarget:self action:@selector(didChangeCount) forControlEvents:UIControlEventTouchUpInside];

    [_countView addSubview:self.mindCountBtn];
    

    [self.contentView addSubview: _countView];
    
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(73, 1, 30, 30)];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(didClickAdd) forControlEvents:UIControlEventTouchUpInside];
    
    [_countView addSubview:addBtn];

}

-(void)didClickAdd
{
    int restrictionNum = [_model.restrictionNum intValue];
    
    int count =[self.mindCountBtn.titleLabel.text intValue];
    
    if (count ==restrictionNum) {
        return;
    }
    else
    {
        count++;
        [self.mindCountBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ChangeGoodsCount:)]) {
        [self.delegate ChangeGoodsCount:count];
    }
    
    
}
-(void)didChangeCount
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(enterGoodsCount)]) {
        [self.delegate enterGoodsCount];
    }

}

-(void)didClickRed
{
    int count =[self.mindCountBtn.titleLabel.text intValue];
    
    if (count ==1) {
        return;
    }
    else
    {
        count--;
        [self.mindCountBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    }

    if (self.delegate&&[self.delegate respondsToSelector:@selector(ChangeGoodsCount:)]) {
        [self.delegate ChangeGoodsCount:count];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
