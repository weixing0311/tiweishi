//
//  TZSEditViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSEditViewController.h"
#import "HeadImageCell.h"
#import "ChangePasswordViewController.h"
#import "ChangeJYpasswordViewController.h"
#import "ForgetJYpasswordViewController.h"
#import "TZSChangeMobileViewController.h"
#import "ImageViewController.h"
#import "LoignViewController.h"
#import "HomePageWebViewController.h"
@interface TZSEditViewController ()

@end

@implementation TZSEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    
    [self setNbColor];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfoView) name:kRefreshInfo object:nil];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    [self addFootView];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)refreshMyInfoView
{
    [self.tableview reloadData];
}
-(void)addFootView
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 60)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH-40, 50)];
    button.center = view.center;
    view.backgroundColor = HEXCOLOR(0xeeeeee);

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
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 4;
    }else if(section==1){
        return 3;
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0&&indexPath.row==0) {
        return 70;
    }else{
        return 60;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row ==0) {
        static NSString * identifier = @"HeadImageCell";
        HeadImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"logo_"]];
        return cell;
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        
                        break;
                    case 1:
                        cell.textLabel.text = @"姓名";
                        cell.detailTextLabel.text = [UserModel shareInstance].username;
//                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                        break;
                        case 2:
                        cell.textLabel.text = @"会员名";
                        cell.detailTextLabel.text = [UserModel shareInstance].nickName;
//                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    case 3:
                        cell.textLabel.text = @"手机号";
                        cell.detailTextLabel.text = [UserModel shareInstance].mphoneNum;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    default:
                        break;
                }

                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"修改登录密码";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    case 1:
                        cell.textLabel.text = @"修改交易密码";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    case 2:
                        cell.textLabel.text = @"忘记交易密码";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    default:
                        break;
                }
                
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"客服电话";
                        cell.detailTextLabel.text = @"4006-119-516";
                        cell.detailTextLabel.textColor = [UIColor blueColor];
                        break;
                    case 1:
                        cell.textLabel.text = @"公司简介";
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
//            ImageViewController *imageVC =[[ImageViewController alloc]init];
//            [self.navigationController pushViewController:imageVC animated:YES];
            [self ChangeHeadImage:nil];
        }
        
        else if (indexPath.row ==1)
        {
            
        }
        else if (indexPath.row ==2)
        {
            
        }
        else
        {
            TZSChangeMobileViewController *cg =[[TZSChangeMobileViewController alloc]init];
            [self.navigationController pushViewController:cg animated:YES];
        }
    }
    else if (indexPath.section ==1) {
        if (indexPath.row ==0) {
            ChangePasswordViewController *cp = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:cp animated:YES];
            
        }
        else if (indexPath.row ==1)
        {
            ChangeJYpasswordViewController *cj =[[ChangeJYpasswordViewController alloc]init];
            [self.navigationController pushViewController:cj animated:YES];
        }
        else
        {
            ForgetJYpasswordViewController *fj = [[ForgetJYpasswordViewController alloc]init];
            [self.navigationController pushViewController:fj animated:YES];
        }
    }
    else
    {
        if (indexPath.row ==0)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006119516"]];

        }else{
//
            HomePageWebViewController * web= [[HomePageWebViewController alloc]init];
            web.title = @"公司简介";
            web.urlStr = [NSString stringWithFormat:@"%@app/fatTeacher/companyProfile.html",kMyBaseUrl];
            [self.navigationController pushViewController:web animated:YES];
            
        }
    }
}

#pragma mark ----imagepickerdelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerEditedImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (picker.sourceType ==UIImagePickerControllerSourceTypeCamera) {
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.001);
            [self updateImageWithImage:fileDate];
            
        }else{
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.01);
            [self updateImageWithImage:fileDate];
            
        }
        
    }
}//点击cancel 调用的方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateImageWithImage:(NSData *)fileData
{
    
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/uploadHeadImg.do" paramters:param imageData:fileData imageName:@"headimgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] setHeadImageUrl: [[dic objectForKey:@"data"]objectForKey:@"headimgurl"]];
        [self.tableview reloadData];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];
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
