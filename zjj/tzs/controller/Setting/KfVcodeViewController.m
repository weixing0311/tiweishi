//
//  KfVcodeViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/8/1.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "KfVcodeViewController.h"
#import <Photos/Photos.h>

@interface KfVcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation KfVcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBWhiteColor];
    self.title = @"客服";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)saveImage:(id)sender {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [[UserModel shareInstance]showInfoWithStatus:@"相册访问权限受限！请在设置中打开。"];
        return;
    }

    UIImageWriteToSavedPhotosAlbum(self.bgImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
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
