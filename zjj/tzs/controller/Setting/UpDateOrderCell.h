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
//#import "IntegralShopDetailModel.h"
@interface UpDateOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *price2label;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *zengimageView;

-(void)setUpCellWithGoodsDetailItem:(GoodsDetailItem *)item;
-(void)setUpCellWithShopCarCellItem:(shopCarCellItem *)item;
//-(void)setUpInfoWithIntegralDetailModel:(IntegralShopDetailModel *)model;
-(void)setUpCellWithDict:(NSDictionary *)dic;
@end
