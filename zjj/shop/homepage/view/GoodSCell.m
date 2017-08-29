//
//  GoodSCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GoodSCell.h"

@implementation GoodSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updataWithItem:(GoodsItem*)item
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text  =[NSString stringWithFormat:@"%.2f",[item.productPrice floatValue]];
    
}
- (IBAction)didBuy:(id)sender {
}
@end
