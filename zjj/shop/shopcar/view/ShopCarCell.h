//
//  ShopCarCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopCarCellItem.h"
@class ShopCarCell;
@protocol shopCarCellDelegate<NSObject>
-(void)getCountWithCell:(ShopCarCell *)cell type:(BOOL)type;
-(void)getCellGoodsCountWithCell:(ShopCarCell *)cell count:(int)count;
-(void)deleteCell:(ShopCarCell*)cell;
-(void)showCuXiaoDetailViewWithCell:(ShopCarCell *)cell;
@end
@interface ShopCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreYhLabel;


@property (weak, nonatomic) IBOutlet UILabel *huodongLabel;
@property (weak, nonatomic) IBOutlet UIImageView *huodongImageView;
- (IBAction)didDelete:(id)sender;

@property (nonatomic,assign)id<shopCarCellDelegate>delegate;

- (IBAction)addCount:(id)sender;
- (IBAction)redCount:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)didChooseCell:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *hdTitleLabel;

-(void)setUpWithItem:(shopCarCellItem *)item;
@end
