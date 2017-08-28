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

@interface MineViewController ()<qrcodeDelegate>

@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self getWaitPayCount];
    [self.headImageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationbar颜色
//    [self setNbColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfoView) name:kRefreshInfo object:nil];

    [self.headImageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.nickName.text = [UserModel shareInstance].nickName;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.waitSendLabel.hidden = YES;
    self.waitpayCountLabel .hidden = YES;
}
-(void)refreshMyInfoView
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head-default"]];
    self.nickName.text = [UserModel shareInstance].nickName;
}


/**
 *  查看待付款待配送数量
 */
-(void)getWaitPayCount
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/statusCount.do" paramters:param success:^(NSDictionary *dic) {
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
    return 3;
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

    if (indexPath.row==0) {
        cell.titleLabel.text = @"帮助中心";
        cell.secondLabel.text = @"帮助文档";
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell .headImageView.image= [UIImage imageNamed:@"personal-help-icon"];
    }
    else if ( indexPath.row ==1)
    {
        cell.titleLabel.text = @"联系我们";
        cell.secondLabel .text = @"联系方式";
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell.headImageView.image= [UIImage imageNamed:@"personal-lianxi"];
 
    }
    else
    {
        cell.titleLabel.text = @"邀请注册";
        cell.secondLabel .text = @"二维码注册";
        cell.secondLabel.textColor = HEXCOLOR(0x999999);
        cell.headImageView.image= [UIImage imageNamed:@"personal-recode"];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0) {
        HomePageWebViewController *web =[[HomePageWebViewController alloc]init];
        web.title = @"帮助中心";
        web.urlStr = [NSString stringWithFormat:@"%@app/helpConsumers.html",kMyBaseUrl];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];

    }
    
    else if(indexPath.row ==1){
        ContactUsViewController * cc = [[ContactUsViewController alloc]init];
        cc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cc animated:YES];
    }else{
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QrCodeView"owner:self options:nil];
        
        QrCodeView *rcodeView = [nib objectAtIndex:0];
        rcodeView.delegate = self;
        rcodeView.frame = self.view.frame;
        [rcodeView setInfoWithDict:nil];
        [self.view.window addSubview: rcodeView];

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
    BodyFatDivisionAgreementViewController *bd = [[BodyFatDivisionAgreementViewController alloc]init];
//    self.navigationController.navigationBarHidden = NO;

    bd.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bd animated:YES];
}
#pragma mark -----分享
-(void)didShareWithUrl:(NSString * )urlStr
{
    urlStr =[UserModel shareInstance].qrcodeImageUrl;
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"分享" message:@"选择要分享到的平台" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession url:urlStr];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline url:urlStr];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ url:urlStr];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
    
}
#pragma mark ----share
-(void) shareWithType:(SSDKPlatformType)type url:(NSString * )url
{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if (type ==SSDKPlatformSubTypeWechatSession||type ==SSDKPlatformSubTypeWechatTimeline) {
        
        [shareParams SSDKSetupWeChatParamsByText:@"" title:@"邀请伙伴" url:[NSURL URLWithString:url] thumbImage:[UserModel shareInstance].headUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
    }else{
        
        [shareParams SSDKSetupQQParamsByText:@"" title:@"" url:[NSURL URLWithString:url] audioFlashURL:nil videoFlashURL:nil thumbImage:[UserModel shareInstance].headUrl images:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        
        
        
    }
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
