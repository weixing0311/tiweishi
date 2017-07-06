//
//  HealthViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthViewController.h"
#import "HealthMainCell.h"
#import "MeasurementInfoCell.h"
#import "TZdetaolViewController.h"
#import "LoignViewController.h"
#import "UserView.h"
#import "UserCellCell.h"
#import "UserListView.h"
#import "ChangeUserInfoViewController.h"
#import "ShareViewController.h"
#import "CharViewController.h"
@interface HealthViewController ()<userListDelegate,userViewDelegate,healthMainDelegate>
@property (nonatomic,strong)UIView * userBackView;
@property (nonatomic,strong)UserListView * userListView;
@end

@implementation HealthViewController
{
    NSMutableArray * headerArr;
    NSMutableArray * listArr;
    UserView *_userView;
    NSInteger page;
    NSInteger pageSize;
    BOOL isrefresh;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize = 30;
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view from its nib.
    headerArr = [NSMutableArray array];
    listArr   = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfoView:) name:kRefreshInfo object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPcInfo) name:@"deletePCINFO" object:nil];
    _userView = [self getXibCellWithTitle:@"UserView"];
    _userView.delegate =self;
    _userView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH, 64);
    [self.view addSubview:_userView];
    
    [_userView.headBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl]];
    _userView.nameLabel.text = [SubUserItem shareInstance].nickname;
    [self buildUserListView];
    [self buildTableview];


}

-(void)buildUserListView
{
    self.userListView = [[UserListView alloc]initWithFrame:CGRectMake(0, 64, JFA_SCREEN_WIDTH, self.view.frame.size.height-64)];
    self.userListView.backgroundColor =RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .3);
    self.userListView.hidden = YES;
    self.userListView.delegate = self;
    [self.view addSubview:self.userListView];
    
}



-(void)buildTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, JFA_SCREEN_WIDTH, self.view.frame.size.height-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self setRefrshWithTableView:self.tableView];
}
-(void)headerRereshing
{
    page = 1;
    isrefresh = YES;
    [self getListInfo];
    [self getHeaderInfo];
}
-(void)footerRereshing
{
    isrefresh =NO;
    [self getListInfo];
}

-(void)getHeaderInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    [[BaseSservice sharedManager]post1:kuHeaderserReviewUrl paramters:param success:^(NSDictionary *dic) {
        
        
            [headerArr removeAllObjects];
            HealthItem *item =[[HealthItem alloc]init];
            [item setobjectWithDic:[dic objectForKey:@"data"]];
            [headerArr addObject:item];
            [self.tableView reloadData];
            
        
    } failure:^(NSError *error) {
        if (error.code ==402) {
            [headerArr removeAllObjects];
            [self.tableView reloadData];
        }

                              
    }];
}
-(void)getListInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:@"" forKey:@"startDate"];
    [param safeSetObject:@"" forKey:@"endDate"];
    [param safeSetObject:@(page) forKey:@"page"];
    [param safeSetObject:@(pageSize) forKey:@"pageSize"];
    [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatData.do" paramters:param success:^(NSDictionary *dic) {
        if (isrefresh ==YES) {
            [listArr removeAllObjects];
        }else{
            page++;
        }
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];

        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        NSArray * arr = [dataDic safeObjectForKey:@"array"];
        for (int i = 0; i<arr.count; i++) {
            NSDictionary * infoDic =[arr objectAtIndex:i];
            HealthItem *item =[[HealthItem alloc]init];
            [item setobjectWithDic:infoDic];
            [listArr addObject:item];

        }
            [self.tableView reloadData];
            

    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];

        if (error.code ==402) {
            [listArr removeAllObjects];
            [self.tableView reloadData];
        }

    }];
}
#pragma mark ---healthMainCelldelegate
/**
 * 上传数据
 */

-(void)updataInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    [param safeSetObject:@"3.1" forKey:@"mBone"];
    [param safeSetObject:@"6" forKey:@"mVisceralFat"];
    [param safeSetObject:@"65.7" forKey:@"mWeight"];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:@"14.7" forKey:@"mFat"];
    [param safeSetObject:@"1577" forKey:@"mCalorie"];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:@"34.2" forKey:@"mMuscle"];
    [param safeSetObject:@"22.7" forKey:@"mBmi"];
    [param safeSetObject:@"60.1" forKey:@"mWater"];
    
    
    [[BaseSservice sharedManager]post1:@"app/evaluatData/addEvaluatData.do" paramters:param success:^(NSDictionary *dic) {
        
        [self getHeaderInfo];
        [self getListInfo];
        
        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",dic);
        
    } failure:^(NSError *error) {
        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",error);

    }];
}
-(void)didShare
{
    ShareViewController * ss =[[ShareViewController alloc]init];
    ss.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:ss animated:YES];
}
-(void)enterDetailView
{
    HealthItem * item = [headerArr objectAtIndex:0];

    TZdetaolViewController * tz =[[TZdetaolViewController alloc]init];
    tz.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden = NO;
    tz.dataId = [NSString stringWithFormat:@"%d",item.DataId];
    [self.navigationController pushViewController:tz animated:YES];
}
-(void)didEnterChart
{
    CharViewController * cr =[[CharViewController alloc]init];
    self.navigationController.navigationBarHidden = NO;
    cr.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:cr animated:YES];
}
#pragma mark ---↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


-(void)refreshMyInfoView:(id)indo
{
    [_userView.headBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[UserModel shareInstance].headUrl]];
    _userView.nameLabel.text = [UserModel shareInstance].nickName;
}

-(void)refreshPcInfo
{
    [self getHeaderInfo];
    [self getListInfo];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }
    else{
        return listArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 550;
    }else{
        return 80;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static  NSString  *CellIdentiferId = @"MomentsViewControllerCellID";
        HealthMainCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HealthMainCell" owner:nil options:nil];
            cell = [nibs lastObject];
            }
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        if (headerArr.count>0) {
            HealthItem *item = [headerArr objectAtIndex:0];
            [cell setUpInfo:item];
        }
        else{
            [cell clearView];
        }

        return cell;
    }else{
        static NSString * identifier = @"MeasurementInfoCell";
        
        MeasurementInfoCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [self getXibCellWithTitle:identifier];
            
            cell.backgroundColor = [UIColor clearColor];
            HealthItem * item = [listArr objectAtIndex:indexPath.row];
            [cell setUpCellWithItem:item];
            
        };
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        return;
    }
    HealthItem * item = [listArr objectAtIndex:0];
    TZdetaolViewController *tz = [[TZdetaolViewController alloc]init];
    tz.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden = NO;

    tz.dataId = [NSString stringWithFormat:@"%d",item.DataId];
    [self.navigationController pushViewController:tz animated:YES];
    
}
-(void)doloign
{
    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController =lo;
        
    }]];
    [self presentViewController:al animated:YES completion:nil];
}


#pragma mark ---show subviewdelegate
-(void)showUserList
{
    self.userListView.hidden = NO;
    [self.view bringSubviewToFront:self.userListView];
    [self.userListView refreshInfo];
}
-(void)changeShowUserWithSubId:(NSString *)subId isAdd:(BOOL)isAdd
{
    if (isAdd) {
        ChangeUserInfoViewController * cu = [[ChangeUserInfoViewController alloc]init];
        cu.changeType = 3;
        self.navigationController.navigationBarHidden = NO;
        cu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cu animated:YES];
    }else{
        
        
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        [[UserModel shareInstance]setHealthidWithId:subId];
        [self reloadAll];
    }
    self.userListView.hidden = YES;

}


-(void)reloadAll
{
    
    
    [self getListInfo];
    [self getHeaderInfo];
    [_userView.headBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl]];
    _userView.nameLabel.text =[SubUserItem shareInstance].nickname;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didUpdateinfo
{
    [self updataInfo];
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
