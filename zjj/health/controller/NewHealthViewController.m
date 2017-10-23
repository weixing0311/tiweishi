//
//  NewHealthViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthViewController.h"
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
#import "ADDChengUserViewController.h"
#import "UserDirectionsViewController.h"
#import "HistoryInfoViewController.h"
#import "HealthDetailViewController.h"
#import "WeighingViewController.h"
@interface NewHealthViewController ()<userListDelegate,userViewDelegate,healthMainDelegate,weightingDelegate>
@property (nonatomic,strong)UIView * userBackView;
@property (nonatomic,strong)UserListView * userListView;
@property (weak, nonatomic) IBOutlet UIButton *userHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *resignTimelb;
@property (weak, nonatomic) IBOutlet UILabel *redFatlb;
@property (weak, nonatomic) IBOutlet UILabel *fatStatuslb;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;
@property (weak, nonatomic) IBOutlet UILabel *lessWeightLb;
@property (weak, nonatomic) IBOutlet UIImageView *trendArrowImageView;
@property (weak, nonatomic) IBOutlet UIView *minView;





@end

@implementation NewHealthViewController
{
        NSMutableArray * headerArr;
        UserView *_userView;
        BOOL isrefresh;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self refreshMyInfoView];
    
    [_userView.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    _userView.nameLabel.text = [SubUserItem shareInstance].nickname;
    [self buildUserListView];
    [[UserModel shareInstance]getbalance];
    
    [[UserModel shareInstance]getUpdateInfo];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerArr = [NSMutableArray array];
    [self setJpush];
    self.minView.layer.borderWidth= 2;
    self.minView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;

    //删除评测数据返回后刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPcInfo) name:@"deletePCINFO" object:nil];
    [self getHeaderInfo];
    // Do any additional setup after loading the view from its nib.
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
    
    [self.view addSubview:self.userListView];
    
}
-(void)weightingSuccess
{
    [self getHeaderInfo];
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
        [self refreshPageInfoWithItem:item];
        
        
    } failure:^(NSError *error) {
        if (error.code ==402) {
            [headerArr removeAllObjects];
            [self refreshPageInfoWithItem:nil];

        }
        
        
    }];
}
-(void)refreshPageInfoWithItem:(HealthItem*)item
{
    
    if (item==nil) {
        self.weightlb.text = @"0.0kg";
        self.lessWeightLb.text = @"-";
        self.trendArrowImageView.hidden = YES;
        self.fatStatuslb.text = @"";
        self.resignTimelb.text = @"";
        self.redFatlb.text = @"";

    }
    self.resignTimelb.text = [NSString stringWithFormat:@"已使用脂将军%d天",item.userDays];
    self.redFatlb.text = [NSString stringWithFormat:@"已减脂%.1fkg",item.subtractWeight];
    [self.userHeaderView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
    
    self.weightlb.text = [NSString stringWithFormat:@"%.1f",item.weight];
    
    if (item.weight) {
        float weightChange = item.weight - item.lastWeight;
        DLog(@"%f--%f",item.weight,item.lastWeight);
        self.lessWeightLb.text = [NSString stringWithFormat:@"%.1fkg",fabsf(weightChange)];
        self.trendArrowImageView.image =[UIImage imageNamed:weightChange>0?@"trand_up_icon":@"trand_down_icon"];
        self.trendArrowImageView.hidden = NO;
    }
    else {
        self.trendArrowImageView.hidden = YES;
        self.lessWeightLb.text = @"-";
    }
    switch (item.weightLevel) {
        case 1:
            self.fatStatuslb.text = [NSString stringWithFormat:@"偏瘦"];
//            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 2:
            self.fatStatuslb.text = [NSString stringWithFormat:@"正常"];
//            self.fatStatuslb.textColor = HEXCOLOR(0x41bf7c);
            break;
        case 3:
            self.fatStatuslb.text = [NSString stringWithFormat:@"轻度肥胖"];
//            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 4:
            self.fatStatuslb.text = [NSString stringWithFormat:@"中度肥胖"];
//            self.fatStatuslb.textColor = HEXCOLOR(0xf4a519);
            break;
        case 5:
            self.fatStatuslb.text = [NSString stringWithFormat:@"重度肥胖"];
//            self.fatStatuslb.textColor = HEXCOLOR(0xe84849);
            break;
        case 6:
            self.fatStatuslb.text = [NSString stringWithFormat:@"极度肥胖"];
//            self.fatStatuslb.textColor = HEXCOLOR(0xe84849);
            break;
            
        default:
            break;
    }

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
    [self getHeaderInfo];
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
        
        ADDChengUserViewController * addc = [[ADDChengUserViewController alloc]init];
        addc.isResignUser = NO;
        addc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:addc animated:YES];
        
        //        ChangeUserInfoViewController * cu = [[ChangeUserInfoViewController alloc]init];
        //        cu.changeType = 3;
        ////        self.navigationController.navigationBarHidden = NO;
        //        cu.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:cu animated:YES];
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
    [_userView.headImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    _userView.nameLabel.text =[SubUserItem shareInstance].nickname;
    
}


- (IBAction)didClickPC:(id)sender {
    WeighingViewController * we = [[WeighingViewController alloc]init];
    we.delegate = self;
    [self presentViewController:we animated:YES completion:nil];
}
- (IBAction)didClickEnterDetail:(id)sender {
    if (!headerArr|| headerArr.count<1) {
        return;
    }
    HealthItem * item = [headerArr objectAtIndex:0];
    HealthDetailViewController * hd =[[HealthDetailViewController alloc]init];
    hd.hidesBottomBarWhenPushed=YES;
    hd.dataId =[NSString stringWithFormat:@"%d",item.DataId];

    [self.navigationController pushViewController:hd animated:YES];
    
    
    
}
- (IBAction)didClickShowhistoryInfo:(id)sender {
    

    HistoryInfoViewController * hist = [[HistoryInfoViewController alloc]init];
    hist.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: hist animated:YES];
}

- (IBAction)didEnterUserDirections:(id)sender {
    UserDirectionsViewController * dis = [[UserDirectionsViewController alloc]init];
    dis.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dis animated:YES];
}

- (IBAction)showUserList:(id)sender {
    if (self.userListView.hidden ==YES) {
        self.userListView.hidden = NO;
        [self.view bringSubviewToFront:self.userListView];
        [self.userListView refreshInfo];
    }else{
        self.userListView.hidden = YES;
    }

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
