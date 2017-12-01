//
//  NewHealthViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthViewController.h"
#import "LoignViewController.h"
#import "UserCellCell.h"
#import "UserListView.h"
#import "ShareViewController.h"
#import "HealthModel.h"
#import "JPUSHService.h"
#import "ADDChengUserViewController.h"
#import "UserDirectionsViewController.h"
#import "HistoryInfoViewController.h"
#import "HealthDetailViewController.h"
#import "WeighingViewController.h"
#import "HistoryTotalViewController.h"
#import "NewHealthCell.h"
@interface NewHealthViewController ()<userListDelegate,weightingDelegate,UITableViewDelegate,UITableViewDataSource,newHealthCellDelegate>
@property (nonatomic,strong)UIView * userBackView;
@property (nonatomic,strong)UserListView * userListView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation NewHealthViewController
{
    NSMutableArray * headerArr;
    BOOL isrefresh;
    BOOL enterDetailPage;///称重完成后进去详情页面
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self refreshMyInfoView];
    
    [[UserModel shareInstance]getUpdateInfo];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    headerArr = [NSMutableArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self buildUserListView];
    [[UserModel shareInstance]getbalance];

    
    
    
//    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
//    self.tableview.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableview.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tableview.headerRefreshingText = @"刷新中..";
    self.tableview.separatorStyle =UITableViewCellSeparatorStyleNone;

    [self setJpush];
    //删除评测数据返回后刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPcInfo) name:@"deletePCINFO" object:nil];
    [self getHeaderInfo];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)headerRereshing
{
    [self getHeaderInfo];
}
#pragma mark -----
-(void)setJpush
{
    [JPUSHService setTags:nil alias:[UserModel shareInstance].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        DLog(@"设置jpush用户id为%@--是否成功-%d",[UserModel shareInstance].userId,iResCode);
        if (iResCode!=0) {
            [self setJpush];
        }
    }];
    
}
-(void)buildUserListView
{
    self.userListView = [[UserListView alloc]initWithFrame:CGRectMake(0, 20, JFA_SCREEN_WIDTH, self.view.frame.size.height-20)];
    self.userListView.backgroundColor =RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .3);
    self.userListView.hidden = YES;
    self.userListView.delegate = self;
    
    [self.view addSubview:self.userListView];
    
}
-(void)weightingSuccessWithSubtractMaxWeight:(NSString *)subtractMaxWeight dataId:(NSString *)dataId shareDict:(NSDictionary *)shareDict
{
    [self getHeaderInfo];
    HealthDetailViewController * hd =[[HealthDetailViewController alloc]init];
    hd.hidesBottomBarWhenPushed=YES;
    hd.subtractMaxWeight = subtractMaxWeight;
    hd.dataId =dataId;
    hd.shareDict = [NSMutableDictionary dictionaryWithDictionary:shareDict];
    [self.navigationController pushViewController:hd animated:YES];

}
-(void)getHeaderInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kuHeaderserReviewUrl HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [self.tableview.mj_header endRefreshing];
        
        [headerArr removeAllObjects];
        HealthItem *item =[[HealthItem alloc]init];
        [item setobjectWithDic:[dic objectForKey:@"data"]];
        [headerArr addObject:item];
        [self.tableview reloadData];;
        
    } failure:^(NSError *error) {
        if (error.code ==402) {
            [headerArr removeAllObjects];
            [self.tableview reloadData];

        }
        [self.tableview.mj_header endRefreshing];

        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JFA_SCREEN_HEIGHT>560?JFA_SCREEN_HEIGHT:560;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"NewHealthCell";
    
    NewHealthCell * cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.delegate = self;
    if (headerArr&&headerArr.count>0) {
        HealthItem * item  = [headerArr objectAtIndex:indexPath.row];
        [cell refreshPageInfoWithItem:item];
    }else{
        [cell refreshPageInfoWithItem:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark ---↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


-(void)refreshMyInfoView
{
    [self.tableview reloadData];
}

-(void)refreshPcInfo
{
    [self getHeaderInfo];
}
#pragma mark ---show subviewdelegate
-(void)changeShowUserWithSubId:(NSString *)subId isAdd:(BOOL)isAdd
{
    if (isAdd) {
        
        ADDChengUserViewController * addc = [[ADDChengUserViewController alloc]init];
        addc.isResignUser = NO;
        addc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:addc animated:YES];
        
    }else{
        
        if ([subId isEqualToString:[UserModel shareInstance].subId]) {
            [[SubUserItem shareInstance]setInfoWithHealthId:subId];
            [[UserModel shareInstance]setHealthidWithId:subId];

            [self refreshMyInfoView];
            self.userListView.hidden = YES;
            return;
        }
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        [[UserModel shareInstance]setHealthidWithId:subId];
        [self reloadAll];
    }
    self.userListView.hidden = YES;
}


-(void)reloadAll
{
    [self getHeaderInfo];
}


#pragma  mark ----cell delegate


-(void)didShowUserList
{
    if (self.userListView.hidden ==YES) {
        self.userListView.hidden = NO;
        [self.view bringSubviewToFront:self.userListView];
        [self.userListView refreshInfo];
    }else{
        self.userListView.hidden = YES;
    }

}
-(void)didShowSHuoming
{
    UserDirectionsViewController * dis = [[UserDirectionsViewController alloc]init];
    dis.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dis animated:YES];

}
-(void)didWeighting
{
    WeighingViewController * we = [[WeighingViewController alloc]init];
    we.delegate = self;
    [self presentViewController:we animated:YES completion:nil];

}
-(void)didEnterDetailVC
{
    if (!headerArr||headerArr.count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"暂无数据"];
        return;
    }
    HealthItem * item = [headerArr objectAtIndex:0];
    
    HealthDetailViewController * hd =[[HealthDetailViewController alloc]init];
    hd.hidesBottomBarWhenPushed=YES;
    hd.dataId =[NSString stringWithFormat:@"%d",item.DataId];
    
    [self.navigationController pushViewController:hd animated:YES];

}
-(void)didEnterRightVC
{
    HistoryTotalViewController * hist = [[HistoryTotalViewController alloc]init];
    hist.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: hist animated:YES];
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
