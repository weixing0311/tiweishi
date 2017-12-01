//
//  IntegralShopDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralShopDetailViewController.h"
#import "IntegralShopDetailContentCell.h"
#import "IntegralShopDetailModel.h"
#import "IntegralOrderUpdateViewController.h"
#import "PhoneChargesViewController.h"
#import "VouchersUpOrderViewController.h"
@interface IntegralShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,IntegralShopDetailCellDelegate,UITextFieldDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _listArray;
    int goodsCount;
}
@end

@implementation IntegralShopDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setTBWhiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    goodsCount =1;
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.view.frame.size.height-50) style:UITableViewStylePlain];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _listArray =[NSMutableArray array];
    
    
    UIButton * buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_HEIGHT-50, JFA_SCREEN_WIDTH, 50)];
    buyBtn.backgroundColor = [UIColor redColor];
    [buyBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(didBuy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    
    
    
    [self getInfo];
}

-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:self.productNo forKey:@"productNo"];
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/integral/product/queryProductintegralDetail.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        NSDictionary * infoDict = [[[dic objectForKey:@"data"] objectForKey:@"array"]objectAtIndex:0];
        
        
        // 数组>>model数组

        IntegralShopDetailModel * model = [[IntegralShopDetailModel alloc]init];
        [model setInfoWithDict:infoDict];
        
        [_listArray addObject:model];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntegralShopDetailContentCell * cell = nil;
    IntegralShopDetailModel * model = _listArray[indexPath.row];

    NSString * identifier = @"IntegralShopDetailContentCell";
    Class mClass =  NSClassFromString(identifier);

    cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[mClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // cell自适应设置

    NSString * identifier = @"IntegralShopDetailContentCell";
    Class mClass =  NSClassFromString(identifier);
    return  [_tableView cellHeightForIndexPath:indexPath model:_listArray[indexPath.row] keyPath:@"model" cellClass:mClass contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}



#pragma mark ---cellDelegate


-(void)ChangeGoodsCount:(int)count
{
    goodsCount = count;
}
-(void)enterGoodsCount
{
    IntegralShopDetailModel * model = _listArray[0];
    int restrictionNum = [model.restrictionNum intValue];
    
    IntegralShopDetailContentCell * cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"修改数量" message:[NSString stringWithFormat:@"单笔最大配送数量：%d",restrictionNum] preferredStyle:UIAlertControllerStyleAlert];
    [al addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DLog(@"%@",al.textFields.firstObject.text);
        BOOL isNum = [self deptNumInputShouldNumber:al.textFields.firstObject.text];
        if (isNum !=YES||al.textFields.firstObject.text.length<1||[al.textFields.firstObject.text intValue]<1) {
            [[UserModel shareInstance]showInfoWithStatus:@"请输入正确的数量"];
            return ;
        }
        
        if ([al.textFields.firstObject.text intValue]>=0&&[al.textFields.firstObject.text intValue]<=restrictionNum) {
            
            [cell.mindCountBtn setTitle:al.textFields.firstObject.text forState:UIControlStateNormal];
            
            goodsCount = [al.textFields.firstObject.text intValue];
        }else{
            [[UserModel shareInstance]showInfoWithStatus:@"请输入正确的数量"];
            return;
        }
        
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}


- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
#pragma mark ---购买
///点击购买
-(void)didBuy
{
    if (!_listArray||_listArray.count<1) {
        return;
    }
    
    IntegralShopDetailModel * model = _listArray[0];
    
    if ([model.classId isEqualToString:@"1"]) {
        PhoneChargesViewController * phone = [[PhoneChargesViewController alloc]init];
        phone.model = model;
        phone.goodsCount = goodsCount;
        [phone.param safeSetObject:[self getUpdateInfo] forKey:@"orderItem"];
        [self.navigationController pushViewController:phone animated:YES];
    }
    else if([model.classId isEqualToString:@"2"])
    {
    IntegralOrderUpdateViewController *upd =[[IntegralOrderUpdateViewController alloc]init];
    upd.model= model;
    upd.goodsCount = goodsCount;
    [upd.param safeSetObject:[self getUpdateInfo] forKey:@"orderItem"];
    [self.navigationController pushViewController:upd animated:YES];
    }
    else if ([model.classId isEqualToString:@"3"])
    {
        VouchersUpOrderViewController * phone = [[VouchersUpOrderViewController alloc]init];
        phone.model = model;
        phone.goodsCount = goodsCount;
        [phone.param safeSetObject:[self getUpdateInfo] forKey:@"orderItem"];
        [self.navigationController pushViewController:phone animated:YES];

        
    }
}
//获取上传数据
-(NSString *)getUpdateInfo
{
    if (_listArray.count<1) {
        return nil;
    }
    IntegralShopDetailModel * model = [_listArray objectAtIndex:0];
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    [dic safeSetObject:model.productNo forKey:@"productNo"];
    [dic safeSetObject:[NSString stringWithFormat:@"%d",goodsCount] forKey:@"quantity"];
    
    
    [dic setObject:model.productPrice forKey:@"unitPrice"];
    [dic safeSetObject:model.productIntegral forKey:@"integral"];
    
    NSArray *arr = @[dic];
    NSString * str =[self DataTOjsonString:arr];
    return str;
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
