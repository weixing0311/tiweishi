//
//  SettingViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "SettingViewController.h"
#import "TZSEditViewController.h"
#import "AddressListViewController.h"
#import "BaseWebViewController.h"
#import "EidtViewController.h"
#import "TZSDingGouViewController.h"
#import "TZSMyDingGouViewController.h"
#import "TZSTeamDGViewController.h"
#import "QrCodeView.h"
#import "TZSDeliveryViewController.h"
#import "TZSDistributionViewController.h"
#import "AddTradingPsController.h"
@interface SettingViewController ()
@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self getbalance];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShardow];

    
    [self.headImageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.nameLabel.text = [UserModel shareInstance].nickName;
    self.LevelImageView.image = [[UserModel shareInstance]getLevelImage];
    self.tzsLabel.text = [UserModel shareInstance].gradeName;
    self.cerLabel.text = [UserModel shareInstance].isAttest;
    [self showHUD:hotwheels message:@"asldfkjasl" detai:@"asldaslkdf" Hdden:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)setShardow
{
    [self.firstView  setViewShadow];
    [self.secondView setViewShadow];
    [self.thirdView  setViewShadow];
    [self.forthView  setViewShadow];
}
-(void)getbalance
{
    [[BaseSservice sharedManager]post1:@"app/user/getUserInfo.do" paramters:nil success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);
        [[UserModel shareInstance]setTzsInfoWithDict:[dic safeObjectForKey:@"data"]];
        self.assetsLabel.text = [NSString stringWithFormat:@"总资产：￥%.2f",[UserModel shareInstance].balance];
        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
}
-(void)getWaitPayCount
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [[BaseSservice sharedManager]post1:@"app/orderList/statusCount.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);

        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark-- 邀请
- (IBAction)didInvitation:(id)sender {
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QrCodeView"owner:self options:nil];
    
    QrCodeView *rcodeView = [nib objectAtIndex:0];

    rcodeView.frame = self.view.frame;
    [self.view.window addSubview: rcodeView];
}
-(void)removeImage:(UIGestureRecognizer*)tap
{
    UIImageView *img =(UIImageView *)[self.view viewWithTag:9527];
    [img removeFromSuperview];
}


#pragma mark--订购
- (IBAction)buy:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSDingGouViewController *dg =[[TZSDingGouViewController alloc]init];
    
    dg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dg animated:YES];
}
#pragma mark--我的订购

- (IBAction)mybuy:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSMyDingGouViewController *md =[[TZSMyDingGouViewController alloc]init];
    md.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:md animated:YES];
}
#pragma mark--已订购
- (IBAction)alsoBuy:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark--配送服务
- (IBAction)send:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSDeliveryViewController *ed =[[TZSDeliveryViewController alloc]init];
    [self.navigationController pushViewController:ed animated:YES];
}
#pragma mark--我的配送
- (IBAction)mySend:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSDistributionViewController * ds =[[TZSDistributionViewController alloc]init];
    [self.navigationController pushViewController:ds animated:YES];
    
}
#pragma mark--地址管理
- (IBAction)address:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    AddressListViewController *ad =[[AddressListViewController alloc]init];
    [self.navigationController pushViewController:ad animated:YES];
}
#pragma mark--充值
- (IBAction)topUp:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    web.title =@"充值";
    web.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:web animated:YES];

}
#pragma mark--交易记录
- (IBAction)TransactionRecords:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
     web.title =@"交易记录";
    web.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:web animated:YES];

}
#pragma mark--钱包管理
- (IBAction)walletManagement:(id)sender {
    
    NSString * tradePasswordStr = [UserModel shareInstance].tradePassword;
    
    if (!tradePasswordStr||tradePasswordStr.length<1) {
        UIAlertController * al =[UIAlertController alertControllerWithTitle:nil message:@"您还没有交易密码，是否确认添加？" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        
        [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            AddTradingPsController * at =[[AddTradingPsController alloc]init];
            at.hidesBottomBarWhenPushed =YES;
            self.navigationController.navigationBarHidden =NO;
            [self.navigationController pushViewController:at animated:YES];
        }]];
        
        
        
        [self presentViewController:al animated:YES completion:nil];
    }
    
    
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
     web.title =@"钱包管理";
    web.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:web animated:YES];

}



#pragma mark--我的收益
- (IBAction)myIncome:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
     web.title =@"我的收益";
    web.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:web animated:YES];

    //WEB
}
#pragma mark--团队订购
- (IBAction)teamOrder:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    TZSTeamDGViewController * ts =[[TZSTeamDGViewController alloc]init];
    [self.navigationController pushViewController:ts animated:YES];
}
#pragma mark--团队管理
- (IBAction)teamManagement:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
     web.title =@"团队管理";
    web.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:web animated:YES];

    //WEB
}

- (IBAction)toViewRank:(id)sender {
}
#pragma mark--设置
- (IBAction)didEdit:(id)sender {
    self.navigationController.navigationBarHidden =NO;
    
    TZSEditViewController *edit = [[TZSEditViewController alloc]init];
    edit.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:edit animated:YES];
    

}

- (IBAction)seeNewMessage:(id)sender {
//    self.navigationController.navigationBarHidden =NO;

}
@end
