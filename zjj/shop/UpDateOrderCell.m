//
//  UpDateOrderCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UpDateOrderCell.h"

@implementation UpDateOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setUpCellWithGoodsDetailItem:(GoodsDetailItem *)item
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:item.image]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",item.productPrice];
}
-(void)setUpCellWithShopCarCellItem:(shopCarCellItem *)item
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:item.image]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",item.productPrice];
    self.countLabel.text = [NSString stringWithFormat:@"x%@",item.quantity];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
