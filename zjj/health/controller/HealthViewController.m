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
#import "WWXBlueToothManager.h"
#import "HealthModel.h"
#import "JPUSHService.h"
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
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self refreshMyInfoView];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize = 30;
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view from its nib.
    headerArr = [NSMutableArray array];
    listArr   = [NSMutableArray array];
    [self setJpush];

    //删除评测数据返回后刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPcInfo) name:@"deletePCINFO" object:nil];
    
    _userView = [self getXibCellWithTitle:@"UserView"];
    _userView.delegate =self;
    _userView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH, 64);
    [self.view addSubview:_userView];
    
    [_userView.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    _userView.nameLabel.text = [SubUserItem shareInstance].nickname;
    [self buildUserListView];
    [self buildTableview];
    [[UserModel shareInstance]getUpdateInfo];

}
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
    self.userListView = [[UserListView alloc]initWithFrame:CGRectMake(0, 64, JFA_SCREEN_WIDTH, self.view.frame.size.height-64)];
    self.userListView.backgroundColor =RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .3);
    self.userListView.hidden = YES;
    self.userListView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.userListView];
    
}



-(void)buildTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, JFA_SCREEN_WIDTH, self.view.frame.size.height-64-49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self setRefrshWithTableView:self.tableView];
}
-(void)headerRereshing
{
    self.tableView.footerHidden =NO;
    page = 1;
    isrefresh = YES;
    [self getListInfo];
    [self getHeaderInfo];
}
-(void)footerRereshing
{
    isrefresh =NO;
    page++;
    [self getListInfo];
}

-(void)getHeaderInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kuHeaderserReviewUrl paramters:param success:^(NSDictionary *dic) {
        
        
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatData.do" paramters:param success:^(NSDictionary *dic) {
        if (isrefresh ==YES) {
            [listArr removeAllObjects];
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
        
        if (arr.count<30) {
            [self.tableView setFooterHidden:YES];
        }
        
            [self.tableView reloadData];
            

    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];

        if (error.code ==402) {
            if (isrefresh ==NO) {
                
            }else{
            [listArr removeAllObjects];
            [self.tableView setFooterHidden:YES];

            }
            [self.tableView reloadData];
        }

    }];
}
#pragma mark ---healthMainCelldelegate
/**
 * 上传数据
 */

-(void)updataInfoWithDict:(NSDictionary *)dic
{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setDictionary:dic];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    DLog(@"上传数据---%@",param);
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/addEvaluatData.do" paramters:param success:^(NSDictionary *dic) {
        
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        [self.tableView headerBeginRefreshing];
        
        TZdetaolViewController * tzDetai =[[TZdetaolViewController alloc]init];
        tzDetai.dataId = [[dic safeObjectForKey:@"data"] safeObjectForKey:@"DataId"];
        tzDetai.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:tzDetai animated:YES];
        
        
        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",dic);
        
    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:@"上传失败"];
        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",error);

    }];
}
-(void)didShare
{
    ShareViewController * ss =[[ShareViewController alloc]init];
    ss.hidesBottomBarWhenPushed=YES;
//    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:ss animated:YES];
}
-(void)enterDetailView
{
    if (!headerArr||headerArr.count<1) {
        return;
    }
    HealthItem * item = [headerArr objectAtIndex:0];

    TZdetaolViewController * tz =[[TZdetaolViewController alloc]init];
    tz.hidesBottomBarWhenPushed=YES;
//    self.navigationController.navigationBarHidden = NO;
    tz.dataId = [NSString stringWithFormat:@"%d",item.DataId];
    [self.navigationController pushViewController:tz animated:YES];
}
-(void)didEnterChart
{
    
    if (listArr.count<2) {
        [[UserModel shareInstance] showInfoWithStatus:@"数据过少，无法查看趋势"];
        return;
    }
    CharViewController * cr =[[CharViewController alloc]init];
//    self.navigationController.navigationBarHidden = NO;
    cr.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:cr animated:YES];
}
#pragma mark ---↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


-(void)refreshMyInfoView
{
    [_userView.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    _userView.nameLabel.text = [SubUserItem shareInstance].nickname;
}

-(void)refreshPcInfo
{
    [self.tableView headerBeginRefreshing];
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
        return 600;
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
            
            
        };
//        cell.backgroundColor = [UIColor clearColor];
        HealthItem * item = [listArr objectAtIndex:indexPath.row];
        [cell setUpCellWithItem:item];

        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.leftImage.image = [UIImage imageNamed:@"gray_cell"];
        }else{
            cell.contentView.backgroundColor = HEXCOLOR(0xeeeeee);
            cell.leftImage.image = [UIImage imageNamed:@"orange_cell"];

        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        return;
    }
    HealthItem * item = [listArr objectAtIndex:indexPath.row];
    TZdetaolViewController *tz = [[TZdetaolViewController alloc]init];
    tz.hidesBottomBarWhenPushed=YES;
//    self.navigationController.navigationBarHidden = NO;

    tz.dataId = [NSString stringWithFormat:@"%d",item.DataId];
    [self.navigationController pushViewController:tz animated:YES];
    
}

#pragma mark ---show subviewdelegate
-(void)showUserList
{
    if (self.userListView.hidden ==YES) {
        self.userListView.hidden = NO;
        [self.view bringSubviewToFront:self.userListView];
        [self.userListView refreshInfo];
    }else{
        self.userListView.hidden = YES;
    }

}
-(void)changeShowUserWithSubId:(NSString *)subId isAdd:(BOOL)isAdd
{
    if (isAdd) {
        ChangeUserInfoViewController * cu = [[ChangeUserInfoViewController alloc]init];
        cu.changeType = 3;
//        self.navigationController.navigationBarHidden = NO;
        cu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cu animated:YES];
    }else{
        
        if ([subId isEqualToString:[UserModel shareInstance].subId]) {
            [[SubUserItem shareInstance]setInfoWithHealthId:subId];
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
    
    [self getListInfo];
    [self getHeaderInfo];
    [_userView.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    _userView.nameLabel.text =[SubUserItem shareInstance].nickname;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didUpdateinfo
{
    
    [SVProgressHUD showWithStatus:@"请上秤。。"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    [[WWXBlueToothManager shareInstance]startScanWithStatus:^(NSString *statusString) {
        [SVProgressHUD showWithStatus:statusString];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    } success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[HealthModel shareInstance]setLogInUpLoadString:@"上传成功"];
        [[HealthModel shareInstance]UpdateBlueToothInfo];

        [self updataInfoWithDict:dic];
        
    } faile:^(NSError *error, NSString *errMsg) {
        [SVProgressHUD dismiss];
        [[WWXBlueToothManager shareInstance]stop];
        [[UserModel shareInstance] showErrorWithStatus:errMsg];
        [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"上传失败--error---%@",error]];

        [[HealthModel shareInstance]UpdateBlueToothInfo];
    }];

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
