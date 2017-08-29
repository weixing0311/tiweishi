//
//  MyCollectionViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "JZSchoolCell.h"
#import "jzsSchoolWebViewController.h"
@interface MyCollectionViewController ()
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation MyCollectionViewController
{
    int page;
}
-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.tabBarController.tabBar.hidden=YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    self.title = @"我的收藏";
    
    [self setTBRedColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    [self setRefrshWithTableView:self.tableview];
    

    // Do any additional setup after loading the view from its nib.
}


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



/**
 *  下拉刷新
 */
-(void)headerRereshing
{
    page = 1;
    [self getListInfo];
    
}
/*! 上拉加载方法 */
-(void)footerRereshing
{
    page++;

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
    [param setObject:@"30" forKey:@"pageSize"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/queryCollectionList.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);
        if ( page==1) {
            [self.dataArray removeAllObjects];
        }
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
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"find_default"]];
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
    web.islike = [dic safeObjectForKey:@"islike"];
    web.informateId = [[dic safeObjectForKey:@"id"]intValue];
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
