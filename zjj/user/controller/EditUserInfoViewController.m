//
//  EditUserInfoViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "EditUserInfoImageCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface EditUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,EditUserInfoCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation EditUserInfoViewController
{
    UIImage * beforeImage;
    UIImage * afterImage;
    int  imageType;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.infoDict =[NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
    [self setTBRedColor];
    self.tableview.delegate = self;
    self.tableview.dataSource= self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ----接口 ----各种接口
-(void)upDataImageWithImage:(NSData *)imageData
{
    NSString * urlStr = @"";
    if (imageType ==1) {
        urlStr =@"app/evaluatUser/uploadFatBeforeImg.do";
    }else
    {
        urlStr =@"app/evaluatUser/uploadFatAfterImg.do";
    }
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:urlStr paramters:param imageData:imageData imageName:@"headimgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [self.tableview reloadData];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];

}
-(void)changeMainUserInfoWithType:(int)textType content:(NSString *)content
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    params = [[UserModel shareInstance]getChangeUserInfoDict];
    
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:textType==1?content:[UserModel shareInstance].nickName forKey:@"nickName"];
    [params safeSetObject:@([UserModel shareInstance].gender) forKey:@"sex"];
    [params safeSetObject:@([UserModel shareInstance].heigth) forKey:@"heigth"];
    [params safeSetObject:[UserModel shareInstance].birthday forKey:@"birthday"];
    [params safeSetObject:[UserModel shareInstance].subId forKey:@"id"];

    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/evaluatUser/updateChild.do" paramters:params imageData:nil imageName:@"headimgurl.png" success:^(NSDictionary *dic) {
        [[UserModel shareInstance]setMainUserInfoWithDic:[dic objectForKey:@"data"]];
        [[SubUserItem shareInstance]setInfoWithHealthId:[UserModel shareInstance].subId];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    } failure:^(NSError *error) {
    }];
    
    
    
    
}
-(void)changeSubUserInfoWithType:(int)textType content:(NSString *)content
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params = [[UserModel shareInstance]getChangeUserInfoDict];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:textType==1?content:[UserModel shareInstance].nickName forKey:@"nickName"];
    [params safeSetObject:@([UserModel shareInstance].gender) forKey:@"sex"];
    [params safeSetObject:@([UserModel shareInstance].heigth) forKey:@"heigth"];
    [params safeSetObject:[UserModel shareInstance].birthday forKey:@"birthday"];
    [params safeSetObject:[UserModel shareInstance].subId forKey:@"id"];
    
    
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"/app/evaluatUser/updateChild.do" paramters:params imageData:nil imageName:@"headimgurl.png" success:^(NSDictionary *dic) {
        
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        NSString * subId =[NSString stringWithFormat:@"%@",[dataDic safeObjectForKey:@"id"]];
        
        [[UserModel shareInstance]setChildArrWithDict:dataDic];
        
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    } failure:^(NSError *error) {
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==5) {
        return 250;
    }else{
        return 44;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==5) {
        static NSString * identifier = @"EditUserInfoImageCell";
        EditUserInfoImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate= self;
        [cell.fatBeforeBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatBefore"]] placeholderImage:getImage(@"default")];
        [cell.fatAfterBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatAfter"]] placeholderImage:getImage(@"default")];

        return cell;

        
    }else{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
        
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row <5) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"昵称";
                cell.detailTextLabel.text = [UserModel shareInstance].nickName;
                break;
            case 1:
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = [UserModel shareInstance].gender==1?@"男":@"女";
                break;
            case 2:
                cell.textLabel.text = @"简介";
                cell.detailTextLabel.text = @"文能提笔控萝莉";
                break;
            case 3:
                cell.textLabel.text = @"年龄";
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%d",[UserModel shareInstance].age];
                break;
            case 4:
                cell.textLabel.text = @"身高";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f",[UserModel shareInstance].heigth];
                break;
            case 6:
                cell.textLabel.text = @"等级";
                cell.detailTextLabel.text = @"lv2";
                break;
            case 7:
                cell.textLabel.text = @"积分";
                cell.detailTextLabel.text = @"900000";
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
    switch (indexPath.row) {
        case 0:
            [self showAlertWithType:indexPath.row];
            break;
            
        default:
            break;
    }
}
-(void)showAlertWithType:(NSInteger)indexPathRow
{
    NSString * title1 = @"修改昵称";
    NSString * title2 = @"编辑简介";
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:indexPathRow==0?title1:title2 message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [al addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}


#pragma  mark --cell delegate
-(void)changeBeforeImage
{
    [self changeHeaderWithType:1];
}
-(void)changeAfterImage
{
    [self changeHeaderWithType:2];
}

#pragma  mark ---image delegate
- (void)changeHeaderWithType:(int)type//type:1前2后
{
    imageType = type;
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:@"修改头像" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [al addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
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
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}

#pragma mark ----imagepickerdelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerOriginalImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        if (picker.sourceType ==UIImagePickerControllerSourceTypeCamera) {
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.001);
            [self upDataImageWithImage:fileDate];
            
        }else{
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.01);
            [self upDataImageWithImage:fileDate];
            
        }
        
    }
}//点击cancel 调用的方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
