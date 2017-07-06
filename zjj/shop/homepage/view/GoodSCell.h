//
//  GoodSCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsItem.h"
@interface GoodSCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
- (IBAction)didBuy:(id)sender;
-(void)updataWithItem:(GoodsItem*)item;
@end
