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
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;

    // Initialization code
}
-(void)setUpCellWithGoodsDetailItem:(GoodsDetailItem *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.image]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[item.productPrice floatValue]];
}
//-(void)setUpInfoWithIntegralDetailModel:(IntegralShopDetailModel *)model
//{
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picture]];
//    self.titleLabel.text = model.viceTitle;
//
//    NSString * price = model.productPrice;
//    NSString * integral = model.productIntegral;
//    
//    if (price.floatValue>0&&integral.intValue>0) {
//        self.priceLabel.text = [NSString stringWithFormat:@"%@积分+%.2f元",integral,[price floatValue]];
//        
//    }else{
//        if (price.floatValue>0) {
//            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[price floatValue]];
//        }else{
//            self.priceLabel.text = [NSString stringWithFormat:@"%@积分",integral];
//        }
//    }
//
//}
-(void)setUpCellWithDict:(NSDictionary *)dic
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]]];
    self.titleLabel.text = [dic safeObjectForKey:@"productName"];
    
    
    NSString * price = [dic safeObjectForKey:@"productPrice"];
    NSString * integral = [dic safeObjectForKey:@"productIntegral"];
    
    if (price.floatValue>0&&integral.intValue>0) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f+%@积分",[[dic safeObjectForKey:@"productPrice"]floatValue],integral];

    }else{
        if (price.floatValue>0) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[dic safeObjectForKey:@"productPrice"]floatValue]];
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"%@积分",integral];
        }
    }
    
}
-(void)setUpCellWithShopCarCellItem:(shopCarCellItem *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.image]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[item.productPrice floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"x%@",item.quantity];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
