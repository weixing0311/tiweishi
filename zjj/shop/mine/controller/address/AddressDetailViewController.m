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
/**
 *省
 */
@property (nonatomic,strong)NSMutableDictionary * ProvincialDict;
/**
 *市
 */
@property (nonatomic,strong)NSMutableDictionary * cityDict;//市
/**
 *区、县
 */
@property (nonatomic,strong)NSMutableDictionary * districtDict;
@property (nonatomic,strong)UIPickerView * cityPickerView;
@end

@implementation AddressDetailViewController
{
    NSString * pro;
    NSString * city ;
    NSString * dis;
    NSInteger   proIndex;
    NSInteger   cityIndex;
    NSInteger   disIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(updataAddress)];
    self.navigationItem.rightBarButtonItem = rightItem;
//    _dataArray = [NSMutableArray array];
//    _secondArray = [NSMutableArray array];
//    _thirdArray =[NSMutableArray array];
    proIndex = 0;
    cityIndex = 0;
    disIndex = 0;
//    [self getCityInfo];
    
    self.mobileLabel.delegate = self;
    [self.mobileLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 375, 49)];
    
    UIBarButtonItem * barFit =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]
                            initWithTitle:@"完成"style:UIBarButtonItemStylePlain target:self action:@selector(didChooseCity)];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]
                            initWithTitle:@"取消"style:UIBarButtonItemStylePlain target:self action:@selector(cancelChooseCity)];

//    4.加一个固定的长度作为弹簧效果
//    5.将设置的按钮加到toolBar上
    toolBar.items =@[bar1,barFit,bar2];
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
-(NSMutableArray *)dataArray
{
    if(!_dataArray){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"AddressList" ofType:@"plist"];
        _dataArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    return _dataArray;
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
        [[UserModel shareInstance]showInfoWithStatus:@"请输入姓名"];

        return;
    }
    if (self.mobileLabel.text .length !=11) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确手机号"];
        return;
    }if (self.addressTx.text.length==0) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入详细地址"];

        return;
    }
    
    if ([self.ProvincialDict allKeys].count==0||[self.cityDict allKeys].count==0) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择省、市、县"];

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
    
    [self.ProvincialDict setObject:[self.defaultDict safeObjectForKey:@"provinceId"] forKey:@"value"];
    [self.cityDict setObject:[self.defaultDict safeObjectForKey:@"cityId"] forKey:@"value"];
    [self.districtDict setObject:[self.defaultDict safeObjectForKey:@"countyId"] forKey:@"value"];

    
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
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"AddressList.plist"];
        [self.dataArray writeToFile:filePath atomically:YES];

        
        
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
-(void)resetPickerSelectRow
{
    [self.cityPickerView selectRow:proIndex inComponent:0 animated:YES];
    [self.cityPickerView selectRow:cityIndex inComponent:1 animated:YES];
    [self.cityPickerView selectRow:disIndex inComponent:2 animated:YES];
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
        return [[self.dataArray[proIndex]objectForKey:@"children"] count];
    }
    else{
        return [[[[[self.dataArray objectAtIndex:proIndex]safeObjectForKey:@"children"]objectAtIndex:cityIndex]safeObjectForKey:@"children"] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(component == 0){
        return self.dataArray[row][@"text"];
    }
    else if (component == 1){
        return self.dataArray[proIndex][@"children"][row][@"text"];
    }
    else{
        return [[[[[[self.dataArray objectAtIndex:proIndex]safeObjectForKey:@"children"]objectAtIndex:cityIndex]safeObjectForKey:@"children"]objectAtIndex:row]safeObjectForKey:@"text"];
    }


}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        proIndex = row;
        cityIndex = 0;
        disIndex = 0;
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    else if (component == 1){
        cityIndex = row;
        disIndex = 0;
        
        [pickerView reloadComponent:2];
    }
    else{
        disIndex = row;
    }
    
    // 重置当前选中项
    [self resetPickerSelectRow];

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

- (void)didChooseCity {
//    NSMutableDictionary * proDict =[self.dataArray objectAtIndex:proIndex];
//    NSMutableDictionary * cityDict = [[proDict safeObjectForKey:@"children"]objectAtIndex:cityIndex];
//    NSArray * arr = [cityDict safeObjectForKey:@"children"];
//        if (arr.count>0) {
//            NSMutableDictionary * disDict = [[cityDict safeObjectForKey:@"children"]objectAtIndex:disIndex];
//            dis = [self getString:[disDict  safeObjectForKey:@"text"]];
//
//        }
//    
//    pro = [self getString:[proDict  safeObjectForKey:@"text"]];
//    city =[self getString:[cityDict safeObjectForKey:@"text"]];
    
    
    self.ProvincialDict =[self.dataArray objectAtIndex:proIndex];
    
    self.cityDict = [[self.ProvincialDict safeObjectForKey:@"children"]objectAtIndex:cityIndex];
    
    
    pro = [self getString:[self.ProvincialDict  safeObjectForKey:@"text"]];
    city =[self getString:[self.cityDict safeObjectForKey:@"text"]];
    
    NSArray * arr = [self.cityDict safeObjectForKey:@"children"];
    if (arr.count>0) {
        self.districtDict = [[self.cityDict safeObjectForKey:@"children"]objectAtIndex:disIndex];
        dis = [self getString:[self.districtDict  safeObjectForKey:@"text"]];
        
    }
    
    

    self.cityTf.text = [NSString stringWithFormat:@"%@ %@ %@",pro,city,dis?dis:@""];
    [self.cityTf resignFirstResponder];
}
-(void)cancelChooseCity
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
