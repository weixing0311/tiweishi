//
//  MessageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "HomePageWebViewController.h"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation MessageViewController
{
    int page;
    int pageSize;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    pageSize =30;
    self.dataArray = [NSMutableArray array];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    [self.tableview headerBeginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)headerRereshing
{
    page =1;
    [self getinfo];
}
-(void)footerRereshing
{
    page++;
    [self getinfo];
}
-(void)getinfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];

    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/msg/queryMsgList.do" paramters:params success:^(NSDictionary *dic) {
        [self.tableview headerEndRefreshing];
        [self.tableview footerEndRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.tableview setFooterHidden:NO];
            
        }
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        
        [self.dataArray addObjectsFromArray:infoArr];
        
        [self.tableview reloadData];
        
        
        
        
    } failure:^(NSError *error) {
        [self.tableview headerEndRefreshing];
        [self.tableview footerEndRefreshing];

    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JFA_SCREEN_WIDTH*320/375;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MessageCell";
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic =[self.dataArray objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    [cell setInfoWithDict:dic];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    HomePageWebViewController * home = [[HomePageWebViewController alloc]init];
    home.urlStr = [dic safeObjectForKey:@"linkUrl"];
    [self.navigationController pushViewController: home animated:YES];
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
