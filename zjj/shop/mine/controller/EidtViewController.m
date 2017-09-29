//
//  EidtViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "EidtViewController.h"
#import "PublicCell.h"
#import "BaseWebViewController.h"
#import "AddressListViewController.h"
#import "ChangePasswordViewController.h"
#import "HeadImageCell.h"
#import "TZSChangeMobileViewController.h"
#import "ChangePasswordViewController.h"
#import "UIImageView+Round.h"
#import <AVFoundation/AVFoundation.h>
#import "LoignViewController.h"
@interface EidtViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation EidtViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setNbColor];
    // Do any additional setup after loading the view from its nib.
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self addFootView];
}


-(void)addFootView
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 60)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH-40, 50)];
//    view.backgroundColor = HEXCOLOR(0xeeeeee);
    button.center = view.center;
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loignout) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:HEXCOLOR(0xEE0A3B)];
    [view addSubview:button];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius  = 5;
    
    self.tableview.tableFooterView = view;
}
//退出登录
-(void)loignout
{
    UIAlertController * la =[UIAlertController alertControllerWithTitle:@"是否确认退出登录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [la addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyloignInfo];
        [[UserModel shareInstance]removeAllObject];
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController = lo;
    }]];
    [la addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:la animated:YES completion:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 2;
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0&&indexPath.row==0) {
        return 70;
    }else{
    return 60;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0&&indexPath.row==0) {
       static NSString * identifier = @"HeadImageCell";
        HeadImageCell * cell = [self getXibCellWithTitle:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
        return cell;
        
    }else{
        static NSString * identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 1:
                        cell.textLabel.text =@"会员名";
                        cell.detailTextLabel.text = [UserModel shareInstance].nickName;
                        
                        break;
                        
                    default:
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text =@"手机号";
                        cell.detailTextLabel.text =[UserModel shareInstance].mphoneNum;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    case 1:
                        cell.textLabel.text =@"收货地址管理";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    case 2:
                        cell.textLabel.text =@"修改登录密码";
                        cell.detailTextLabel.text = @"";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    default:
                        break;
                }
                
                break;
                
            default:
                break;
        }
        return cell;

    }
    
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==0) {
        if (indexPath.row ==0)
        {
            UIAlertController *la = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [la addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                    
                }
                pickerImage.delegate = self;
                pickerImage.allowsEditing = YES;
                [self presentViewController:pickerImage animated:YES completion:nil];

            }]];
            [la addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

            [la addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:la animated:YES completion:nil];
        }
        else
        {
//            BaseWebViewController *bw = [[BaseWebViewController alloc]init];
//            bw.title = @"修改昵称";
//            [self.navigationController pushViewController:bw animated:YES];
   
        }
    }
    else if (indexPath.section ==1)
    {
        
        if (indexPath.row ==0) {
            
            TZSChangeMobileViewController *tm = [[TZSChangeMobileViewController alloc]init];
            [self.navigationController pushViewController:tm animated:YES];
            
        }
        else if(indexPath.row==1)
        {
            AddressListViewController *ls =[[AddressListViewController alloc]init];
            [self.navigationController pushViewController:ls animated:YES];
 
        }
        else
        {
            ChangePasswordViewController * cp = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:cp animated:YES];
        }
    }
 
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        
        UIImage *image =info[UIImagePickerControllerEditedImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];

        [self updateImageWithImage:image];

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}//点击cancel 调用的方法


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)updateImageWithImage:(UIImage *)image
{
    
    NSData *fileData = UIImageJPEGRepresentation(image, 0.001);

    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/uploadHeadImg.do" paramters:param imageData:fileData  imageName:@"headimgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] setHeadImageUrl: [[dic objectForKey:@"data"]objectForKey:@"headimgurl"]];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance]showInfoWithStatus:@"上传失败"];
        DLog(@"faile-error-%@",error);
    }];
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
