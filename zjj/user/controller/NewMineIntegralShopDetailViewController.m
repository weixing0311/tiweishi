//
//  NewMineIntegralShopDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineIntegralShopDetailViewController.h"
#import "IntegralDetailHeaderCell.h"
#import "IntegralDetailTextCell.h"
#import "IntegralOrderUpdateViewController.h"
@interface NewMineIntegralShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@property (weak, nonatomic) IBOutlet UILabel *buyTitlelb;
@property (weak, nonatomic) IBOutlet UIImageView *buyHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *buySecondlb;
@property (weak, nonatomic) IBOutlet UILabel *countlb;

@property (weak, nonatomic) IBOutlet UIView *buyView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;



@end

@implementation NewMineIntegralShopDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self setTBWhiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    _infoDict = [NSMutableDictionary dictionary];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self getInfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:self.productNo forKey:@"productNo"];
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/integral/product/queryProductintegralDetail.do" paramters:param success:^(NSDictionary *dic) {
        self.infoDict = [[[dic objectForKey:@"data"] objectForKey:@"array"]objectAtIndex:0];
        [self.buyHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[self.infoDict safeObjectForKey:@"picture"]] placeholderImage:getImage(@"")];
        NSString * price = [self.infoDict safeObjectForKey:@"productPrice"];
        NSString * integral = [self.infoDict safeObjectForKey:@"productIntegral"];
        
        if (price.intValue>0&&integral.intValue>0) {
            self.buyTitlelb.text = [NSString stringWithFormat:@"￥%.2f+%@分",[[self.infoDict safeObjectForKey:@"productPrice"]floatValue],integral];
            
        }else{
            if (price.intValue>0) {
                self.buyTitlelb.text = [NSString stringWithFormat:@"￥%.2f",[[self.infoDict safeObjectForKey:@"productPrice"]floatValue]];
            }else{
                self.buyTitlelb.text = [NSString stringWithFormat:@"%@分",integral];
            }
        }

        
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];

}
- (IBAction)didlickClose:(id)sender {
    self.buyView.hidden = YES;
}
- (IBAction)didBuy:(id)sender {
    
    IntegralOrderUpdateViewController *upd =[[IntegralOrderUpdateViewController alloc]init];
    
    upd.infoDict= self.infoDict;
    upd.goodsCount = self.countlb.text.intValue;
    [upd.param safeSetObject:[self getUpdateInfo] forKey:@"orderItem"];
    [self.navigationController pushViewController:upd animated:YES];

    
}
- (IBAction)didShowBuyView:(id)sender {
    [self didBuy:nil];
//    self.buyView.hidden = NO;
}
- (IBAction)didRed:(id)sender {
    if ([self.countlb.text intValue]==1) {
        return;
    }
    else{
        self.countlb.text = [NSString stringWithFormat:@"%d",self.countlb.text.intValue-1];
    }
}
- (IBAction)didAdd:(id)sender {
    self.countlb.text = [NSString stringWithFormat:@"%d",self.countlb.text.intValue+1];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 250;
            break;
        case 1:
            return 44;
            break;
            
        default:
            return 100;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==2) {
        return 5;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==0||section==1) {
        return 5;
    }else{
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
         case 1:
            return 1;
            break;
        default:
            return 2;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"IntegralDetailHeaderCell";
        IntegralDetailHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[self.infoDict safeObjectForKey:@"picture"]] placeholderImage:getImage(@"")];
        cell.titlelb .text = [self.infoDict safeObjectForKey:@"viceTitle"];
        NSString * gradeStr =[self.infoDict safeObjectForKey:@"grade"];
        if ( [gradeStr isEqualToString:@"0"]||!gradeStr) {
            cell.secondlb .text = @"无限制";
        }else{
            cell.secondlb.text = [NSString stringWithFormat:@"%@级以上",[self.infoDict safeObjectForKey:@"grade"]];
        }
        NSString * price = [self.infoDict safeObjectForKey:@"productPrice"];
        NSString * integral = [self.infoDict safeObjectForKey:@"productIntegral"];
        
        if (price.intValue>0&&integral.intValue>0) {
            cell.integrallb.text = [NSString stringWithFormat:@"￥%.2f+%@分",[[self.infoDict safeObjectForKey:@"productPrice"]floatValue],integral];
            
        }else{
            if (price.intValue>0) {
                cell.integrallb.text = [NSString stringWithFormat:@"￥%.2f",[[self.infoDict safeObjectForKey:@"productPrice"]floatValue]];
            }else{
                cell.integrallb.text = [NSString stringWithFormat:@"%@分",integral];
            }
        }
        cell.integrallb.adjustsFontSizeToFitWidth = YES;
//        cell.integrallb.text = [NSString stringWithFormat:@"%@积分",[self.infoDict safeObjectForKey:@"productIntegral"]];
        return cell;
    }
    else if (indexPath.section ==1)
    {
        static NSString * identifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"商品参数";
        cell.detailTextLabel.text = @"···";
        return cell;
    }
    else
    {
        static NSString * identifier = @"IntegralDetailTextCell";
        IntegralDetailTextCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        if (indexPath.row ==0) {
            cell.titlelb.text = @"商品详情";
            cell.contentlb.text = [self.infoDict safeObjectForKey:@"productInformation"];
        }else{
            cell.titlelb.text = @"兑换流程";
            cell.contentlb.text = @"";
 
        }
        
        return cell;
    }
}

//获取上传数据
-(NSString *)getUpdateInfo
{
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    [dic safeSetObject:[self.infoDict safeObjectForKey:@"productNo"] forKey:@"productNo"];
    [dic safeSetObject:self.countlb.text forKey:@"quantity"];
    
    
    [dic setObject:[self.infoDict safeObjectForKey:@"productPrice"] forKey:@"unitPrice"];
    [dic safeSetObject:[self.infoDict safeObjectForKey:@"productIntegral"] forKey:@"integral"];
    
    NSArray *arr = @[dic];
    NSString * str =[self DataTOjsonString:arr];
    return str;
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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
