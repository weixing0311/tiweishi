//
//  UpDateOrderCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailItem.h"
#import "shopCarCellItem.h"
@interface UpDateOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


-(void)setUpCellWithGoodsDetailItem:(GoodsDetailItem *)item;
-(void)setUpCellWithShopCarCellItem:(shopCarCellItem *)item;
-(void)setUpCellWithDict:(NSDictionary *)dic;
@end
