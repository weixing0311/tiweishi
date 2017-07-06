//
//  ChangeUserInfo2ViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ChangeUserInfo2ViewController.h"
#import "TabbarViewController.h"
@interface ChangeUserInfo2ViewController ()
@property (nonatomic ,strong) NSMutableDictionary * param;

@end

@implementation ChangeUserInfo2ViewController
{
    float height;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.changeType) {
        case 1://完善资料
            self.title =@"完善资料";
            break;
        case 2:
            self.title = @"修改资料";
            self.birTf.text =[SubUserItem shareInstance].birthday;
            break;
        case 3:
            self.title = @"添加子用户资料";
            break;
        case 4:
            self.title = @"修改子用户资料";
            self.birTf.text =[SubUserItem shareInstance].birthday;
            break;
            
        default:
            break;
    }
    // Do any additional setup after loading the view from its nib.
    self.ruleImageView.frame = CGRectMake(125, 0, 880, 61);
    [self.scrollView addSubview:self.ruleImageView];
    self.scrollView.contentSize = CGSizeMake(self.ruleImageView.bounds.size.width+self.scrollView.bounds.size.width/2, 0);
    self.scrollView.delegate = self;
    self.birTf.inputView = self.pickView;
    self.pickView.datePickerMode = UIDatePickerModeDate;
    NSDate * maxDate = [NSDate date];
    self.pickView.maximumDate = maxDate;
    self.pickView.date = maxDate;
    
    [self.pickView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
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
        [self hiddenHUD];
        [[UserModel shareInstance]setMainUserInfoWithDic:[dic objectForKey:@"data"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
            TabbarViewController *tb =[[TabbarViewController alloc]init];
            self.view.window.rootViewController =tb;
        
    } failure:^(NSError *error) {
        [self hiddenHUD];
        UIAlertController * alr =[ UIAlertController alertControllerWithTitle:@"错误信息" message:[NSString stringWithFormat:@"NSErrorFailingURLKey:%@  NSLocalizedDescription:%@",[error.userInfo objectForKey:@"NSErrorFailingURLKey"],[error.userInfo objectForKey:@"NSLocalizedDescription"]] preferredStyle:UIAlertControllerStyleAlert];
        [alr addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alr animated:YES completion:nil];
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
        [self hiddenHUD];
        [[UserModel shareInstance]setChildArrWithDict:[dic objectForKey:@"data"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
        
        DLog(@"%@",dic);
        [self showError:@"添加成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
        
        
    } failure:^(NSError *error) {
        [self hiddenHUD];
        UIAlertController * alr =[ UIAlertController alertControllerWithTitle:@"错误信息" message:[NSString stringWithFormat:@"NSErrorFailingURLKey:%@  NSLocalizedDescription:%@",[error.userInfo objectForKey:@"NSErrorFailingURLKey"],[error.userInfo objectForKey:@"NSLocalizedDescription"]] preferredStyle:UIAlertControllerStyleAlert];
        [alr addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alr animated:YES completion:nil];
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

    [[BaseSservice sharedManager]postImage:@"app/evaluatUser/perfectMainUser.do" paramters:_param imageData:self.imageData success:^(NSDictionary *dic) {
        [self hiddenHUD];
        [[UserModel shareInstance]setMainUserInfoWithDic:[dic objectForKey:@"data"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES];

        
    } failure:^(NSError *error) {
        [self hiddenHUD];
        UIAlertController * alr =[ UIAlertController alertControllerWithTitle:@"错误信息" message:[NSString stringWithFormat:@"NSErrorFailingURLKey:%@  NSLocalizedDescription:%@",[error.userInfo objectForKey:@"NSErrorFailingURLKey"],[error.userInfo objectForKey:@"NSLocalizedDescription"]] preferredStyle:UIAlertControllerStyleAlert];
        [alr addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alr animated:YES completion:nil];
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
        [self hiddenHUD];
        [[UserModel shareInstance]setChildArrWithDict:[dic objectForKey:@"data"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    } failure:^(NSError *error) {
        [self hiddenHUD];
        UIAlertController * alr =[ UIAlertController alertControllerWithTitle:@"错误信息" message:[NSString stringWithFormat:@"NSErrorFailingURLKey:%@  NSLocalizedDescription:%@",[error.userInfo objectForKey:@"NSErrorFailingURLKey"],[error.userInfo objectForKey:@"NSLocalizedDescription"]] preferredStyle:UIAlertControllerStyleAlert];
        [alr addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alr animated:YES completion:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didFinish:(id)sender {
    
    if (!self.birTf.text) {
        [self showError:@"请填写生日"];
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
-(void)showHUD:(HUDType)type message:(NSString *)message detai:(NSString *)detailMsg Hdden:(BOOL)hidden
{
    [super showHUD:type message:message detai:detailMsg Hdden:hidden];
}

-(void)hiddenHUD
{
    [super hiddenHUD];
}
@end
