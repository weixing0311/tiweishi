//
//  ShopCarCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShopCarCell.h"
@implementation ShopCarCell
{
    shopCarCellItem * shopItem;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    shopItem =[[shopCarCellItem alloc]init];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didChooseCell:(UIButton*)sender {
    
    if (self.chooseBtn.selected==YES) {
        self.chooseBtn.selected = NO;
    }else{
        self.chooseBtn.selected = YES;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getCountWithCell:type:)]) {
        [self.delegate getCountWithCell:self type:self.chooseBtn.selected==YES];
    }
}

-(void)setUpWithItem:(shopCarCellItem *)item
{
    shopItem = item;
    self.titleLabel.text = item.productName;
    [self.headerImgView setImageWithURL:[NSURL URLWithString:item.image]];
    self.priceLabel.text = item.productPrice;
    self.weightLabel.text = [NSString stringWithFormat:@"%@kg",item.productWeight];
    self.countLabel.text = item.quantity;
//    self.countLabel.text =item.
}

- (IBAction)addCount:(id)sender {
    int Count = [self.countLabel.text intValue];
    Count ++    ;
    self.countLabel.text = [NSString stringWithFormat:@"%d",Count];
    
    [self countChangeWithCountAdd:YES];
    

}

- (IBAction)redCount:(id)sender {
    int Count = [self.countLabel.text intValue];
    if (Count==0) {
        return;
    }
    Count --    ;
    self.countLabel.text = [NSString stringWithFormat:@"%d",Count];
    
    [self countChangeWithCountAdd:NO];

}

-(void)countChangeWithCountAdd:(BOOL)isAdd
{
    int count =[shopItem.quantity intValue];
    if (isAdd ==YES) {
        count++;
    }else{
        count--;
    }
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:shopItem.productNo forKey:@"productNo"];
    [dic setObject:@(count) forKey:@"quantity"];
    [dic setObject:[UserModel shareInstance].userId forKey:@"userId"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [param setObject:str forKey:@"jsonData"];
    DLog(@"%@---%@",str,param);
    [[BaseSservice sharedManager] post1:@"app/order/shoppingCart/updateShoppingCart.do" paramters:param success:^(NSDictionary *dic) {
        
        self.countLabel.text = [NSString stringWithFormat:@"%d",count];
        
        if (isAdd ==YES) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(getCellGoodsCountWithCell:count:)]) {
                [self.delegate getCellGoodsCountWithCell:self count:count];
            }

        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(getCellGoodsCountWithCell:count:)]) {
                [self.delegate getCellGoodsCountWithCell:self count:count];
            }

        }
        
    } failure:^(NSError *error) {
        self.countLabel.text = shopItem.quantity;
    }];
}

- (IBAction)didDelete:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:self];
    }
}
@end
