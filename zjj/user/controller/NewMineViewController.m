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
@interface NewMineViewController ()<UITableViewDelegate,UITableViewDataSource,mineRelationsCellDelegate,mineRelationsCellDelegate>

@end

@implementation NewMineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self setTBRedColor];
    
    [self setNavi];
    
    
    
    
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 120;
    }else if (indexPath.row ==1)
    {
        return 60;
    }
    else
    {
        return 44;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        static NSString * identifier = @"NewMineHeaderCell";
        NewMineHeaderCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self  getXibCellWithTitle:identifier];
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl]];
        cell.nickNamelb.text  = [UserModel shareInstance].nickName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
    else if (indexPath.row ==1)
    {
        static NSString * identifier = @"NewMineRelationsCell";
        NewMineRelationsCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self  getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        return cell;

    }
    else
    {
        static NSString * identifier = @"PublicCell";
        PublicCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row==2) {
            cell.textLabel.text = @"成长体系";
            cell.headImageView.image = getImage(@"");
        }
        else if (indexPath.row==3) {
            cell.textLabel.text = @"积分商城";
            cell.headImageView.image = getImage(@"");
            
        }
        else {
            cell.textLabel.text = @"购买记录";
            cell.headImageView.image = getImage(@"");
            
        }

        
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0)
    {
        DLog(@"个人信息");
        NewMineHomePageViewController * mb= [[NewMineHomePageViewController alloc]init];
        mb.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mb animated:YES];

    }
    else if(indexPath.row==1)
    {
        
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


-(void)showzt
{
}
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
