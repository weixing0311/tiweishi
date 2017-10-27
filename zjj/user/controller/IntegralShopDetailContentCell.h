//
//  IntegralShopDetailContentCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralShopDetailModel.h"
@protocol IntegralShopDetailCellDelegate;
@interface IntegralShopDetailContentCell : UITableViewCell
@property (nonatomic,strong)IntegralShopDetailModel * model;

@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIImageView * headImageView;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)UILabel * gradeLabel;
@property (nonatomic,strong)UILabel * countLabel;
@property (nonatomic,strong)UIView  * countView;
@property (nonatomic,strong)UIView  * line1View;
@property (nonatomic,strong)UILabel * title1Label;
@property (nonatomic,strong)UILabel * content1Label;
@property (nonatomic,strong)UIView  * line2View;
@property (nonatomic,strong)UILabel * title2Label;
@property (nonatomic,strong)UILabel * content2Label;
@property (nonatomic,strong)UIButton * mindCountBtn;
@property (nonatomic,assign)id<IntegralShopDetailCellDelegate>delegate;
@end

@protocol IntegralShopDetailCellDelegate <NSObject>
-(void)ChangeGoodsCount:(int)count;
-(void)enterGoodsCount;

@end



