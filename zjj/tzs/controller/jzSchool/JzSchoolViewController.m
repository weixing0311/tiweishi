
//
//  JzSchoolViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JzSchoolViewController.h"
#import "JZSchoolCell.h"
#import "jzsSchoolWebViewController.h"
@interface JzSchoolViewController ()
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation JzSchoolViewController
{
    int page;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview headerBeginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setRefrshWithTableView:self.tableview];

    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    
    
}
/**
 *  下拉刷新
 */
-(void)headerRereshing
{
    page =1;
    [self getListInfo];
    
}
-(void)footerRereshing
{
    page ++;
    [self getListInfo];

}

/**
 * 获取数据
 */
-(void)getListInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:@(page) forKey:@"page"];
    [param safeSetObject:@"30" forKey:@"pageSize"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/queryInformateList.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);
        [self.tableview headerEndRefreshing];
        [self.tableview footerEndRefreshing];
        [self.dataArray setArray:[[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"]];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [self.tableview headerEndRefreshing];
        [self.tableview footerEndRefreshing];

        DLog(@"error--%@",error);
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier =@"JZSchoolCell";
    JZSchoolCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary *dict =[self.dataArray objectAtIndex:indexPath.row];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
    cell.titleLabel.text = [dict safeObjectForKey:@"title"];
    cell.timeLabel.text = [dict safeObjectForKey:@"releaseTime"];
    cell.zanLabel.text =[NSString stringWithFormat:@"点赞数：%d",[[dict safeObjectForKey:@"likeNum"]intValue]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic =[self.dataArray objectAtIndex:indexPath.row];
    jzsSchoolWebViewController *web =[[jzsSchoolWebViewController alloc]init];
    web.urlStr = [dic safeObjectForKey:@"linkUrl"];
    web.iscollection = [dic safeObjectForKey:@"isCollection"];
    web.islike = [dic safeObjectForKey:@"isLike"];
    web.informateId = [[dic safeObjectForKey:@"id"]intValue];
    web.isLikeNum = [dic safeObjectForKey:@"likeNum"];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
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
