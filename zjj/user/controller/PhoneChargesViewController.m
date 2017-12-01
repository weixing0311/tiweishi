//
//  PhoneChargesViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PhoneChargesViewController.h"
#import "IntegralOrderViewController.h"
#import "BaseWebViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PhoneChargesViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumlb;
@property (weak, nonatomic) IBOutlet UILabel *integrallb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *totallb;
@property (weak, nonatomic) IBOutlet UILabel *bottomlb;

@end

@implementation PhoneChargesViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.param = [NSMutableDictionary dictionary];
        }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"订单信息";
    [self setTBWhiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumlb.delegate = self;
    [self.phoneNumlb addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    [self setViewInfo];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setViewInfo
{
    NSString * priceStr = self.model.productPrice;
    NSString * integral = self.model.productIntegral;
    self.integrallb.text = [NSString stringWithFormat:@"%@积分",self.model.productIntegral];
    self.pricelb.text = [NSString stringWithFormat:@"￥%@",self.model.productPrice];

    
    if (integral.intValue>0&&priceStr.floatValue>0) {
        self.bottomlb.text =[NSString stringWithFormat:@"实付款：%d积分+%.2f元",[integral intValue]*self.goodsCount,[priceStr floatValue]*self.goodsCount];
        self.totallb.text = [NSString stringWithFormat:@"%d积分+%.2f元",[integral intValue]*self.goodsCount,[priceStr floatValue]*self.goodsCount];

    }else{
        if (integral.intValue>0) {
            self.bottomlb.text =[NSString stringWithFormat:@"实付款：%d积分",[integral intValue]*self.goodsCount ];
            self.totallb.text =[NSString stringWithFormat:@"%d积分",[integral intValue]*self.goodsCount ];
        }else{
            self.bottomlb.text = [NSString stringWithFormat:@"实付款：%.2f元",[priceStr floatValue]*self.goodsCount];
            self.totallb.text = [NSString stringWithFormat:@"%.2f元",[priceStr floatValue]*self.goodsCount];
        }
    }
}
- (IBAction)didShowPhoneBook:(id)sender {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}


#pragma mark -- ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.phoneNumlb.text = (__bridge NSString*)value;
    }];
}


- (IBAction)didBuy:(id)sender {
    
    if (self.phoneNumlb.text.length!=11) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:self.phoneNumlb.text forKey:@"consigneePhone"];
    [self.param safeSetObject:@([self.model.productPrice floatValue]*self.goodsCount) forKey:@"totalPrice"];
    [self.param safeSetObject:@([self.model.productPrice floatValue]*self.goodsCount) forKey:@"payableAmount"];
    [self.param safeSetObject:self.model.stockCode forKey:@"warehouseNo"];
    [self.param safeSetObject:@([self.model.productIntegral intValue]*self.goodsCount) forKey:@"integral"];
    
    DLog(@"上传数据---%@",self.param);
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/order/saveRechargeOrderInfo.do" HiddenProgress:NO paramters:self.param success:^(NSDictionary *dic) {
        DLog(@"下单成功--%@",dic);
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        [[UserModel shareInstance]showSuccessWithStatus:@"提交成功"];
        
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
        float price = [[dataDic safeObjectForKey:@"payableAmount"]floatValue];
        if (price==0) {
            IntegralOrderViewController * ordVC = [[IntegralOrderViewController alloc]init];
            ordVC.hidesBottomBarWhenPushed = YES;
            NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [arr removeLastObject];
            [arr addObject:ordVC];
            [self.navigationController setViewControllers:arr];
        }else{
            BaseWebViewController *web = [[BaseWebViewController alloc]init];
            web.urlStr = @"app/checkstand.html";
            web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
            //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值 5积分购买
            web.payType =5;
            web.opt =1;
            web.integral = @"1";
            web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
            web.title  =@"收银台";
            [self.navigationController pushViewController:web animated:YES];
        }
        
        
    } failure:^(NSError *error) {
        //        [[UserModel shareInstance]showErrorWithStatus:@"提交失败"];
        
        DLog(@"下单失败--%@",error);
    }];

    
    
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField ==self.phoneNumlb) {
        if (self.phoneNumlb.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
            
            [self.phoneNumlb resignFirstResponder];
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
    
    if (textField ==self.phoneNumlb) {
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneNumlb resignFirstResponder];
    return YES;
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
