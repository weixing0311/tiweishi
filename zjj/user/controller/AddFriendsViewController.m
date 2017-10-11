//
//  AddFriendsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "GuanZViewController.h"
#import "QrCodeView.h"
#import "QRCodeResignViewController.h"

@interface AddFriendsViewController ()<UITextFieldDelegate,qrcodeDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchtf;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem = rightItem;
    self.searchtf.delegate = self;
    self.searchtf.returnKeyType  = UIReturnKeyGo;
    self.searchtf.clearButtonMode = UITextFieldViewModeWhileEditing;
    // Do any additional setup after loading the view from its nib.
}

-(void)getInfoWithText:(NSString *)textStr
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //userid nickname
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:textStr forKey:@"nickName"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/searchUserFollow.do" paramters:params success:^(NSDictionary *dic) {
        
        GuanZViewController * gz = [[GuanZViewController alloc]init];
        gz.title = @"搜索结果";
        gz.pageType = IS_SEARCH;
        gz.dict = [NSMutableDictionary dictionaryWithDictionary:[dic safeObjectForKey:@"data"]];
        [self.navigationController pushViewController:gz animated:YES];
    } failure:^(NSError *error) {
        
    }];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated: YES];
}
- (IBAction)didGetqrcode:(id)sender {
    QRCodeResignViewController * qr = [[QRCodeResignViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:qr];
    qr.delegate = self;
    [self presentViewController:nav animated:YES  completion:nil];

    
}
- (IBAction)showmyQRcode:(id)sender {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QrCodeView"owner:self options:nil];
    
    QrCodeView *rcodeView = [nib objectAtIndex:0];
    rcodeView.delegate = self;
    rcodeView.frame = self.view.frame;
    [rcodeView setInfoWithDict:nil];
    [self.view.window addSubview: rcodeView];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getInfoWithText:self.searchtf.text];
    return YES;
    
}
-(void)getQrCodeInfo:(NSString * )infoStr
{
    NSDictionary * dic = [self getURLParameters:infoStr];
    
    [self getInfoWithText:[dic safeObjectForKey:@"recid"]];

//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    [params safeSetObject:[dic safeObjectForKey:@"recid"] forKey:@"recid"];
//
//    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/appuser/getPhoneByUserId.do" paramters:params success:^(NSDictionary *dic) {
//
//        [[UserModel shareInstance]showSuccessWithStatus:@"获取推荐人手机号成功"];
//        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
//        NSString * phone = [dataDic safeObjectForKey:@"phone"];
//        [self getInfoWithText:phone];
//        DLog(@"%@",dic);
//    } failure:^(NSError *error) {
//
//    }];

}
#pragma mark  -----SubviewDelegate
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

- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
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
