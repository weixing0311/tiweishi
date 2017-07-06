//
//  ChangeUserInfoViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ChangeUserInfoViewController.h"
#import "ChangeUserInfo2ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Extension.h"
@interface ChangeUserInfoViewController ()

@end

@implementation ChangeUserInfoViewController
{
    int   _sex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.changeType) {
        case 1://完善资料
        self.title =@"完善资料";
            break;
        case 2:
         self.title = @"修改资料";
            [self isChangeInfo];
            break;
        case 3:
          self.title = @"添加子用户资料";
            break;
        case 4:
           self.title = @"修改子用户资料";
            [self isChangeInfo];
            break;
            
        default:
            break;
    }
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:254/255.0 green:86/255.0 blue:0/255.0 alpha:1];
    self.testImageView .layer.cornerRadius = 45;
    self.testImageView.layer.masksToBounds = YES;
    _sex =2;
    self.nickNameLb.returnKeyType = UIReturnKeyDone;
    self.nickNameLb.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)isChangeInfo
{
    self.nickNameLb.text = [SubUserItem shareInstance].nickname;
    [self.testImageView setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl]];
    
    _sex = [SubUserItem shareInstance].sex;
    
    if (_sex ==1) {
        self.manChooseImageView.image = [UIImage imageNamed:@"selected_"];
        self.womanChooseImageView.image = [UIImage imageNamed:@"select_"];
    }else{
        self.manChooseImageView.image = [UIImage imageNamed:@"select_"];
        self.womanChooseImageView.image = [UIImage imageNamed:@"selected_"];

    }
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

- (IBAction)chooseSex:(UIButton*)sender {
    if (sender ==self.manBtn) {
        self.manChooseImageView.image = [UIImage imageNamed:@"selected_"];
        self.womanChooseImageView.image = [UIImage imageNamed:@"select_"];
        _sex =1;
        
    }else{
        self.manChooseImageView.image = [UIImage imageNamed:@"select_"];
        self.womanChooseImageView.image = [UIImage imageNamed:@"selected_"];
        _sex =2;
    }
}

- (IBAction)next:(id)sender {
    
    ChangeUserInfo2ViewController *c2 =[[ChangeUserInfo2ViewController alloc]init];
    
    if (!self.nickNameLb.text||[self.nickNameLb.text isEqualToString:@""]||[self.nickNameLb.text isEqualToString:@" "]) {
        [self showError:@"请输入昵称"];
        return;
    }
    c2.nickName = self.nickNameLb.text;
    
    if (self.testImageView.image) {
        NSData *fileData = UIImageJPEGRepresentation(self.testImageView.image,0.001);
        c2.imageData =[NSData dataWithData:fileData];
     }
    c2.sex = _sex;
    c2.changeType = self.changeType;
    [self.navigationController pushViewController:c2 animated:YES];
}

- (IBAction)changeHeader:(id)sender {
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSString *mediaType = AVMediaTypeVideo;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            
            
            
            NSLog(@"相机权限受限");
            
            return;
            
        }
        
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerOriginalImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];
        
        self.testImageView.image = image;
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}//点击cancel 调用的方法


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nickNameLb resignFirstResponder];
    return YES;
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
