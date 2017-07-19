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
    self.hdTitleLabel.layer.masksToBounds = YES;
    self.hdTitleLabel.layer.cornerRadius  = 5;
    self.hdTitleLabel.layer.borderWidth = 1;
    self.hdTitleLabel.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;
    self.headerImgView.layer.borderWidth = 1;
    self.headerImgView.layer.borderColor=HEXCOLOR(0xeeeeee).CGColor;


}
- (IBAction)showCxDetail:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showCuXiaoDetailViewWithCell:)]) {
        [self.delegate showCuXiaoDetailViewWithCell:self];
    }
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
    self.priceLabel.text = [NSString stringWithFormat:@"%@￥",item.productPrice];
    self.weightLabel.text = [NSString stringWithFormat:@"重量：%@kg",item.productWeight];
    self.countLabel.text = item.quantity;
    int restrictionNum = [item.restrictionNum intValue];
    if (restrictionNum>0||(item.promotList.count&&item.promotList.count>0)) {
        self.hdTitleLabel.hidden = NO;
        self.huodongLabel.hidden = NO;
        if (restrictionNum>0) {
            self.hdTitleLabel.text = @"限购";
            self.huodongLabel.text = [NSString stringWithFormat:@"该商品单笔限购%d件",restrictionNum];
        }else{
            NSString * typeStr = [[item.promotList objectAtIndex:0]objectForKey:@"promotionType"];
            NSString * message = [[item.promotList objectAtIndex:0]objectForKey:@"promotionDetail"];
            if ([typeStr isEqualToString:@"1"]) {
                self.hdTitleLabel.text = @"满减";
            }else{
                self.hdTitleLabel.text = @"满赠";
            }
            self.huodongLabel.text =message;
        }
        
    }else{
        self.hdTitleLabel.hidden = YES;
        self.huodongLabel.hidden = YES;
   
    }
//    self.countLabel.text =item.
}

- (IBAction)addCount:(id)sender {
    int Count = [self.countLabel.text intValue];
    if ([shopItem.restrictionNum intValue]&&[shopItem.restrictionNum intValue]>0) {
        if (Count ==[shopItem.restrictionNum intValue]) {
            return;
        }
    }

    Count ++ ;
    self.countLabel.text = [NSString stringWithFormat:@"%d",Count];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getCellGoodsCountWithCell:count:)]) {
        [self.delegate getCellGoodsCountWithCell:self count:Count];
    }

    
    
//    [self countChangeWithCountAdd:YES];
    

}

- (IBAction)redCount:(id)sender {
    int Count = [self.countLabel.text intValue];
    if (Count==1) {
        return;
    }
    Count --    ;
    self.countLabel.text = [NSString stringWithFormat:@"%d",Count];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getCellGoodsCountWithCell:count:)]) {
        [self.delegate getCellGoodsCountWithCell:self count:Count];
    }

//    [self countChangeWithCountAdd:NO];

}

//-(void)countChangeWithCountAdd:(BOOL)isAdd
//{
//    int count =[shopItem.quantity intValue];
//    if (isAdd ==YES) {
//        count++;
//    }else{
//        count--;
//    }
//    
//    NSMutableDictionary *param =[NSMutableDictionary dictionary];
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setObject:shopItem.productNo forKey:@"productNo"];
//    [dic setObject:@(count) forKey:@"quantity"];
//    [dic setObject:[UserModel shareInstance].userId forKey:@"userId"];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    [param setObject:str forKey:@"jsonData"];
//    DLog(@"%@---%@",str,param);
//    [[BaseSservice sharedManager] post1:@"app/order/shoppingCart/updateShoppingCart.do" paramters:param success:^(NSDictionary *dic) {
//        
//        self.countLabel.text = [NSString stringWithFormat:@"%d",count];
//        
//        if (isAdd ==YES) {
//            if (self.delegate&&[self.delegate respondsToSelector:@selector(getCellGoodsCountWithCell:count:)]) {
//                [self.delegate getCellGoodsCountWithCell:self count:count];
//            }
//
//        }else{
//            if (self.delegate&&[self.delegate respondsToSelector:@selector(getCellGoodsCountWithCell:count:)]) {
//                [self.delegate getCellGoodsCountWithCell:self count:count];
//            }
//
//        }
//        
//    } failure:^(NSError *error) {
//        self.countLabel.text = shopItem.quantity;
//    }];
//}

- (IBAction)didDelete:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:self];
    }
}
@end
