//
//  SettingViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface SettingViewController : JFABaseTableViewController
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *vipImg;


@property (weak, nonatomic) IBOutlet UIButton *czBtn;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//金牌体脂师
@property (weak, nonatomic) IBOutlet UILabel *tzsLabel;
//排名
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;
@property (weak, nonatomic) IBOutlet UILabel *integrallb;

//资产
@property (weak, nonatomic) IBOutlet UILabel *assetsLabel;

//认证image
@property (weak, nonatomic) IBOutlet UILabel *cerLabel;

//金牌Image
@property (weak, nonatomic) IBOutlet UIImageView *LevelImageView;

- (IBAction)didEdit:(id)sender;

- (IBAction)seeNewMessage:(id)sender;

////邀请
- (IBAction)didInvitation:(id)sender;
//
////服务订购
- (IBAction)buy:(id)sender;
////我的订购
- (IBAction)mybuy:(id)sender;
////已购
- (IBAction)alsoBuy:(id)sender;
////服务配送
- (IBAction)send:(id)sender;
////我的配送
- (IBAction)mySend:(id)sender;
////地址管理
- (IBAction)address:(id)sender;
////充值
- (IBAction)topUp:(id)sender;
////交易记录
- (IBAction)TransactionRecords:(id)sender;
////钱包管理
- (IBAction)walletManagement:(id)sender;
////我的收益
- (IBAction)myIncome:(id)sender;
////团队订购
- (IBAction)teamOrder:(id)sender;
////团队管理
- (IBAction)teamManagement:(id)sender;
/**
 *我的名片
 */
- (IBAction)myBussinessCard:(id)sender;


//查看排名
- (IBAction)toViewRank:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UIView *forthView;
@property (weak, nonatomic) IBOutlet UIView *fifthView;


@end
