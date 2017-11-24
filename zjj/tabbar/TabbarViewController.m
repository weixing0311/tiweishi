//
//  TabbarViewController.m
//  zhijiangjun
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TabbarViewController.h"
//#import "HealthViewController.h"
#import "MessageViewController.h"
#import "foundViewController.h"
#import "ShopTabbbarController.h"
//#import "UserViewController.h"
#import "ShopTestViewController.h"
#import "TzsTabbarViewController.h"
#import "JzSchoolViewController.h"
#import "HomePageWebViewController.h"
#import "FriendsCircleViewController.h"
#import "AppDelegate.h"
#import "NewMineViewController.h"
#import "CommunityViewController.h"
#import "NewHealthViewController.h"
#import "IntegralSignInView.h"
@interface TabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabbarViewController
{
//    HealthViewController *health;
    NewHealthViewController *health;
    MessageViewController *news;
    foundViewController * found;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    health = [[NewHealthViewController alloc]init];

//    health = [[HealthViewController alloc]init];
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:health];
    health.title = @"健康";

    news = [[MessageViewController alloc]init];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:news];
    news.title = @"消息";

    
//    found = [[foundViewController alloc]init];
//    
    CommunityViewController *found = [[CommunityViewController alloc]init];
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:found];
    found.title = @"社区";

//    ShopTabbbarController *shop = [[ShopTabbbarController alloc]init];
//    shop.title = @"商城";
    
    
    
    
    ShopTestViewController *shop = [[ShopTestViewController alloc]init];
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:shop];

    shop.title = @"云服务";
    
    
    
    NewMineViewController * user = [[NewMineViewController alloc]init];
//    UserViewController *user = [[UserViewController alloc]init];
    UINavigationController * nav5 = [[UINavigationController alloc]initWithRootViewController:user];
    user.title = @"我的";

    self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
    
    
    UITabBarItem * item1 =[self.tabBar.items objectAtIndex:0];
    UITabBarItem * item2 =[self.tabBar.items objectAtIndex:1];
    UITabBarItem * item3 =[self.tabBar.items objectAtIndex:2];
    UITabBarItem * item4 =[self.tabBar.items objectAtIndex:3];
    UITabBarItem * item5 =[self.tabBar.items lastObject];

    item1.image = [UIImage imageNamed:@"health  gray_"];
    item1.selectedImage = [UIImage imageNamed:@"health_"];
    
    item2.image = [UIImage imageNamed:@"discuss  gray_"];
    item2.selectedImage = [UIImage imageNamed:@"discuss_"];
    
    item3.image = [UIImage imageNamed:@"tab_comm_"];
//    item3.selectedImage = [UIImage imageNamed:@"tab_comm1_"];

    item4.image = [UIImage imageNamed:@"store gray_"];
    item4.selectedImage = [UIImage imageNamed:@"store_"];

    item5.image = [UIImage imageNamed:@"mine  gray_"];
    item5.selectedImage = [UIImage imageNamed:@"mine_"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = HEXCOLOR(0xfb0628);
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickNotification:) name:@"GETNOTIFICATIONINFOS" object:nil];
    
    [self getIntegralInfo];
}

///获取积分信息---拿出来是否签到参数 循环ing
-(void)getIntegralInfo
{
    if ([[UserModel shareInstance]getSignInNotifacationStatus]==NO) {
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryAll.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        NSMutableDictionary * infoDict = [dic objectForKey:@"data"];
        NSArray * qdArr = [infoDict safeObjectForKey:@"taskArry"];
        NSDictionary * signInDict = [NSDictionary dictionary];
        for (NSDictionary *QDdict in qdArr) {
            NSString * taskName = [QDdict safeObjectForKey:@"taskName"];
            if ([taskName isEqualToString:@"签到"]) {
                signInDict = QDdict;
            }
        }
        //如果签到成功 直接过 滚蛋ing---否则弹出签到框
        if ([[signInDict allKeys]containsObject:@"success"]) {
            return ;
        }
        [self showSignInView];
    } failure:^(NSError *error) {
        
    }];
}
///显示弹框 然后请求接口
-(void)showSignInView
{
    IntegralSignInView  * signView = [[[NSBundle mainBundle]loadNibNamed:@"IntegralSignInView" owner:nil options:nil]lastObject];
    signView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:signView];

}

-(void)didClickNotification:(NSNotification *)noti
{
    //判断是不是mainview
    if (![(AppDelegate *)[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[self class]]) {
        return;
    }
    NSDictionary * dic=noti.userInfo;
    int type =[[dic safeObjectForKey:@"type"]intValue];
    NSString * url = [dic safeObjectForKey:@"url"];
    
    if (type ==1) {
        self.selectedIndex = 1;
        HomePageWebViewController * web= [[HomePageWebViewController alloc]init];
        web.urlStr = url;
        web.title = @"消息详情";
        web.hidesBottomBarWhenPushed = YES;
        [news.navigationController pushViewController:web animated:YES];
    }
    else if (type ==2)
    {
        self.selectedIndex =2;
        FriendsCircleViewController * fr = [[FriendsCircleViewController alloc]init];
        fr.hidesBottomBarWhenPushed = YES;
        [found.navigationController pushViewController:fr animated:YES];
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UITabBarItem* item = tabBarController.tabBarItem;
    
    if (viewController ==self.viewControllers[2]||viewController ==self.viewControllers[4]) {
        if (![[UserModel shareInstance].subId isEqualToString:[UserModel shareInstance].healthId]) {
            [[UserModel shareInstance]showInfoWithStatus:@"请切换成主用户再来使用此功能"];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;

}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"item name = %@", item.title);
    
    if ([item.title isEqualToString:@"云服务"]) {
        
        if ([[UserModel shareInstance].userType isEqualToString:@"1"]) {
            ShopTabbbarController *tb =[[ShopTabbbarController alloc]init];
            [UserModel shareInstance].tabbarStyle = @"shop";

            self.view.window.rootViewController = tb;
        }
        else{
            TzsTabbarViewController *tb =[[TzsTabbarViewController alloc]init];
            [UserModel shareInstance].tabbarStyle = @"tzs";
            self.view.window.rootViewController = tb;
        }
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
