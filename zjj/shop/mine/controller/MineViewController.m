//
//  MineViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MineViewController.h"
#import "PublicCell.h"
#import "HomePageWebViewController.h"
#import "EidtViewController.h"
#import "BodyFatDivisionAgreementViewController.h"
#import "OrderViewController.h"
#import "ContactUsViewController.h"
#import "QrCodeView.h"
#import "SuperiorViewController.h"
#import "KfViewController.h"
#import "VouchersGetViewController.h"
#import "ShopTabbbarController.h"
@interface MineViewController ()<qrcodeDelegate>

@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self getWaitPayCount];
    self.tableview.bounces = NO;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    [self.tableview reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationbar颜色
//    [self setNbColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfoView) name:kRefreshInfo object:nil];

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.nickName.text = [UserModel shareInstance].nickName;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.waitSendLabel.hidden = YES;
    self.waitpayCountLabel .hidden = YES;

}
-(void)refreshMyInfoView
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head-default"]];
    self.nickName.text = [UserModel shareInstance].nickName;
}


/**
 *  查看待付款待配送数量
 */
-(void)getWaitPayCount
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/statusCount.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        NSDictionary *dict =[dic objectForKey:@"data"];
        
        int waitCollect      = [[dict safeObjectForKey:@"uncollected"]intValue];
        int getWaitPayCount  = [[dict safeObjectForKey:@"unpaid"]intValue];
        if (waitCollect==0) {
            self.waitSendLabel.hidden = YES;
        }else{
            self.waitSendLabel.hidden =NO;
            self.waitSendLabel.text = [NSString stringWithFormat:@"%d",waitCollect];
            self.waitSendLabel.adjustsFontSizeToFitWidth = YES;
        }
        if (getWaitPayCount==0) {
            self.waitpayCountLabel.hidden = YES;
        }else{
            self.waitpayCountLabel.hidden =NO;
            self.waitpayCountLabel.text = [NSString stringWithFormat:@"%d",getWaitPayCount];
            self.waitpayCountLabel.adjustsFontSizeToFitWidth = YES;
        }
    } failure:^(NSError *error) {
        self.waitSendLabel.hidden = YES;
        self.waitpayCountLabel.hidden = YES;
        
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    PublicCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *arr =[[NSBundle mainBundle]loadNibNamed:@"PublicCell" owner:nil options:nil];
        cell =[arr lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row ==0) {
        cell.titleLabel.text = @"领券中心";
        cell.headImageView.image = getImage(@"home_6_");

    }
    else if (indexPath.row==1) {
        cell.titleLabel.text = @"帮助中心";
        cell.secondLabel.text = @"帮助文档";
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell .headImageView.image= [UIImage imageNamed:@"personal_help_"];
    }
    else if (indexPath.row ==2)
    {
        cell.titleLabel.text = @"联系我们";
        cell.secondLabel .text = @"联系方式";
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell.headImageView.image= [UIImage imageNamed:@"personal_Lx_"];
 
    }
    else if (indexPath.row==3)
    {
        cell.titleLabel.text = @"邀请注册";
        cell.secondLabel .text = @"二维码注册";
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell.headImageView.image= [UIImage imageNamed:@"personal_resign_"];
 
    }
    else if (indexPath.row ==4)
    {
        cell.titleLabel.text = @"我的推荐人";
        if ([UserModel shareInstance].superiorDict&&[[UserModel shareInstance].superiorDict allKeys].count>0) {
            NSString * username = [NSString stringWithFormat:@"%@",[[UserModel shareInstance].superiorDict safeObjectForKey:@"userName"]];
            cell.secondLabel .text = username?username:@"";
        }else{
            cell.secondLabel .text = @"";
        }
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell.headImageView.image= [UIImage imageNamed:@"personal_tjr_"];

    }else
    {
        cell.titleLabel.text = @"在线客服";
        cell.secondLabel .text = @"";
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell.headImageView.image= [UIImage imageNamed:@"personal_kf_"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0) {
        VouchersGetViewController * vo = [[VouchersGetViewController alloc]init];
        vo.hidesBottomBarWhenPushed=YES;
        vo.myType = 5;
        [self.navigationController pushViewController:vo animated:YES];

    }
    else if (indexPath.row ==1) {
        HomePageWebViewController *web =[[HomePageWebViewController alloc]init];
        web.title = @"帮助中心";
        web.urlStr = [NSString stringWithFormat:@"%@app/helpConsumers.html",kMyBaseUrl];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];

    }
    
    else if(indexPath.row ==2){
        ContactUsViewController * cc = [[ContactUsViewController alloc]init];
        cc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cc animated:YES];
    }
    else if(indexPath.row ==3)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QrCodeView"owner:self options:nil];
        
        QrCodeView *rcodeView = [nib objectAtIndex:0];
        rcodeView.delegate = self;
        rcodeView.frame = self.view.frame;
        [rcodeView setInfoWithDict:nil];
        [self.view.window addSubview: rcodeView];
  
    }
    else if (indexPath.row ==4){
        SuperiorViewController * sp =[[SuperiorViewController alloc]init];
        sp.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:sp animated:YES];
    }
    else{
        KfViewController * kf = [[KfViewController alloc]init];
        kf.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:kf animated:YES];
    }
//    self.navigationController.navigationBarHidden = NO;

}

- (IBAction)didSetUp:(id)sender {
    EidtViewController *ed = [[EidtViewController alloc]init];
    ed.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:ed animated:YES];
}

- (IBAction)waitForPayment:(id)sender {
    OrderViewController * od =[[OrderViewController alloc]init];
    od.getOrderType = IS_WATE_PAY;
    od.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
    

    [self.navigationController pushViewController:od animated:YES];
}

- (IBAction)waitForGetGoods:(id)sender {
    OrderViewController * od =[[OrderViewController alloc]init];
    od.getOrderType = IS_WAIT_GETGOOD;
    od.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
    

    [self.navigationController pushViewController:od animated:YES];
}

- (IBAction)allTheOrder:(id)sender {
    OrderViewController * od =[[OrderViewController alloc]init];
    od.getOrderType =IS_ALL;
    od.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
    

    [self.navigationController pushViewController:od animated:YES];
}

- (IBAction)didTzs:(id)sender {
    
    int partnerId = [[UserModel shareInstance].partnerId intValue];
    int parentId = [[UserModel shareInstance].parentId intValue];
    
    
    if (parentId ==0&&partnerId==0) {
        UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"您当前没有推荐人，请点击“取消”并联系您的推荐人索取二维码进行扫描绑定，或者联系客服后台绑定。如无需绑定推荐人，请点击“继续认证”。" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [al addAction: [UIAlertAction actionWithTitle:@"取消 " style:UIAlertActionStyleCancel handler:nil]];
        [al addAction: [UIAlertAction actionWithTitle:@"继续认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BodyFatDivisionAgreementViewController *bd = [[BodyFatDivisionAgreementViewController alloc]init];
            //    self.navigationController.navigationBarHidden = NO;
            
            bd.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bd animated:YES];

        }]];
        [self presentViewController:al animated:YES completion:nil];
        return;
    }else{
        BodyFatDivisionAgreementViewController *bd = [[BodyFatDivisionAgreementViewController alloc]init];
        //    self.navigationController.navigationBarHidden = NO;
        
        bd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bd animated:YES];

    }
    
    
}
#pragma mark -----分享
-(void)didShareWithimage:(UIImage * )image
{
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"分享" message:@"选择要分享到的平台" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession image:image];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
    
}
#pragma mark ----share
-(void) shareWithType:(SSDKPlatformType)type image:(UIImage * )image
{
    
    if (!image) {
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[image];
    
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:imageArray
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeImage];
    
    [shareParams SSDKEnableUseClientShare];
    [SVProgressHUD showWithStatus:@"开始分享"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                 break;
             }
             default:
                 break;
         }
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
