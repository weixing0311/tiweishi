//
//  MyVouchersCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myVouchersCellDelegate;
@interface MyVouchersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *faceValuelb;
@property (weak, nonatomic) IBOutlet UILabel *limitPricelb;
@property (weak, nonatomic) IBOutlet UILabel *limitGoodslb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UIButton *didUseBtn;
- (IBAction)didClickUse:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UIImageView *didChooseImage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (nonatomic,assign)id<myVouchersCellDelegate>delegate;
@end
 
@protocol myVouchersCellDelegate <NSObject>
-(void)didUserVoucherWithCell:(MyVouchersCell*)cell;
@end;
