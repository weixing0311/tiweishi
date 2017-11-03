//
//  TZSDGUPCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TZSDGUPCellDelegate;
@interface TZSDGUPCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (nonatomic,assign)id<TZSDGUPCellDelegate>delegate;
- (IBAction)didBuy:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *cxImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cxDetailLabel;
- (IBAction)didShowCuXDetailView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cxView;



@end
@protocol TZSDGUPCellDelegate <NSObject>

-(void)didBuyWithCell:(TZSDGUPCell *)cell;
-(void)showCXDetailWithDGCell:(TZSDGUPCell * )cell;

@end
