//
//  ChangeUserInfo2ViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ChangeUserInfo2ViewController.h"
#import "TabbarViewController.h"
#import "NSString+dateWithString.h"

@interface ChangeUserInfo2ViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) NSMutableDictionary * param;

@end

@implementation ChangeUserInfo2ViewController
{
    float height;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];

    switch (self.changeType) {
        case 1://完善资料
            self.title =@"完善资料";
            self.birTf.text = @"1990-01-01";
            self.heightLabel.text = @"170";
            self.scrollView.contentOffset = CGPointMake(90*5.49, 0);

            break;
        case 2:
            self.title = @"修改资料";
            self.birTf.text =[SubUserItem shareInstance].birthday;
            
            
            self.scrollView.contentOffset = CGPointMake(([SubUserItem shareInstance].height-80)*5.49, 0);
            self.heightLabel.text = [NSString stringWithFormat:@"%d",[SubUserItem shareInstance].height];
            break;
        case 3:
            self.title = @"添加子用户资料";
            self.birTf.text = @"1990-01-01";
            self.heightLabel.text = @"170";
            self.scrollView.contentOffset = CGPointMake(90*5.49, 0);

            break;
        case 4:
            self.title = @"修改子用户资料";
            self.birTf.text =[SubUserItem shareInstance].birthday;
            self.scrollView.contentOffset = CGPointMake(([SubUserItem shareInstance].height-80)*5.49, 0);
            self.heightLabel.text = [NSString stringWithFormat:@"%d",[SubUserItem shareInstance].height];


            break;
            
        default:
            break;
    }
    // Do any additional setup after loading the view from its nib.
    self.ruleImageView.frame = CGRectMake(125, 0, 880, 61);
    [self.scrollView addSubview:self.ruleImageView];
    self.scrollView.contentSize = CGSizeMake(self.ruleImageView.bounds.size.width+self.scrollView.bounds.size.width/2, 0);
    self.scrollView.delegate = self;
    
    
    self.pickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];

    self.pickView.datePickerMode = UIDatePickerModeDate;
    NSDate * maxDate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * mindateStr = @"1900-01-01 00:00:00";
    NSDate * minDate = [formatter dateFromString:mindateStr];

    NSString * defaultDateStr = @"1990-01-01 00:00:00";
    NSDate * defaultDate = [formatter dateFromString:defaultDateStr];
    
    self.pickView.minimumDate = minDate;
    self.pickView.maximumDate = maxDate;
    
//    if (self.changeType==1||self.changeType ==3) {
        self.pickView.date = defaultDate;

//    }else{
//        self.pickView.date =   [[SubUserItem shareInstance].birthday dateyyyymmddhhmmss];
//
//    }
    
    

    [self.pickView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 375, 49)];
    UIBarButtonItem * barFit1 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    UIBarButtonItem * barFit2 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];

    UIBarButtonItem *bar = [[UIBarButtonItem alloc]
                            initWithTitle:@"完成"style:UIBarButtonItemStylePlain target:self action:@selector(didhiddenPickView)];
    //    4.加一个固定的长度作为弹簧效果
    //    5.将设置的按钮加到toolBar上
    NSArray
    * buttonsArray = [NSArray arrayWithObjects:barFit1,bar,barFit2,nil];
    [toolBar setItems:buttonsArray];
    //    6.将toolBar加到text的输入框也就是UiDatePicker上
    self.birTf.inputAccessoryView =toolBar;
    self.birTf.inputView = self.pickView;
    self.birTf.delegate = self;
    self.birTf.userInteractionEnabled = YES;
    
    
    
    
    
    
}
-(void)didhiddenPickView
{
    [self.birTf resignFirstResponder];
}
-(void)dateChanged:(UIDatePicker *)pick
{
    UIDatePicker* control = (UIDatePicker*)pick;
    NSDate* _date = control.date;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    
    [formater setDateFormat:@"yyyy-MM-dd"];//设置时间显示的格式，此处使用的formater格式要与字符串格式完全一致，否则转换失败
    
    NSString *dateStr = [formater stringFromDate:_date];//将日期转换成字符串
    self.birTf.text = dateStr;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    
    height = scrollView.contentOffset.x/5.49;
    NSLog(@"height-%.f",height);
    self.heightLabel.text = [NSString stringWithFormat:@"%.f",80+height];
}

-(void)addMainUserInfo
{
    
    self.param = [[UserModel shareInstance]getChangeUserInfoDict];
    
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:self.nickName forKey:@"nickName"];
    [self.param safeSetObject:[NSString stringWithFormat:@"%d",self.sex] forKey:@"sex"];
    [self.param safeSetObject:self.heightLabel.text forKey:@"heigth"];
    [self.param safeSetObject:self.birTf.text forKey:@"birthday"];

    
    [[BaseSservice sharedManager]postImage:@"app/evaluatUser/perfectMainUser.do" paramters:_param imageData:self.imageData success:^(NSDictionary *dic) {
        
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        NSString * subId =[NSString stringWithFormat:@"%@",[dataDic safeObjectForKey:@"id"]];
        
        [[UserModel shareInstance]setMainUserInfoWithDic:dataDic];
        
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        
        TabbarViewController *tb =[[TabbarViewController alloc]init];
        self.view.window.rootViewController =tb;

        
    } failure:^(NSError *error) {

        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接超时，请检查网络"];
        }else{
            [[UserModel shareInstance] showErrorWithStatus:@"上传失败"];
 
        }
        

    }];
    
    
    

}
-(void)addSubUserInfo
{
    self.param = [[UserModel shareInstance]getChangeUserInfoDict];
    
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:self.nickName forKey:@"nickName"];
    [self.param safeSetObject:[NSString stringWithFormat:@"%d",self.sex] forKey:@"sex"];
    [self.param safeSetObject:self.heightLabel.text forKey:@"heigth"];
    [self.param safeSetObject:self.birTf.text forKey:@"birthday"];

    
    [[BaseSservice sharedManager]postImage:@"app/evaluatUser/addChild.do" paramters:_param imageData:self.imageData success:^(NSDictionary *dic) {
        
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        NSString * subId =[NSString stringWithFormat:@"%@",[dataDic safeObjectForKey:@"id"]];
        
        [[UserModel shareInstance]setChildArrWithDict:dataDic];
        
//        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        
        
        DLog(@"%@",dic);
        [[UserModel shareInstance] showSuccessWithStatus:@"添加成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
        
        
    } failure:^(NSError *error) {
        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接超时，请检查网络"];
        }else{
            [[UserModel shareInstance] showErrorWithStatus:@"上传失败"];
            
        }
    }];
    
    
    

}
-(void)changeMainUserInfo
{
    self.param = [[UserModel shareInstance]getChangeUserInfoDict];
    
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:self.nickName forKey:@"nickName"];
    [self.param safeSetObject:[NSString stringWithFormat:@"%d",self.sex] forKey:@"sex"];
    [self.param safeSetObject:self.heightLabel.text forKey:@"heigth"];
    [self.param safeSetObject:self.birTf.text forKey:@"birthday"];
    [self.param safeSetObject:[UserModel shareInstance].subId forKey:@"id"];

    [[BaseSservice sharedManager]postImage:@"app/evaluatUser/updateChild.do" paramters:_param imageData:self.imageData success:^(NSDictionary *dic) {
        [[UserModel shareInstance]setMainUserInfoWithDic:[dic objectForKey:@"data"]];
        [[SubUserItem shareInstance]setInfoWithHealthId:[UserModel shareInstance].subId];
        
        [self.navigationController popToRootViewControllerAnimated:YES];

        
        
    } failure:^(NSError *error) {
        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接超时，请检查网络"];
        }else{
            [[UserModel shareInstance] showErrorWithStatus:@"上传失败"];
            
        }
    }];
    
    
    

}
-(void)changeSubUserInfo
{
    self.param = [[UserModel shareInstance]getChangeUserInfoDict];
    
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:self.nickName forKey:@"nickName"];
    [self.param safeSetObject:[NSString stringWithFormat:@"%d",self.sex] forKey:@"sex"];
    [self.param safeSetObject:self.heightLabel.text forKey:@"heigth"];
    [self.param safeSetObject:self.birTf.text forKey:@"birthday"];
    [self.param safeSetObject:[UserModel shareInstance].subId forKey:@"id"];


    
    [[BaseSservice sharedManager]postImage:@"/app/evaluatUser/updateChild.do" paramters:_param imageData:self.imageData success:^(NSDictionary *dic) {
        
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        NSString * subId =[NSString stringWithFormat:@"%@",[dataDic safeObjectForKey:@"id"]];
        
        [[UserModel shareInstance]setChildArrWithDict:dataDic];
        
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    } failure:^(NSError *error) {
        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"连接超时，请检查网络"];
        }else{
            [[UserModel shareInstance] showErrorWithStatus:@"上传失败"];
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didFinish:(id)sender {
    
    if (!self.birTf.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写生日"];
        return;
    }
    
    UIAlertController * la = [UIAlertController alertControllerWithTitle:@"提示" message:@"资料的真实性关乎于评测数据的准确性，是否决定提交？" preferredStyle:UIAlertControllerStyleAlert];
    [la addAction:[UIAlertAction actionWithTitle:@"重新填写" style:UIAlertActionStyleCancel handler:nil]];
    [la addAction:[UIAlertAction actionWithTitle:@"确定提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (self.changeType) {
            case 1:
                [self addMainUserInfo];
                break;
            case 2:
                [self changeMainUserInfo];
                break;
            case 3:
                [self addSubUserInfo];
                break;
            case 4:
                [self changeSubUserInfo];
                break;
                
            default:
                break;
        }

    }]];
    [self presentViewController:la animated:YES completion:nil];
    
}
@end
