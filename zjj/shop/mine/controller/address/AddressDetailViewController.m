//
//  AddressDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddressDetailViewController.h"

@interface AddressDetailViewController ()
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
        return;
    }
    if (self.mobileLabel.text .length ==0) {
        return;
    }if (self.addressTx.text.length==0) {
        return;
    }
    
    if ([self.ProvincialDict allKeys].count==0) {
        return;
    }if ([self.cityDict allKeys].count==0) {
        return;
    }
    
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
    
    
    //编辑还是添加
    if (self.isEdit ==YES) {
        [[BaseSservice sharedManager]post1:@"app/userAddress/updateAddress.do" paramters:param success:^(NSDictionary *dic) {
            if ([[dic objectForKey:@"status"]isEqualToString:@"success"]) {
                [self showHUD:onlyMsg message:@"修改成功" detai:nil Hdden:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAddressListTableView" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showHUD:onlyMsg message:[dic objectForKey:@"message"] detai:nil Hdden:YES];
            }
        } failure:^(NSError *error) {
            
        }];
   
    }else{
    
    [[BaseSservice sharedManager]post1:@"app/userAddress/addAddress.do" paramters:param success:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"status"]isEqualToString:@"success"]) {
            [self showHUD:onlyMsg message:@"修改成功" detai:nil Hdden:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAddressListTableView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHUD:onlyMsg message:[dic objectForKey:@"message"] detai:nil Hdden:YES];
        }

    } failure:^(NSError *error) {
        
    }];
    
    }
    
}

-(void)haveDefaultAddress
{
    self.nameLabel.text = [self.defaultDict objectForKey:@"receiver"];
    self.mobileLabel.text =[self.defaultDict objectForKey:@"phone"];
    self.cityTf.text = [NSString stringWithFormat:@"%@%@%@",[self.defaultDict safeObjectForKey:@"province"],[self.defaultDict safeObjectForKey:@"city"],[self.defaultDict safeObjectForKey:@"county"]];
    self.addressTx.text = [self.defaultDict safeObjectForKey:@"addr"];

}


-(void)getCityInfo
{
    [[BaseSservice sharedManager]post1:@"app/area/queryArea.do" paramters:nil success:^(NSDictionary *dic) {
        
        
        [self.dataArray addObjectsFromArray:[[dic objectForKey:@"data"] objectForKey:@"array"]];
        [[NSUserDefaults standardUserDefaults]setObject:self.dataArray forKey:@"DATAINFOARRAY"];
        
        self.secondArray = [self.dataArray[0] objectForKey:@"children"];
        self.thirdArray =[self.secondArray[0] objectForKey:@"children"];
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
        pro =  [[self.dataArray objectAtIndex:0]objectForKey:@"text"];
        city= [[self.secondArray objectAtIndex:0]objectForKey:@"text"];
        dis =  [[self.thirdArray objectAtIndex:0]objectForKey:@"text"];


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
        return [dic objectForKey:@"text"];
    }
    else if (component ==1) {
        NSDictionary *dic = [self.secondArray objectAtIndex:row];
        return [dic objectForKey:@"text"];
    }else{
        NSDictionary *dic = [self.thirdArray objectAtIndex:row];
        return [dic objectForKey:@"text"];
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
            self.secondArray = [[self.dataArray objectAtIndex:row]objectForKey:@"children"];
            NSDictionary *dic =[self.secondArray objectAtIndex:0];
            self.thirdArray= [NSMutableArray arrayWithCapacity:0];
            self.thirdArray = [dic safeObjectForKey:@"children"];
            NSLog(@"%@",[dic objectForKey:@"text"]);
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
            dis = [self getString:[[self.thirdArray objectAtIndex:0] safeObjectForKey:@"text"]];

        }
        
    }
    else if (component ==1)
    {
        if (row<self.secondArray.count) {
            self.thirdArray =[NSMutableArray arrayWithCapacity:0];
            self.thirdArray = [[self.secondArray objectAtIndex:row]objectForKey:@"children"];
            [self.cityPickerView reloadComponent:2];
            
            [self.cityDict setObject:[[self.secondArray objectAtIndex:row]safeObjectForKey:@"text"] forKey:@"text"];
            [self.cityDict setObject:[[self.secondArray objectAtIndex:row]safeObjectForKey:@"value"] forKey:@"value"];
            
            
            city =[self getString:[[self.secondArray objectAtIndex:row ]safeObjectForKey:@"text"]];
            dis = [self getString:[[self.thirdArray objectAtIndex:0 ] safeObjectForKey:@"text"]];

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
@end
