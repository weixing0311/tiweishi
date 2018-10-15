//
//  MyVouchers2Cell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/7/20.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyVouchersCell2Model.h"
@protocol myVouchers2Delegate;
@interface MyVouchers2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *secondlb;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *thirdlb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UIButton *showContentbtn;

//////0--------
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIView *leftView_;
@property (weak, nonatomic) IBOutlet UILabel *unitlb;
@property (weak, nonatomic) IBOutlet UILabel *linelb;
@property (nonatomic, strong) MyVouchersCell2Model *model;

//////0----------

@property (weak, nonatomic) IBOutlet UIView *contentInfoView;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bigbgView;
@property (nonatomic,assign)id<myVouchers2Delegate>delegate;
@end
@protocol myVouchers2Delegate <NSObject>

-(void)showContentInfoWithCell:(MyVouchers2Cell *)cell;
-(void)userTheVoucherWithCell:(MyVouchers2Cell *)cell;

@end
