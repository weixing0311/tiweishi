//
//  VouchersTzsCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersTzsCell.h"

@implementation VouchersTzsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.chooseBtn =[UIButton new];
        self.chooseBtn.frame = CGRectMake(20, 10, 20, 20);
        [self.chooseBtn addTarget:self action:@selector(didChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.chooseBtn];
        self.titleLabel = [UILabel new];
        self.titleLabel.frame = CGRectMake(70, 10, JFA_SCREEN_WIDTH-80, 20);
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = HEXCOLOR(0x666666);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLabel];
        
    }
    return self;
}


-(void)didChoose:(UIButton *)sender
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
