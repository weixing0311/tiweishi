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
#import "EditUserInfoViewController.h"
#import "AddFriendsViewController.h"
#import "IntegralShopViewController.h"
#import "GrowthStstemViewController.h"
#import "GuanZViewController.h"
#import "NewMineHomePageViewController.h"
#import "IntegralOrderViewController.h"
#import "NewMineTableViewCell.h"
#import "CommunityViewController.h"
#import "Yd1View.h"
#import "Yd2View.h"
#import "Yd3View.h"
#import "Yd4View.h"
#import "Yd5View.h"
#import "Yd6View.h"

#import "VouchersGetViewController.h"
#import "MyVoucthersViewController.h"

@interface NewMineViewController ()<UITableViewDelegate,UITableViewDataSource,mineRelationsCellDelegate,mineRelationsCellDelegate>
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@end

@implementation NewMineViewController
{
    int notifacationCount;
#pragma mark ---guide
    Yd1View * yd1 ;
    Yd2View * yd2 ;
    Yd3View * yd3 ;
    Yd4View * yd4 ;
    Yd5View * yd5 ;
    Yd5View * yd6 ;

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
    
    [self buildGuidePage];
    _infoDict = [NSMutableDictionary dictionary];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorColor = HEXCOLOR(0xeeeeee);
    self.tableview.backgroundColor = HEXCOLOR(0xeeeeee);
    [self setExtraCellLineHiddenWithTb:self.tableview];
    // Do any additional setup after loading the view from its nib.
}

-(void)setNavi
{
    UIBarButtonItem * leftItem =[[UIBarButtonItem alloc]initWithTitle:@"添加关注" style:UIBarButtonItemStylePlain target:self action:@selector(addFriends)];

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
        return 10;
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
    return 7;
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
            else if(indexPath.row ==4){
                cell.titleLabel.text = @"我的订单";
                cell.headImageView.image = getImage(@"home_5_");
            }
            else if(indexPath.row ==5)
            {
                cell.titleLabel.text = @"我的优惠券";
                cell.headImageView.image = getImage(@"home_6_");

            }else{
                cell.titleLabel.text = @"领券中心";
                cell.headImageView.image = getImage(@"home_6_");

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
            page.hidesBottomBarWhenPushed=YES;
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
        else if (indexPath.row ==4)
        {
            DLog(@"购买记录");
            IntegralOrderViewController * ord = [[IntegralOrderViewController alloc]init];
            ord.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ord animated:YES];
        }
        else if(indexPath.row ==5)
        {
            MyVoucthersViewController * vo = [[MyVoucthersViewController alloc]init];
            vo.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vo animated:YES];
        }
        else
        {
            VouchersGetViewController * vo = [[VouchersGetViewController alloc]init];
            vo.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vo animated:YES];
        }
    }
}

-(void)didClickEidt
{
    EditUserInfoViewController * ne = [[EditUserInfoViewController alloc]init];
    ne.hidesBottomBarWhenPushed=YES;
    ne.infoDict = self.infoDict;
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"height"] forKey:@"heigth"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];

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

#pragma mark ---引导页
-(void)buildGuidePage
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kShowGuidePage2]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kShowGuidePage2];
    yd1 = [self getXibCellWithTitle:@"Yd1View"];
    yd2 = [self getXibCellWithTitle:@"Yd2View"];
    yd3 = [self getXibCellWithTitle:@"Yd3View"];
    yd4 = [self getXibCellWithTitle:@"Yd4View"];
    yd5 = [self getXibCellWithTitle:@"Yd5View"];
    yd6 = [self getXibCellWithTitle:@"Yd6View"];

    yd1.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    yd2.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    yd3.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    yd4.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    yd5.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    yd6.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);

    yd1.tag = 1;
    yd2.tag = 2;
    yd3.tag = 3;
    yd4.tag = 4;
    yd5.tag = 5;
    yd6.tag = 6;

    
    yd1.hidden = NO;
    yd2.hidden = YES;
    yd3.hidden = YES;
    yd4.hidden = YES;
    yd5.hidden = YES;
    yd6.hidden = YES;

    UIApplication *ap = [UIApplication sharedApplication];

    [ap.keyWindow addSubview:yd1];
    [ap.keyWindow addSubview:yd2];
    [ap.keyWindow addSubview:yd3];
    [ap.keyWindow addSubview:yd4];
    [ap.keyWindow addSubview:yd5];
    [ap.keyWindow addSubview:yd6];

    [yd1.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    [yd2.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    [yd3.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    [yd4.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    [yd5.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    [yd6.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
    
    [yd1.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
    [yd2.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
    [yd3.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
    [yd4.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
    [yd5.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
    [yd6.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];

    [yd1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
    [yd2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
    [yd3 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
    [yd4 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
    [yd5 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
    
}

-(void)showNextsView:(UIGestureRecognizer *)gest
{
    if (gest.view==yd1) {
        yd1.hidden = YES;
        yd2.hidden =NO;
    }
    else if(gest.view==yd2)
    {
        yd2.hidden = YES;
        yd3.hidden =NO;
    }
    else if(gest.view==yd3)
    {
        yd3.hidden = YES;
        yd4.hidden =NO;
    }
    else if(gest.view==yd4)
    {
        yd4.hidden = YES;
        yd5.hidden =NO;
    }
    else if(gest.view==yd5)
    {
        yd5.hidden = YES;
        yd6.hidden =NO;
    }
}



-(void)showNextView:(UIButton *)sender
{
    if (sender==yd1.nextBtn) {
        yd1.hidden = YES;
        yd2.hidden =NO;
    }
    else if(sender ==yd2.nextBtn)
    {
        yd2.hidden = YES;
        yd3.hidden =NO;
    }
    else if(sender ==yd3.nextBtn)
    {
        yd3.hidden = YES;
        yd4.hidden =NO;
    }
    else if(sender ==yd4.nextBtn)
    {
        yd4.hidden = YES;
        yd5.hidden =NO;
    }
    else if(sender ==yd5.nextBtn)
    {
        yd5.hidden = YES;
        yd6.hidden =NO;
    }

    else if(sender ==yd6.nextBtn)
    {
        yd6.hidden = YES;
        [yd1 removeFromSuperview];
        [yd2 removeFromSuperview];
        [yd3 removeFromSuperview];
        [yd4 removeFromSuperview];
        [yd5 removeFromSuperview];
        [yd6 removeFromSuperview];

    }
}
-(void)guideOver:(UIButton *)sender
{
    yd1.hidden = YES;
    yd2.hidden = YES;
    yd3.hidden = YES;
    yd4.hidden = YES;
    yd5.hidden = YES;
    yd6.hidden = YES;
    [yd1 removeFromSuperview];
    [yd2 removeFromSuperview];
    [yd3 removeFromSuperview];
    [yd4 removeFromSuperview];
    [yd5 removeFromSuperview];
    [yd6 removeFromSuperview];

}
@end
