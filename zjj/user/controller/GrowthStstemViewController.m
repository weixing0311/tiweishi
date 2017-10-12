//
//  GrowthStstemViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GrowthStstemViewController.h"
#import "PublicCell.h"
#import "GrowthStstemHeaderCell.h"
#import "GrowthCell.h"
#import "LevelSnstructionsViewController.h"
@interface GrowthStstemViewController ()<UITableViewDelegate,UITableViewDataSource,growthHeaderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NSDictionary * infoDict;
@end

@implementation GrowthStstemViewController
{
//    GrowthHeader2View * grView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的等级";
    [self setTBRedColor];
    _dataArray = [NSArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
//    [self buildHeaderView];
    
    [self getInfo];
    // Do any additional setup after loading the view from its nib.
}



-(void)getInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryAll.do" paramters:params success:^(NSDictionary *dic) {
        self.infoDict = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];

        self.dataArray = [self.infoDict safeObjectForKey:@"taskArry"];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 260 ;
    }else{
    return 60;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
    return self.dataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"GrowthStstemHeaderCell";
        GrowthStstemHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.todayIntegerallb.text = [NSString  stringWithFormat:@"今日获得积分：%d",[[_infoDict safeObjectForKey:@"todayIntegeral"]intValue]];
        cell.totalIntegerallb.text = [NSString  stringWithFormat:@"%@分",[_infoDict safeObjectForKey:@"currentIntegeral"]];

        return cell;

    }else
    {
        
    static NSString * identifier = @"GrowthCell";
    GrowthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    
    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.titlelb.text = [dic safeObjectForKey:@"taskName"];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:getImage(@"")];
    cell.secondlb.text = [dic safeObjectForKey:@"integral"];
    
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ---subView Delegate
-(void)didClickQdWithCell:(GrowthStstemHeaderCell *)cell
{
    NSMutableDictionary * params  = [NSMutableDictionary dictionary];
    for (NSDictionary * dic in self.dataArray) {
        if ([[dic safeObjectForKey:@"taskName"]isEqualToString:@"签到"]) {
            [params setObject:[dic safeObjectForKey:@"id"] forKey:@"taskId"];
            [params setObject:[dic safeObjectForKey:@"integral"] forKey:@"integeral"];
        }
    }
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" paramters:params success:^(NSDictionary *dic) {
        DLog(@"签到success-dic:%@",dic);
        [[UserModel shareInstance]showSuccessWithStatus:@"签到成功！"];
        [cell.qdBtn setTitle:@"已签到" forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        DLog(@"签到失败-error:%@",error);
        
    }];

}
-(void)didShowInstructions
{
    LevelSnstructionsViewController * lev = [[LevelSnstructionsViewController alloc]init];
    lev.infoDict =_infoDict;
    [self.navigationController pushViewController:lev animated:YES];
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
