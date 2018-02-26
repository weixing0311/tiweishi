//
//  TZSHomePageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/1/22.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSHomePageViewController.h"
#import "ADCarouselView.h"
#import "TZSHomePageCell.h"
#import "JzSchoolViewController.h"
#import "FriendsCircleViewController.h"
#import "HomePageWebViewController.h"
@interface TZSHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,ADCarouselViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * bannerArray;

@end

@implementation TZSHomePageViewController
{
    ADCarouselView *carouselView;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    [self setStatusBarBackgroundColor:RGBACOLOR(0, 0, 0, 0.6)];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray =[NSMutableArray array];
    self.bannerArray =[NSMutableArray array];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT+20) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHiddenWithTb:self.tableView];
    self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self getInfo];
    // Do any additional setup after loading the view.
}
-(void)headerRereshing
{
    [self getInfo];
}

-(void)buildBannerView
{
    
    NSMutableArray * imgArr =[NSMutableArray array];
    for (int i=0; i<self.bannerArray.count; i++) {
        NSDictionary * imgDic = [self.bannerArray objectAtIndex:i];
        NSString * img =[imgDic safeObjectForKey:@"carouselPath"];
        [imgArr addObject:img];
    }
    
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2.2+99+JFA_SCREEN_WIDTH/4.7+10)];
    
    carouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2.2)];
    carouselView.loop = YES;
    
    carouselView.delegate = self;
    carouselView.backgroundColor = HEXCOLOR(0xeeeeee);
    carouselView.automaticallyScrollDuration = 5;
    carouselView.placeholderImage = getImage(@"bigDefault");
    carouselView.imgs = imgArr;
    [headView addSubview:carouselView];
    
    
    UIView * btnView =[[UIView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2, JFA_SCREEN_WIDTH, 88)];
    btnView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:btnView];
    
    
    UIButton * leftBtn =[[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4-20, 12, 45, 45)];
    [leftBtn setImage:getImage(@"home_left") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(enterWz:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:leftBtn];
    
    UILabel * leftlb =[[UILabel alloc]initWithFrame:CGRectMake(0,62, JFA_SCREEN_WIDTH/2, 15)];
    leftlb.text = @"文章推广";
    leftlb.textAlignment = NSTextAlignmentCenter;
    leftlb.font =[UIFont systemFontOfSize:12];
    leftlb.textColor =HEXCOLOR(0x666666);
    [btnView addSubview:leftlb];
    

    UIButton * rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4*3-20, 12, 45, 45)];
    [rightBtn setImage:getImage(@"home_right") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(enterpyq:) forControlEvents:UIControlEventTouchUpInside];

    [btnView addSubview:rightBtn];
    
    UILabel * rightlb =[[UILabel alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/2, 62, JFA_SCREEN_WIDTH/2, 15)];
    rightlb.text = @"朋友圈推广";
    rightlb.textAlignment = NSTextAlignmentCenter;
    rightlb.font =[UIFont systemFontOfSize:12];
    rightlb.textColor =HEXCOLOR(0x666666);
    [btnView addSubview:rightlb];
    
    
//    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2+99, JFA_SCREEN_WIDTH, 1)];
//    lineView.backgroundColor = HEXCOLOR(0xeeeeee);
//    [headView addSubview:lineView];
    self.tableView.tableHeaderView = headView;
    
    
    UIView * line1View =[[UIView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2+87, JFA_SCREEN_WIDTH, 5)];
    line1View.backgroundColor =HEXCOLOR(0xeeeeee);
    [headView addSubview:line1View];
    
    
    UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2+92, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/4.7)];
    imageView.image = getImage(@"home_center");
    [headView addSubview:imageView];
    
    UIView * line2View =[[UIView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2+JFA_SCREEN_WIDTH/2.35+5, JFA_SCREEN_WIDTH, 5)];
    line2View.backgroundColor =HEXCOLOR(0xeeeeee);
//    [headView addSubview:line2View];

    
}

-(void)getInfo
{
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/home/query.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        
        self.dataArray = [dataDic safeObjectForKey:@"healthArray"];
         self.bannerArray =[dataDic safeObjectForKey:@"carouselArray"];
        [self buildBannerView];
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
-(void)enterWz:(id)sender
{
    JzSchoolViewController * jzs = [[JzSchoolViewController alloc]init];
    jzs.hidesBottomBarWhenPushed = YES;
    jzs.title = @"文章推广";
    [self.navigationController pushViewController:jzs animated:YES];

}
-(void)enterpyq:(id)sender
{
    FriendsCircleViewController * fc =[[FriendsCircleViewController alloc]init];
    fc.hidesBottomBarWhenPushed = YES;
    fc.title = @"朋友圈推广";
    [self.navigationController pushViewController:fc animated:YES];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (JFA_SCREEN_WIDTH-20)/2.8+45;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"TZSHomePageCell";
    
    TZSHomePageCell * cell  =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
     NSDictionary * dict =[_dataArray objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.titlelb.text =[dict safeObjectForKey:@"title"];
    [cell.headImageView sd_setImageWithURL:[dict safeObjectForKey:@"picPath"] placeholderImage:getImage(@"bigDefault")];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict  =[_dataArray objectAtIndex:indexPath.row];
    NSString * linkUrl = [dict safeObjectForKey:@"linkUrl"];
    
    HomePageWebViewController * web =[[HomePageWebViewController alloc]init];
    web.hidesBottomBarWhenPushed =YES;
    web.urlStr = linkUrl;
    web.title = [dict safeObjectForKey:@"title"];

    [self.navigationController pushViewController:web animated:YES];

}
- (void)carouselView:(ADCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)didSelectItemAtIndex
{
    
    DLog(@"点击的tag--%ld",(long)didSelectItemAtIndex);
    
    NSDictionary * dic =[_bannerArray objectAtIndex:didSelectItemAtIndex-1];
    NSString * linkUrl = [dic safeObjectForKey:@"linkUrl"];
    
    HomePageWebViewController * web =[[HomePageWebViewController alloc]init];
    web.hidesBottomBarWhenPushed =YES;
    web.urlStr = linkUrl;
    web.title = [dic safeObjectForKey:@"title"];
    [self.navigationController pushViewController:web animated:YES];
    
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
