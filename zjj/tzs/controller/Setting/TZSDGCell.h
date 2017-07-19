//
//  TZSDGCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TZSDGCellDelegate;
@interface TZSDGCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cxImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cxDetailLabel;
- (IBAction)didShowCuXDetailView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cxView;


@property (nonatomic,assign)id<TZSDGCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *countView;

- (IBAction)didAdd:(id)sender;
- (IBAction)didRed:(id)sender;
-(void)setHdArray:(NSArray *)arr;
@end
@protocol TZSDGCellDelegate <NSObject>

-(void)addCountWithCell:(TZSDGCell *)cell;
-(void)redCountWithCell:(TZSDGCell *)cell;
-(void)showCXDetailWithCell:(TZSDGCell * )cell;

@end
