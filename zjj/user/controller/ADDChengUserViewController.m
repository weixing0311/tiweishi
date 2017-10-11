//
//  ADDChengUserViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ADDChengUserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Extension.h"
#import "TabbarViewController.h"
@interface ADDChengUserViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
- (IBAction)didChangeHeaderImage:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
- (IBAction)didClickManBtn:(id)sender;
- (IBAction)didClickWomanBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nicknametf;
@property (weak, nonatomic) IBOutlet UITextField *agetf;
@property (weak, nonatomic) IBOutlet UITextField *heighttf;
@property (nonatomic,strong) UIPickerView * pickView;

@end

@implementation ADDChengUserViewController
{
    int pickRow;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//上传数据
-(void)upDateInfo
{
    if (self.isResignUser ==YES) {
        [self addMainUserInfo];
    }
    else
    {
        [self addSubUserInfo];
    }
}



-(void)addSubUserInfo
{
    
    
    if ([[UserModel shareInstance] valiNickName:self.nicknametf.text]!=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"昵称只能由中文、字母或数字组成"];
        return;
    }
    
    
    if (self.nicknametf.text.length>6) {
        [[UserModel shareInstance] showInfoWithStatus:@"昵称最长为6字符"];
        return;
        
    }
    if (self.agetf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写年龄"];
        return;
        
    }
    if (self.heighttf.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写身高"];
        return;
        
    }

    
    
    NSData *fileData = UIImageJPEGRepresentation(self.headImageView.imageView.image,0.001);

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params = [[UserModel shareInstance]getChangeUserInfoDict];
    
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.nicknametf.text forKey:@"nickName"];
    [params safeSetObject:[NSString stringWithFormat:@"%d",self.manBtn.selected==YES?1:2] forKey:@"sex"];
    [params safeSetObject:self.heighttf.text forKey:@"heigth"];
    [params safeSetObject:self.agetf.text forKey:@"birthday"];
    
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/evaluatUser/addChild.do" paramters:params imageData:fileData imageName:@"headimgurl.png" success:^(NSDictionary *dic) {
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        
        [[UserModel shareInstance]setChildArrWithDict:dataDic];
        
        DLog(@"%@",dic);
        [[UserModel shareInstance] showSuccessWithStatus:@"添加成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
    }];
        
}
-(void)addMainUserInfo
{
    NSData *fileData = UIImageJPEGRepresentation(self.headImageView.imageView.image,0.001);

    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.nicknametf.text forKey:@"nickName"];
    [params safeSetObject:[NSString stringWithFormat:@"%d",self.manBtn.selected==YES?1:2] forKey:@"sex"];
    [params safeSetObject:self.heighttf.text forKey:@"heigth"];
    [params safeSetObject:self.agetf.text forKey:@"birthday"];

    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/evaluatUser/perfectMainUser.do" paramters:params imageData:fileData imageName:@"headimgurl.png" success:^(NSDictionary *dic) {
        
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        NSString * subId =[NSString stringWithFormat:@"%@",[dataDic safeObjectForKey:@"id"]];
        
        [[UserModel shareInstance]setMainUserInfoWithDic:dataDic];
        
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        
        TabbarViewController *tb =[[TabbarViewController alloc]init];
        self.view.window.rootViewController =tb;
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
    
    
    
}


- (IBAction)didClickManBtn:(id)sender {
    if (self.manBtn.selected==YES) {
        return;
    }
    self.manBtn.selected = YES;
    self.womanBtn.selected =NO;
}

- (IBAction)didClickWomanBtn:(id)sender {
    if (self.womanBtn.selected ==YES) {
        return;
    }
    self.womanBtn.selected =YES;
    self.manBtn.selected =NO;
    
}
- (IBAction)didChangeHeaderImage:(id)sender {
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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



-(void)setPickView
{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 375, 49)];
    
    UIBarButtonItem * barFit =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]
                             initWithTitle:@"完成"style:UIBarButtonItemStylePlain target:self action:@selector(didChoose)];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]
                             initWithTitle:@"取消"style:UIBarButtonItemStylePlain target:self action:@selector(cancelChoose)];
    
    //    4.加一个固定的长度作为弹簧效果
    //    5.将设置的按钮加到toolBar上
    toolBar.items =@[bar1,barFit,bar2];
    //    6.将toolBar加到text的输入框也就是UiDatePicker上
    
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
    
    // 代理
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    
    self.agetf.inputView = self.pickView;
    self.agetf.inputAccessoryView = toolBar;
    self.heighttf.inputView = self.pickView;
    self.heighttf.inputAccessoryView = toolBar;

    //    self.hiddenTf.delegate = self;
    
}
-(void)didChoose
{
    if ([self.agetf isFirstResponder]) {
        [self.agetf resignFirstResponder];

        self.agetf.text = [NSString stringWithFormat:@"%d",pickRow];
    }
    else if ([self.heighttf isFirstResponder])
    {
        [self.heighttf resignFirstResponder];
        self.heighttf.text = [NSString stringWithFormat:@"%d",pickRow+80];
    }
}
-(void)cancelChoose
{
    [self.agetf resignFirstResponder];
    [self.heighttf resignFirstResponder];

}

#define imagepick
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerEditedImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];
        
        [self.headImageView setImage:image forState:UIControlStateNormal];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}//点击cancel 调用的方法


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark ---pickViewDelegate
#pragma mark --pickView DELEGATE
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if ([self.agetf isFirstResponder])
    {
        return 130;
    }
    else if([self.heighttf isFirstResponder])
    {
        return 200;
    }
    else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ([self.agetf isFirstResponder])
    {
        return [NSString  stringWithFormat:@"%ld",row+1];
    }
    else if([self.heighttf isFirstResponder])
    {
        return [NSString  stringWithFormat:@"%ld",row+80];
    }
    else{
        return nil;
    }
    
    
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickRow = row;
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
