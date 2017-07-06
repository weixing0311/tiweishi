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
    [self.imageView setImageWithURL:[NSURL URLWithString:item.imageUrl]];
    self.titleLabel.text = item.productName;
    self.priceLabel.text  =item.productPrice;
    
}
- (IBAction)didBuy:(id)sender {
}
@end
