//
//  NewMineViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineViewController.h"
#import "NewMineHeaderCell.h"
#import "NewMineRelationsCell.h"
#import "PublicCell.h"
#import "NewMineEditViewController.h"
#import "AddFriendsViewController.h"
#import "IntegralShopViewController.h"
#import "GrowthStstemViewController.h"
#import "GuanZViewController.h"
#import "NewMineHomePageViewController.h"
#import "IntegralOrderViewController.h"
#import "NewMineTableViewCell.h"
#import "CommunityViewController.h"
@interface NewMineViewController ()<UITableViewDelegate,UITableViewDataSource,mineRelationsCellDelegate,mineRelationsCellDelegate>
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@end

@implementation NewMineViewController
{
    int notifacationCount;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self setTBWhiteColor];
    [self getUserInfo];
    [self getMyMessageCountInfo];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
;
    
    [self setNavi];
    
    _infoDict = [NSMutableDictionary dictionary];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    // Do any additional setup after loading the view from its nib.
}

-(void)setNavi
{
    UIBarButtonItem * leftItem =[[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriends)];

    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings_"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickEidt)];

    self.navigationItem.rightBarButtonItem = rightItem;
        

}

-(void)getUserInfo
{
//    app/user/getUserHome.do
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/getUserHome.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        _infoDict = [dic safeObjectForKey:@"data"];
        [self.tableview reloadData];
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
    }];
    

}
-(void)getMyMessageCountInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/queryMsgDynamic.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        NSString * dynamicTimes = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"dynamicTimes"];
        notifacationCount = [dynamicTimes intValue];
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
        if (indexPath.row ==0) {
            return 80;
        }
        return 60;
    }else{
        return 50;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 15;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 2;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row ==0)
        {
            static NSString * identifier = @"NewMineHeaderCell";
            NewMineHeaderCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self  getXibCellWithTitle:identifier];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]]placeholderImage:getImage(@"defaultHead")];
            cell.nickNamelb.text  = [_infoDict safeObjectForKey:@"nickName"];
            NSString * introduction = [_infoDict safeObjectForKey:@"introduction"];
            if (introduction.length<1) {
                cell.secondlb.text = @"您还没有编辑简介~";
            }else{
                cell.secondlb.text = [NSString stringWithFormat:@"简介：%@",introduction];
            }
            return cell;
        }
        else
        {
            static NSString * identifier = @"NewMineRelationsCell";
            NewMineRelationsCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self  getXibCellWithTitle:identifier];
            }
            cell.delegate = self;
            cell.value2lb.text = [_infoDict safeObjectForKey:@"followNum"];
            cell.value3lb.text = [_infoDict safeObjectForKey:@"fansNum"];
            return cell;
        }
    }else{

            static NSString * identifier = @"NewMineTableViewCell";
            NewMineTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (indexPath.row ==0) {
                cell.titleLabel.text = @"个人主页";
                cell.headImageView.image = getImage(@"home_1_");
            }
            else if(indexPath.row ==1)
            {
                cell.titleLabel.text = @"我的消息";
                cell.headImageView.image = getImage(@"home_2_");
                if (notifacationCount==0||!notifacationCount) {
                    cell.notifationCountLb.hidden = YES;
                }else{
                    cell.notifationCountLb.hidden = NO;
                }
                cell.notifationCountLb.text =[NSString stringWithFormat:@"%d",notifacationCount];

            }
            else if (indexPath.row==2) {
                cell.titleLabel.text = @"成长体系";
                cell.headImageView.image = getImage(@"home_3_");
            }
            else if (indexPath.row==3) {
                cell.titleLabel.text = @"积分商城";
                cell.headImageView.image = getImage(@"home_4_");
            }
            else {
                cell.titleLabel.text = @"我的订单";
                cell.headImageView.image = getImage(@"home_5_");
            }
            return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            DLog(@"个人信息");
            NewMineHomePageViewController * mb= [[NewMineHomePageViewController alloc]init];
            mb.hidesBottomBarWhenPushed=YES;
            mb.userId = [UserModel shareInstance].userId;
            [self.navigationController pushViewController:mb animated:YES];

        }
    }else{
         if(indexPath.row ==0)
        {
            NewMineHomePageViewController * page = [[NewMineHomePageViewController alloc]init];
            page.userId = [UserModel shareInstance].userId;
            [self.navigationController pushViewController:page animated:YES];

        }
        else if(indexPath.row ==1)
        {
            CommunityViewController * comm = [[CommunityViewController alloc]init];
            comm.isMyMessagePage =YES;
            [self.navigationController pushViewController:comm animated:YES];
        }
        else if(indexPath.row==2)
        {
            DLog(@"成长体系");
            
            GrowthStstemViewController * gs = [[GrowthStstemViewController alloc]init];
            gs.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:gs animated:YES];

        }
        else if(indexPath.row==3)
        {
            DLog(@"积分商城");
            
            IntegralShopViewController * its = [[IntegralShopViewController alloc]init];
            its.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:its animated:YES];

        }
        else
        {
            DLog(@"购买记录");
            IntegralOrderViewController * ord = [[IntegralOrderViewController alloc]init];
            ord.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ord animated:YES];
        }

    }

}

-(void)didClickEidt
{
    NewMineEditViewController * ne = [[NewMineEditViewController alloc]init];
    ne.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:ne animated:YES];
}
-(void)addFriends
{
    AddFriendsViewController * addf = [[AddFriendsViewController alloc]init];
    addf.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:addf animated:YES];
}

#pragma mark ----delegate


-(void)showGZ
{
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"关注";
    gz.pageType = IS_GZ;
    gz.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:gz animated:YES];
}
-(void)showFuns
{
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"粉丝";
    gz.pageType = IS_FUNS;
    gz.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:gz animated:YES];

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
