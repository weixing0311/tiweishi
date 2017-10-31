//
//  BusinessCardViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "BusinessCardViewController.h"
#import "CardView.h"
#import <Photos/Photos.h>
@interface BusinessCardViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *createCardView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backCardImageView;

@property (weak, nonatomic) IBOutlet UITextField *gradetf;
@property (weak, nonatomic) IBOutlet UITextField *nicknametf;
@property (weak, nonatomic) IBOutlet UITextField *mbtf;
@property (weak, nonatomic) IBOutlet UITextField *wechattf;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIView *showCardView;
@property (nonatomic,assign) UIImage * backCardImage;

@end

@implementation BusinessCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShardow];

    [self setTBRedColor];
    
    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithImage:getImage(@"share_") style:UIBarButtonItemStylePlain target:self action:@selector(didShare)];
    self.navigationItem.rightBarButtonItem = rightitem;

    
    if ([[UserModel shareInstance].isHaveCard isEqualToString:@"0"]||![UserModel shareInstance].isHaveCard) {
        self.createCardView.hidden                 = NO;
        self.showCardView  .hidden                 = YES;
        
        self.title = @"生成名片";


    }else{
        self.title = @"我的名片";

        self.createCardView.hidden                 = YES;
        self.showCardView  .hidden                 = NO;
        [self getInfo];

    }
    
    
    
    
    self.nicknametf    .text                   = [UserModel shareInstance].username;
    self.gradetf       .text                   = [UserModel shareInstance].gradeName;
    self.mbtf          .text                   = [UserModel shareInstance].phoneNum;
    self.nicknametf    .userInteractionEnabled = NO;
    self.gradetf       .userInteractionEnabled = NO;
    self.mbtf          .userInteractionEnabled = NO;
    
    self.resetBtn      .layer.masksToBounds    = YES;
    self.resetBtn      .layer.cornerRadius     = 10;

    self.downLoadBtn   .layer.masksToBounds    = YES;
    self.downLoadBtn   .layer.cornerRadius     = 10;
    self.downLoadBtn   .layer.borderWidth      = 1;
    self.downLoadBtn   .layer.borderColor      = [UIColor grayColor].CGColor;

    self.updateBtn     .layer.masksToBounds    = YES;
    self.updateBtn     .layer.cornerRadius     = 10;
    
    
    self.wechattf.clearButtonMode=UITextFieldViewModeAlways;

    self.wechattf.delegate = self;
    self.wechattf.returnKeyType = UIReturnKeyDone;
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/getBusinessCard.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        DLog(@"---%@",dic);
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        
        [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:[dataDict safeObjectForKey:@"businessCardUrl"]] placeholderImage:getImage(@"busnessCard_default") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.cardImageView.image = image;
        }];
        
        [self.backCardImageView sd_setImageWithURL:[NSURL URLWithString:[dataDict safeObjectForKey:@"backCardUrl"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.backCardImage = image;
        }];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)createImageAndUpdateImage
{
    if (self.wechattf.text.length<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请填写微信号"];
        return;
    }
    
    
    CardView * caView =[self getXibCellWithTitle:@"CardView"];
    caView.nicknamelb      .text  = [UserModel shareInstance].username;
    caView.gradeLabel      .text  = [NSString stringWithFormat:@"/%@",[UserModel shareInstance].gradeName];
    caView.phonelabel      .text  = [UserModel shareInstance].phoneNum;
    caView.recodeImageView .image = [UIImage imageWithData:[UserModel shareInstance].qrcodeImageData];
    caView.recodeImageView .layer.borderWidth      = 1;
    caView.recodeImageView .layer.borderColor      = [UIColor orangeColor].CGColor;

    caView.wechatNickName.text = self.wechattf.text;
    
    [self.view addSubview:caView];

    UIImage * image= [self getImageWithView:caView];
    
    
    

    
    
    NSData *fileData = UIImageJPEGRepresentation(image,1);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/addBusinessCard.do" paramters:params imageData:fileData imageName:@"businessCardUrl" success:^(NSDictionary *dic) {
        self.cardImageView.image = image;
        
        self.createCardView.hidden = YES;
        self.showCardView.hidden =NO;

        DLog(@"cardulr:%@",dic);
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)setShardow
{
    self.cardImageView.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
    self.cardImageView.layer.shadowOpacity = 0.8f;
    self.cardImageView.layer.shadowRadius = 14.f;
    self.cardImageView.layer.shadowOffset = CGSizeMake(2,2);
    self.cardImageView.layer.masksToBounds    = NO;
    self.cardImageView.layer.cornerRadius     = 10;

}

- (IBAction)createBusinessCard:(id)sender {
    self.title = @"我的名片";
    [self.wechattf resignFirstResponder];
    [self createImageAndUpdateImage];
    
}
- (IBAction)reBuildBusinessCard:(id)sender {
    self.title = @"生成名片";
    self.createCardView.hidden = NO;
    self.showCardView.hidden = YES;

}
- (IBAction)downLoadBusinessCard:(id)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [[UserModel shareInstance]showInfoWithStatus:@"相册访问权限受限！请在设置中打开。"];
        return;
    }
    
    //然后将该图片保存到图片图
    UIImageWriteToSavedPhotosAlbum(self.cardImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    UIImageWriteToSavedPhotosAlbum(self.backCardImage, nil, nil, nil);//然后将该图片保存到图片图
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [[UserModel shareInstance]showSuccessWithStatus:@"保存成功"];
    }else{
        [[UserModel shareInstance]showInfoWithStatus:@"保存失败"];
    }
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(UIImage * )getImageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    [view removeFromSuperview];
    return viewImage;
    
}

-(void)didShare
{
    [self buildShareView];
}
-(void)buildShareView
{
    
    
    NSString * qrCode =[UserModel shareInstance].qrcodeImageUrl;
    if (!qrCode||qrCode.length<1) {
        [[UserModel shareInstance]getbalance];
    }
    
    
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline image:self.cardImageView.image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ image:self.cardImageView.image];
        
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession image:self.cardImageView.image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}
#pragma mark ----share
-(void) shareWithType:(SSDKPlatformType)type image:(UIImage *)image
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
