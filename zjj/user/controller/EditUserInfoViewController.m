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
#import "HeadImageCell.h"

@interface EditUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,EditUserInfoCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) UIPickerView * pickView;
@property (weak, nonatomic) IBOutlet UITextField *hiddentf;
@property (weak, nonatomic) IBOutlet UITextField *datePickTf;

@property (nonatomic,strong) UIDatePicker * datePicker;
@end

@implementation EditUserInfoViewController
{
    UIImage * beforeImage;
    UIImage * afterImage;
    int  imageType;
    int pickRow;
    BOOL haveChangeInfo;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self changeMainUserInfo];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.infoDict =[NSMutableDictionary dictionary];
        self.upDataDict = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
;
    
    self.tableview.delegate = self;
    self.tableview.dataSource= self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    
    [self setPickView];
    [self setDatePickerView];
    // Do any additional setup after loading the view from its nib.
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
    
    self.hiddentf.inputView = self.pickView;
    self.hiddentf.inputAccessoryView = toolBar;
//    self.hiddenTf.delegate = self;

}
-(void)didChoose
{
    [self.hiddentf resignFirstResponder];
    if (self.hiddentf.tag==2) {
        [self.upDataDict safeSetObject:pickRow==1?@"2":@"1" forKey:@"sex"];
    }
    else if(self.hiddentf.tag==5)
    {
        [self.upDataDict safeSetObject:@(pickRow+80) forKey:@"heigth"];
    }
    haveChangeInfo = YES;

    [self.tableview reloadData];
}
-(void)cancelChoose
{
    [self.hiddentf resignFirstResponder];
    [self.datePickTf resignFirstResponder];
}

-(void)setDatePickerView
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    self.datePicker.locale = locale;

    NSDate * maxDate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * mindateStr = @"1900-01-01 00:00:00";
    NSDate * minDate = [formatter dateFromString:mindateStr];
    
    NSString * defaultDateStr = @"1990-01-01 00:00:00";
    NSDate * defaultDate = [formatter dateFromString:defaultDateStr];
    
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
    
    //    if (self.changeType==1||self.changeType ==3) {
    self.datePicker.date = defaultDate;
    
    //    }else{
    //        self.pickView.date =   [[SubUserItem shareInstance].birthday dateyyyymmddhhmmss];
    //
    //    }
    

    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 375, 49)];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]
                             initWithTitle:@"取消"style:UIBarButtonItemStylePlain target:self action:@selector(cancelChoose)];
    UIBarButtonItem * barFit2 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]
                            initWithTitle:@"完成"style:UIBarButtonItemStylePlain target:self action:@selector(didhiddenPickView)];
    //    4.加一个固定的长度作为弹簧效果
    //    5.将设置的按钮加到toolBar上
    NSArray
    * buttonsArray = [NSArray arrayWithObjects:bar1,barFit2,bar,nil];
    [toolBar setItems:buttonsArray];
    //    6.将toolBar加到text的输入框也就是UiDatePicker上
    self.datePickTf.inputAccessoryView =toolBar;
    self.datePickTf.inputView = self.datePicker;

}
-(void)didhiddenPickView
{
    NSDate* _date = self.datePicker.date;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    
    [formater setDateFormat:@"yyyy-MM-dd"];//设置时间显示的格式，此处使用的formater格式要与字符串格式完全一致，否则转换失败
    
    NSString *dateStr = [formater stringFromDate:_date];//将日期转换成字符串
    [self.upDataDict safeSetObject:dateStr forKey:@"birthday"];
    [self.datePickTf resignFirstResponder];
    haveChangeInfo = YES;

    [self.tableview reloadData];

}
#pragma  mark --cellDidSelected
-(void)showChooseSex
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请选择性别" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.upDataDict safeSetObject:@"1" forKey:@"sex"];
        
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.upDataDict safeSetObject:@"2" forKey:@"sex"];
        
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ----接口 ----各种接口
-(void)upDataImageWithImage:(NSData *)imageData
{
    NSString * urlStr = @"";
    if (imageType ==1) {
        urlStr = @"app/evaluatUser/uploadFatBeforeImg.do";
    }else if(imageType ==2)
    {
        urlStr = @"app/evaluatUser/uploadFatAfterImg.do";
    }else{
        urlStr = @"app/user/uploadHeadImg.do";
    }
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:urlStr paramters:param imageData:imageData imageName:@"headimgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        if (imageType ==1) {
            [_infoDict safeSetObject:[dataDict safeObjectForKey:@"imgUrl"] forKey:@"fatBefore"];
        }else{
            [_infoDict safeSetObject:[dataDict safeObjectForKey:@"imgUrl"] forKey:@"fatAfter"];

        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHomePageInfo" object:nil];

        [self.tableview reloadData];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];

}
-(void)changeMainUserInfo
{
    
    if (haveChangeInfo !=YES) {
        return;
    }
    
    [self.upDataDict safeSetObject:[UserModel shareInstance].healthId forKey:@"id"];
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/evaluatUser/updateChild.do" paramters:self.upDataDict imageData:nil imageName:@"headimgurl.png" success:^(NSDictionary *dic) {
        [[UserModel shareInstance]setMainUserInfoWithDic:[dic objectForKey:@"data"]];
        [[SubUserItem shareInstance]setInfoWithHealthId:[UserModel shareInstance].healthId];
        [[UserModel shareInstance]showSuccessWithStatus:@"修改成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHomePageInfo" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
    }];
}

#pragma  mark ---tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==6) {
        return 250;
    }
    else if (indexPath.row ==0)
    {
        return 60;
    }
    else
    {
        return 44;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0) {
        static NSString * identifier = @"HeadImageCell";
        HeadImageCell * cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:getImage(@"head_default")];
        return cell;
    }
    
    else if (indexPath.row ==6) {
        static NSString * identifier = @"EditUserInfoImageCell";
        EditUserInfoImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate= self;
        [cell.fatBeforeBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatBefore"]] placeholderImage:getImage(@"before")];
        [cell.fatAfterBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatAfter"]] placeholderImage:getImage(@"last")];
        
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
            case 1:
                cell.textLabel.text = @"昵称";
                cell.detailTextLabel.text = [_upDataDict safeObjectForKey:@"nickName"];
                break;
            case 2:
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = [[_upDataDict safeObjectForKey:@"sex"]isEqualToString:@"1"]?@"男":@"女";
                break;
            case 3:
                cell.textLabel.text = @"简介";
                
                
                cell.detailTextLabel.text = [_infoDict safeObjectForKey:@"introduction"];
                break;
            case 4:
                cell.textLabel.text = @"年龄";
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[[_upDataDict safeObjectForKey:@"birthday"]getAge]];
                break;
            case 5:
                cell.textLabel.text = @"身高(cm)";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[_upDataDict safeObjectForKey:@"heigth"]];
                break;
            case 7:
                cell.textLabel.text = @"等级";
                cell.detailTextLabel.text =[_infoDict safeObjectForKey:@"gradeName"];
                break;
            case 8:
                cell.textLabel.text = @"积分";
                cell.detailTextLabel.text = [_infoDict safeObjectForKey:@"integral"];
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
        case 0 :
            [self changeHeaderWithType:3];
            break;
        case 1:
            
            [self showAlertWithType:indexPath.row];
            break;
        case 2:
            self.hiddentf.tag = indexPath.row;
            [self.hiddentf becomeFirstResponder];
            [self.pickView reloadAllComponents];

            break;
        case 3:
            [self showAlertWithType:indexPath.row];
            break;
        case 4:
            [self.datePickTf becomeFirstResponder];

            break;
        case 5:
            self.hiddentf.tag = indexPath.row;
            [self.hiddentf becomeFirstResponder];
            [self.pickView reloadAllComponents];

            break;

        default:
            break;
    }
}



#pragma  mark --

-(void)showAlertWithType:(NSInteger)indexPathRow
{
    NSString * title1 = @"修改昵称";
    NSString * title2 = @"编辑简介";
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:indexPathRow==1?title1:title2 message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [al addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = indexPathRow==1?[_upDataDict safeObjectForKey:@"nickName"]:[_infoDict safeObjectForKey:@"introduction"];
    }];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![self valiNickName:al.textFields.firstObject.text]&&indexPathRow ==1) {
            [[UserModel shareInstance]showInfoWithStatus:@"昵称格式不正确"];

            return;
        }
        if (al.textFields.firstObject.text.length<1) {
            [[UserModel shareInstance]showInfoWithStatus:@"修改内容不能为空"];
            return ;
        }
        if (al.textFields.firstObject.text.length>7&&indexPathRow ==1) {
            [[UserModel shareInstance]showInfoWithStatus:@"昵称最长7字符"];
            return;
        }

        if (indexPathRow==1) {
            [self.upDataDict safeSetObject:al.textFields.firstObject.text forKey:@"nickName"];
            haveChangeInfo = YES;
            [self.tableview reloadData];
        }else{
            //    app/user/addIntroduction.do
            //userId
            //introduction
            //修改简介

            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params safeSetObject:al.textFields.firstObject.text forKey:@"introduction"];
            [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
            
            
            
            self.currentTasks =[[BaseSservice sharedManager]post1:@"app/user/addIntroduction.do" paramters:params success:^(NSDictionary *dic) {
                [[UserModel shareInstance]showSuccessWithStatus:@"修改成功"];
                [_infoDict safeSetObject:al.textFields.firstObject.text forKey:@"introduction"];
                [self.tableview reloadData];
            } failure:^(NSError *error) {
                
            }];

        }


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
- (void)changeHeaderWithType:(int)type//type:1前2后3头像
{
    imageType = type;
    NSString * titleStr ;
    switch (type) {
        case 1:
            titleStr = @"减肥前";
            break;
        case 2:
            titleStr = @"减肥后";
            break;
        case 3:
            titleStr = @"头像";
            break;

        default:
            break;
    }
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:titleStr preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    
    if (type !=3) {
        [al addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self didDeleteFatImageWithType:type];
            
            
        }]];
    }
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}


-(void)didDeleteFatImageWithType:(int)type
{
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除图片？" preferredStyle:UIAlertControllerStyleAlert];
    
    [al addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params safeSetObject:type==1?@"fatBefore":@"fatAfter" forKey:@"type"];
        self.currentTasks =[[BaseSservice sharedManager]post1:@"" paramters:params success:^(NSDictionary *dic) {
            
            [[UserModel shareInstance ]showSuccessWithStatus:@"删除成功"];
            
            if (type==1) {
                [_infoDict removeObjectForKey:@"fatBefore"];
            }else{
                [_infoDict removeObjectForKey:@"fatAfter"];
            }
            [self.tableview reloadData];
        } failure:^(NSError *error) {
            
        }];
        
        
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
}
//点击cancel 调用的方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --pickView DELEGATE
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (self.hiddentf.tag==2) {
        return 2;
    }
    else if(self.hiddentf.tag==5)
    {
        return 200;
    }
    else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (self.hiddentf.tag==2) {
        switch (row) {
            case 0:
                return @"男";
                break;
                
            default:
                return @"女";
                break;
        }
    }
    else if(self.hiddentf.tag==5)
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

-(BOOL)valiNickName:(NSString * )nickName
{
    nickName = [nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    $("#inputNum").val(val.replace(/[^\a-\z\A-\Z0-9\u4E00-\u9FA5]/g,''));
    NSString * NICK_NUM = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NICK_NUM];
    BOOL isMatch = [pred evaluateWithObject:nickName];
    return isMatch;
    
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
