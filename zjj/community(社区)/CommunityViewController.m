//
//  CommunityViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommunityViewController.h"
#import "PublicArticleCell.h"
#import "CommunityModel.h"
#import "PostArticleViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"
#import "Masonry.h"
#import "SDImageCache.h"
#import "ArticleDetailViewController.h"
#import "CommunityCell.h"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PublicArticleCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;

/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;

@end

@implementation CommunityViewController
{
    int page;
    int pageSize;
    PublicArticleCell * PlayingCell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildRightNaviBarItem];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    pageSize= 30;
    self.segment.selectedSegmentIndex = 0;
    [self.tableview headerBeginRefreshing];
}
-(void)buildRightNaviBarItem
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings_"] style:UIBarButtonItemStylePlain target:self action:@selector(didEnterWritePage)];
    
    self.navigationItem.rightBarButtonItem = rightItem;

}
- (IBAction)enterWirte:(id)sender {
    [self didEnterWritePage];
}
-(void)didEnterWritePage
{
    PostArticleViewController * pr = [[PostArticleViewController alloc]init];
    pr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pr animated:YES];
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
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (IBAction)didEdit:(id)sender {
}
#pragma mark ---newwork requeset  网络请求
-(void)getinfo
{
    NSString * urlStr = @"";
    if (self.segment.selectedSegmentIndex ==0) {
        urlStr =@"app/community/articlepage/queryAllArticle.do";

    }else{
        urlStr =@"app/community/articlepage/queryAllArticleByUserId.do";

    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    self.currentTasks = [[BaseSservice sharedManager]post1:urlStr paramters:params success:^(NSDictionary *dic) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.tableview setFooterHidden:NO];
        }
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSMutableArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        for (NSMutableDictionary * infoDic in infoArr) {
            CommunityModel * item = [[CommunityModel alloc]init];
            [item setInfoWithDict:infoDic];
            [self.dataArray addObject:item];
        }
        [self.tableview reloadData];
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
    }];
}

//关注接口
-(void)didGzWithID:(NSString *)uid articleId:(NSString *)articleId
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:uid forKey:@"followId"];
    [params safeSetObject:articleId forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
    } failure:^(NSError *error) {
        
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
    float rowheight = item.rowHieght;
    return rowheight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
//    static  NSString * identifier = @"PublicArticleCell";
//    PublicArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [self getXibCellWithTitle:identifier];
//    }
//    cell.delegate = self;
//    cell.tag = indexPath.row;
//    [cell setInfoWithDict:item];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    static  NSString * identifier = @"CommunityCell";
    CommunityCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
//    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setInfoWithDict:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;


}
//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([PlayingCell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [_playerView destroyPlayer];
        PlayingCell = nil;
    }
}
#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // visibleCells 获取界面上能显示出来了cell
    NSArray<PublicArticleCell *> *array = [self.tableview visibleCells];
    //enumerateObjectsUsingBlock 类似于for，但是比for更快
    [array enumerateObjectsUsingBlock:^(PublicArticleCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj cellOffset];
    }];
}
//#pragma mark - 布局
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//        make.width.equalTo(self.view);
//    }];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityModel * model = [_dataArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    [self.navigationController pushViewController:ard animated:YES];
}



#pragma mark ---cell delegate

-(void)didPlayWithCell:(PublicArticleCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    //记录被点击的Cell
    PlayingCell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, (JFA_SCREEN_WIDTH-20), (JFA_SCREEN_WIDTH-20)*0.7)];
    _playerView = playerView;
    [cell.imagesView addSubview:_playerView];
//    _playerView.fillMode = ResizeAspectFill;

    //视频地址
    _playerView.url = [NSURL URLWithString:model.movieStr];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        PlayingCell.playerBtn.hidden = NO;
        _playerView = nil;
        PlayingCell = nil;
        
        NSLog(@"播放完成");
    }];

}
-(void)didGzWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    [self didGzWithID:model.userId articleId:model.uid];

}
-(void)didZanWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.userId forKey:@"followId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser" paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@""];
    } failure:^(NSError *error) {
        
    }];

}
-(void)didPLWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
//
}
-(void)didShareWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
//    /app/community/article/updateForwardingnum.do
//        参数：    id //文章Id
}
///app/reportArticle/updateIsreported.do
//参数：    userId //用户Id
//articleId //文章Id
//reportContent //举报原因



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
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

- (IBAction)didClickSegment:(UISegmentedControl *)sender {
    
    [self.tableview headerBeginRefreshing];
    
}
@end
