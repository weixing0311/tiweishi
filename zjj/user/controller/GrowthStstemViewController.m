//
//  GrowthStstemViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GrowthStstemViewController.h"
#import "PublicCell.h"
#import "GrowthHeader2View.h"
#import "GrowthCell.h"
@interface GrowthStstemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSArray * dataArray;
@end

@implementation GrowthStstemViewController
{
    GrowthHeader2View * grView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买体系";
    [self setTBRedColor];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self buildHeaderView];
    
    [self getInfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)buildHeaderView
{
    grView = [self getXibCellWithTitle:@"GrowthHeader2View"];
    grView.frame  = CGRectMake(0, 0, JFA_SCREEN_WIDTH, (JFA_SCREEN_WIDTH/375)*238);
    self.tableview.tableHeaderView = grView;
}


-(void)getInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryAll.do" paramters:params success:^(NSDictionary *dic) {
        
        self.dataArray = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"taskArry"];
        grView.todayIntegerallb.text = [NSString  stringWithFormat:@"今日获得积分：%@",[[dic safeObjectForKey:@"data"]safeObjectForKey:@"todayIntegeral"]];
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
