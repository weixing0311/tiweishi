//
//  ShopViewController.m
//  zhijiangjun
//
//  Created by iOSdeveloper on 2017/6/10.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "foundViewController.h"
#import "JzSchoolViewController.h"
#import "FriendsCircleViewController.h"
#import "ADCarouselView.h"

@interface foundViewController ()<ADCarouselViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@end

@implementation foundViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
//    [self buildBannerView];
    // Do any additional setup after loading the view.{
}
-(void)buildBannerView
{
    ADCarouselView *carouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.bannerView.frame.size.height)];
    carouselView.loop = YES;
    carouselView.delegate = self;
    carouselView.automaticallyScrollDuration = 5;
    carouselView.imgs = @[@"message_banner1.jpg",@"message_banner2.jpg",@"message_banner3.jpg"];
    carouselView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
    
    [self.bannerView addSubview:carouselView];
}
- (IBAction)didClickPush:(UIButton *)sender {
    
    
    if (sender.tag ==1) {//文章推广
        JzSchoolViewController * jzs = [[JzSchoolViewController alloc]init];
        jzs.hidesBottomBarWhenPushed = YES;
        jzs.title = @"文章推广";
        [self.navigationController pushViewController:jzs animated:YES];
    }
    else if (sender.tag ==2)//口碑推广
    {
        FriendsCircleViewController * fc =[[FriendsCircleViewController alloc]init];
        fc.hidesBottomBarWhenPushed = YES;
        fc.title = @"朋友圈推广";
        [self.navigationController pushViewController:fc animated:YES];

    }
    else if (sender.tag ==3)//朋友圈推广
    {
        FriendsCircleViewController * fc =[[FriendsCircleViewController alloc]init];
        fc.hidesBottomBarWhenPushed = YES;
        fc.title = @"朋友圈推广";
        [self.navigationController pushViewController:fc animated:YES];
    }
    else if (sender.tag ==4)//视频推广
    {
        
    }
    else if (sender.tag ==5)//图片推广
    {
        
    }
    else{//线下推广
        
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
