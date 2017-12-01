//
//  VouchersCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VouchersCellDelegate;
@interface VouchersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *faceValuelb;//面值
@property (weak, nonatomic) IBOutlet UILabel *limitlb;//限制--金额
@property (weak, nonatomic) IBOutlet UILabel *limit2lb;//限制--商品
@property (weak, nonatomic) IBOutlet UILabel *timelb;//时间
@property (weak, nonatomic) IBOutlet UILabel *countlb;//数量
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (nonatomic,assign)id<VouchersCellDelegate>delegate;
- (IBAction)didClickGetVouchers:(id)sender;
-(void)setCellInfoWithDict:(NSDictionary *)dict;
-(void)refreshProgressWithDict:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *lastCountlb;


@end
@protocol VouchersCellDelegate <NSObject>
-(void)didClickGetVouchersWithCell:(VouchersCell*)cell;
@end
