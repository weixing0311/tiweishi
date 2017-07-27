//
//  ImageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/26.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+Round.h"
@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
   self.title = @"头像";

    [self.imageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    [self.imageView setMyImageWithUrl:[UserModel shareInstance].headUrl placeHolder:[UIImage imageNamed:@"head_default"] success:^(UIImage *image) {
        CGSize size = [image changeimageViewSize];
        DLog(@"%f,%f",size.width,size.height);
        self.imageView.frame = CGRectMake(0, 0, 100, 100);
        
        self.imageView.center =self.view.center;

    }];
    
    self.imageView.frame = CGRectMake(0, 0, 100, 100);

    [_changeBtn setBackgroundColor:RGBACOLOR(0/225.0F, 0/225.0F, 0/225.0F, .5)];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ----imagepickerdelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        self.imageView.image = image;
        [self updateImageWithImage:image];
    }
}//点击cancel 调用的方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//等比例缩放

-(void)updateImageWithImage:(UIImage *)image
{
    
    NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/uploadHeadImg.do" paramters:param imageData:fileData success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] setHeadImageUrl: [[dic objectForKey:@"data"]objectForKey:@"headimgurl"]];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"faile-error-%@",error);
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

- (IBAction)ChangeHeadImage:(id)sender {
    

    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:@"修改头像" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];

}
@end
