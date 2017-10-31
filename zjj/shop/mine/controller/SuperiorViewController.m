//
//  SuperiorViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "SuperiorViewController.h"
#import "SuperiorCell.h"
#import "QRCodeResignViewController.h"
@interface SuperiorViewController ()<UITableViewDelegate,UITableViewDataSource,qrcodeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *addView;

@property (weak, nonatomic) IBOutlet UITextField *mobiletf;



@end

@implementation SuperiorViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的推荐人";
    [self setTBRedColor];
    
    
    self.mobiletf.clearButtonMode=UITextFieldViewModeAlways;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    if ([UserModel shareInstance].superiorDict&&[[UserModel shareInstance].superiorDict allKeys].count>0) {
        self.addView.hidden = YES;
    }else{
        self.addView.hidden = NO;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getReCode:(id)sender {
    QRCodeResignViewController * qr= [[QRCodeResignViewController alloc]init];
    qr.delegate = self;
    [self.navigationController pushViewController:qr animated:YES];
}
- (IBAction)addSuper:(id)sender {
    
    
    [self setUpInfo];
}

-(void)getQrCodeInfo:(NSString * )infoStr
{
    NSDictionary * dic = [self getURLParameters:infoStr];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[dic safeObjectForKey:@"recid"] forKey:@"recid"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/appuser/getPhoneByUserId.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        [[UserModel shareInstance]showSuccessWithStatus:@"获取推荐人手机号成功"];
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
        NSString * phone = [dataDic safeObjectForKey:@"phone"];
        self.mobiletf .text = phone;
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        
    }];

}



//上传推荐人信息
-(void)setUpInfo
{
    [self.mobiletf resignFirstResponder];
    if (self.mobiletf.text.length<1&&self.mobiletf.text.length!=11) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写推荐人手机号"];
        return;
    }

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params setObject:[NSString encryptString: self.mobiletf.text] forKey:@"phone"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatUser/bindingCoach.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        self.addView .hidden = YES;
        DLog(@"dic --%@",dic);
        [UserModel shareInstance].superiorDict = [dic safeObjectForKey:@"data"];
        [[UserModel shareInstance]showSuccessWithStatus:@"添加成功!"];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"SuperiorCell";
    SuperiorCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
/**
 *获取url 中的参数 以字典方式返回
 */
- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
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
