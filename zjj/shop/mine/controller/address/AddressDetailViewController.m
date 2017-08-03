//
//  AddressDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddressDetailViewController.h"

@interface AddressDetailViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * secondArray;
@property (nonatomic,strong)NSMutableArray * thirdArray;
@property (nonatomic,strong)NSMutableDictionary * ProvincialDict;//省
@property (nonatomic,strong)NSMutableDictionary * cityDict;//市
@property (nonatomic,strong)NSMutableDictionary * districtDict;//区、县
@property (nonatomic,strong)UIPickerView * cityPickerView;
@end

@implementation AddressDetailViewController
{
    NSString * pro;
    NSString * city ;
    NSString *dis;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(updataAddress)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _dataArray = [NSMutableArray array];
    _secondArray = [NSMutableArray array];
    _thirdArray =[NSMutableArray array];
    [self getCityInfo];
    
    self.mobileLabel.delegate = self;
    [self.mobileLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 375, 49)];
    UIBarButtonItem * barFit =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    UIBarButtonItem *bar = [[UIBarButtonItem alloc]
                            initWithTitle:@"完成"style:UIBarButtonItemStylePlain target:self action:@selector(didChooseCity)];
//    4.加一个固定的长度作为弹簧效果
//    5.将设置的按钮加到toolBar上
    toolBar.items =@[barFit,bar];
//    6.将toolBar加到text的输入框也就是UiDatePicker上
    
    
    self.cityPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
    
    // 代理
    self.cityPickerView.delegate = self;
    self.cityPickerView.dataSource = self;
    
    
    self.cityTf.inputView = self.cityPickerView;
    self.cityTf.inputAccessoryView = toolBar;
    self.cityTf.delegate = self;
    
    
    
    
    if (_isEdit==YES) {
        [self haveDefaultAddress];
    }
    self.addressTx.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(NSMutableDictionary*)ProvincialDict
{
    if (!_ProvincialDict) {
        _ProvincialDict =[NSMutableDictionary new];
    }
    return _ProvincialDict;
}
-(NSMutableDictionary*)cityDict
{
    if (!_cityDict) {
        _cityDict =[NSMutableDictionary new];
    }
    return _cityDict;
}

-(NSMutableDictionary*)districtDict
{
    if (!_districtDict) {
        _districtDict =[NSMutableDictionary new];
    }
    return _districtDict;
}
-(void)updataAddress
{
    if (self.nameLabel.text.length==0) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入手机号"];

        return;
    }
    if (self.mobileLabel.text .length !=11) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确手机号"];
        return;
    }if (self.addressTx.text.length==0) {
        return;
    }
    
    if ([self.ProvincialDict allKeys].count==0) {
        return;
    }if ([self.cityDict allKeys].count==0) {
        return;
    }
    
    
    
    //编辑还是添加/userAddress/updateAddress.do
    if (self.isEdit ==YES) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[self.ProvincialDict  safeObjectForKey:@"value"] forKey:@"provinceId"];
        [param safeSetObject:[self.cityDict        safeObjectForKey:@"value"] forKey:@"cityId"];
        [param safeSetObject:[self.districtDict    safeObjectForKey:@"value"] forKey:@"countyId"];
        [param safeSetObject:[self.defaultDict safeObjectForKey:@"id"] forKey:@"id"];
        [param safeSetObject:self.mobileLabel.text forKey:@"phone"];
        [param safeSetObject:self.nameLabel.text   forKey:@"receiver"];
        [param safeSetObject:self.addressTx.text   forKey:@"addr"];
        [param safeSetObject:@"" forKey:@"postCode"];
        [param safeSetObject:self.defaultSwitch.isOn?@"1":@"0" forKey:@"isDefault"];//是不是默认地址 0否1是

        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userAddress/updateAddress.do" paramters:param success:^(NSDictionary *dic) {
                [[UserModel shareInstance] showSuccessWithStatus:@"修改成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAddressListTableView" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            [[UserModel shareInstance] showErrorWithStatus:@"修改失败"];
        }];
   
    }else{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:[self.ProvincialDict  safeObjectForKey:@"value"] forKey:@"provinceId"];
        [param safeSetObject:[self.cityDict        safeObjectForKey:@"value"] forKey:@"cityId"];
        [param safeSetObject:[self.districtDict    safeObjectForKey:@"value"] forKey:@"countyId"];
        [param safeSetObject:self.mobileLabel.text forKey:@"phone"];
        [param safeSetObject:self.nameLabel.text   forKey:@"receiver"];
        [param safeSetObject:self.addressTx.text   forKey:@"addr"];
        [param safeSetObject:@"" forKey:@"postCode"];
        [param safeSetObject:self.defaultSwitch.isOn?@"1":@"0" forKey:@"isDefault"];//是不是默认地址 0否1是

    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userAddress/addAddress.do" paramters:param success:^(NSDictionary *dic) {
            [[UserModel shareInstance] showSuccessWithStatus: @"添加成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAddressListTableView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:@"添加失败"];
    }];
    
    }
    
}

-(void)haveDefaultAddress
{
    self.nameLabel.text = [self.defaultDict objectForKey:@"receiver"];
    self.mobileLabel.text =[self.defaultDict objectForKey:@"phone"];
    self.cityTf.text = [NSString stringWithFormat:@"%@%@%@",[self.defaultDict safeObjectForKey:@"province"],[self.defaultDict safeObjectForKey:@"city"],[self.defaultDict safeObjectForKey:@"county"]];
    self.addressTx.text = [self.defaultDict safeObjectForKey:@"addr"];
    if (self.addressTx.text.length>0) {
        self.tisLabel.text = @"";
    }
    if ([[self.defaultDict safeObjectForKey:@"isDefault"]intValue]==1) {
        [self.defaultSwitch  setOn:YES];;
    }else{
        [self.defaultSwitch setOn:NO];
    }
}


-(void)getCityInfo
{
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/area/queryArea.do" paramters:nil success:^(NSDictionary *dic) {
        
        
        [self.dataArray addObjectsFromArray:[[dic safeObjectForKey:@"data"] objectForKey:@"array"]];
        [[NSUserDefaults standardUserDefaults]setObject:self.dataArray forKey:@"DATAINFOARRAY"];
        
        self.secondArray = [self.dataArray[0] safeObjectForKey:@"children"];
        self.thirdArray =[self.secondArray[0] safeObjectForKey:@"children"];
        [self.cityPickerView reloadAllComponents];
        
        [self.ProvincialDict setObject:[[self.dataArray objectAtIndex:0]safeObjectForKey:@"text"] forKey:@"text"];
        [self.ProvincialDict setObject:[[self.dataArray objectAtIndex:0]safeObjectForKey:@"value"] forKey:@"value"];

        if (self.secondArray.count>0) {
            [self.cityDict setObject:[[self.secondArray objectAtIndex:0]safeObjectForKey:@"text"] forKey:@"text"];
            [self.cityDict setObject:[[self.secondArray objectAtIndex:0]safeObjectForKey:@"value"] forKey:@"value"];
            
        }
        if (self.thirdArray.count>0) {
            self.districtDict =self.thirdArray[0];
        }
        pro =  [[self.dataArray objectAtIndex:0]safeObjectForKey:@"text"];
        city= [[self.secondArray objectAtIndex:0]safeObjectForKey:@"text"];
        if (self.thirdArray.count>0) {
            
            dis =  [[self.thirdArray objectAtIndex:0]safeObjectForKey:@"text"];
        }else{
            dis = @"";
        }

    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component==0) {
        return self.dataArray.count;
    }else if (component==1)
    {
        return self.secondArray.count;
    }
    else{
        return self.thirdArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component ==0) {
        NSDictionary *dic = [self.dataArray objectAtIndex:row];
        return [dic safeObjectForKey:@"text"];
    }
    else if (component ==1) {
        NSDictionary *dic = [self.secondArray objectAtIndex:row];
        return [dic safeObjectForKey:@"text"];
    }else{
        NSDictionary *dic = [self.thirdArray objectAtIndex:row];
        return [dic safeObjectForKey:@"text"];
    }

}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"%ld",(long)row);
    if (component ==0) {
        
        if (row<self.dataArray.count) {
            
            self.dataArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"DATAINFOARRAY"];
            
            self.secondArray =[NSMutableArray arrayWithCapacity:0];
            self.secondArray = [[self.dataArray objectAtIndex:row]safeObjectForKey:@"children"];
            NSDictionary *dic =[self.secondArray objectAtIndex:0];
            self.thirdArray= [NSMutableArray arrayWithCapacity:0];
            self.thirdArray = [dic safeObjectForKey:@"children"];
            NSLog(@"%@",[dic safeObjectForKey:@"text"]);
            [self.cityPickerView reloadComponent:1];
            [self.cityPickerView reloadComponent:2];
            
            [self.ProvincialDict setObject:[[self.dataArray objectAtIndex:row]safeObjectForKey:@"text"] forKey:@"text"];
            [self.ProvincialDict setObject:[[self.dataArray objectAtIndex:row]safeObjectForKey:@"value"] forKey:@"value"];
            
            if (self.secondArray.count>0) {
                [self.cityDict setObject:[[self.secondArray objectAtIndex:0]safeObjectForKey:@"text"] forKey:@"text"];
                [self.cityDict setObject:[[self.secondArray objectAtIndex:0]safeObjectForKey:@"value"] forKey:@"value"];
                
            }
            if (self.thirdArray.count>0) {
                self.districtDict =self.thirdArray[0];
            }
            pro = [self getString:[[self.dataArray objectAtIndex:row] safeObjectForKey:@"text"]];
            city =[self getString:[[self.secondArray objectAtIndex:0] safeObjectForKey:@"text"]];
            if (self.thirdArray.count>0) {
                dis = [self getString:[[self.thirdArray objectAtIndex:0] safeObjectForKey:@"text"]];
            }else{
                dis = @"";
            }

        }
        
    }
    else if (component ==1)
    {
        if (row<self.secondArray.count) {
            self.thirdArray =[NSMutableArray arrayWithCapacity:0];
            self.thirdArray = [[self.secondArray objectAtIndex:row]safeObjectForKey:@"children"];
            [self.cityPickerView reloadComponent:2];
            
            [self.cityDict setObject:[[self.secondArray objectAtIndex:row]safeObjectForKey:@"text"] forKey:@"text"];
            [self.cityDict setObject:[[self.secondArray objectAtIndex:row]safeObjectForKey:@"value"] forKey:@"value"];
            
            
            city =[self getString:[[self.secondArray objectAtIndex:row ]safeObjectForKey:@"text"]];
            if (self.thirdArray.count>0) {
                dis = [self getString:[[self.thirdArray objectAtIndex:0 ] safeObjectForKey:@"text"]];

            }else{
                dis = @"";
            }

        }
    }
    else
    {
        if (row<self.thirdArray.count) {
            self.districtDict =self.thirdArray[row];
            dis = [self getString:[self.districtDict safeObjectForKey:@"text"]];

        }
    }

}

-(void)getDict
{
    
}

-(NSString *)getString:(NSString *)string
{
    if (!string) {
        return @" ";
    }
    else{
        return string;
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
- (void)didChooseCity {
    
    self.cityTf.text = [NSString stringWithFormat:@"%@ %@ %@",pro,city,dis];
    [self.cityTf resignFirstResponder];
}

- (IBAction)saveAddress:(id)sender {
    [self updataAddress];

}

#pragma mark --textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.tisLabel.text = @"";
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length<1) {
        self.tisLabel.text = @"详细地址";
    }else{
        self.tisLabel.text = @"";
    }
}
- (IBAction)didFinishChoose:(id)sender {
    [self.cityTf  endEditing:YES];
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField ==self.mobileLabel) {
        if (self.mobileLabel.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
            
            [self.mobileLabel resignFirstResponder];
        }
    }
}
- (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"^[0-9]*$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField ==self.mobileLabel) {
        if ([self isNumText:string]==YES) {
            return YES;
        }else{
            [[UserModel shareInstance]showInfoWithStatus:@"请输入数字"];
            return NO;
        }
    }
    return YES;
    DLog(@"rang-%@",NSStringFromRange(range));
}



@end
