//
//  HistoryTotalViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/1.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryTotalViewController.h"
#import "HistoryInfoViewController.h"
#import "NewHealthHistoryListViewController.h"
@interface HistoryTotalViewController ()<UIScrollViewDelegate>

@end

@implementation HistoryTotalViewController
{
    NewHealthHistoryListViewController * newHealthHistoryListVC;
    HistoryInfoViewController * HistoryRlVC;
    UIScrollView * bbScr;
    UIButton * btn1;
    UIButton * btn2;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setTBWhiteColor];
    self.title = @"体脂趋势";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithImage:getImage(@"share_") style:UIBarButtonItemStylePlain target:self action:@selector(didClickShare)];
    
    UIBarButtonItem * rightitem  = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(didClickShare)];
    
    self.navigationItem.rightBarButtonItem = rightitem;

    
    bbScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.view.frame.size.height -55)];
    bbScr.pagingEnabled = YES;
    bbScr.delegate = self;
    bbScr.scrollEnabled = NO;
    bbScr .contentSize = CGSizeMake(JFA_SCREEN_WIDTH *2, 0);
    [self.view addSubview:bbScr];
    
    

    newHealthHistoryListVC = [[NewHealthHistoryListViewController alloc] init];
    [self addChildViewController:newHealthHistoryListVC];
    [newHealthHistoryListVC didMoveToParentViewController:self];
    newHealthHistoryListVC.view.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, bbScr.frame.size.height);
    newHealthHistoryListVC.tableview.frame =CGRectMake(0, 134, JFA_SCREEN_WIDTH, bbScr.frame.size.height-134);
    [bbScr addSubview:newHealthHistoryListVC.view];

    
    
    // Do any additional setup after loading the view.
    
    HistoryRlVC = [[HistoryInfoViewController alloc] init];
    [self addChildViewController:HistoryRlVC];
    [HistoryRlVC didMoveToParentViewController:self];
    HistoryRlVC.view.frame = CGRectMake(JFA_SCREEN_WIDTH, 0, JFA_SCREEN_WIDTH, bbScr.frame.size.height);

    [bbScr addSubview:HistoryRlVC.view];

    


    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-51, JFA_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:lineView];
    btn1 = [UIButton new];
    btn2 = [UIButton new];
    btn1.backgroundColor = [UIColor orangeColor];
    
    [btn1 addTarget:self action:@selector(change1:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"列表模式" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    btn1.selected = YES;
    btn1.tag = 1;
    [self.view addSubview:btn1];
    
    [btn2 addTarget:self action:@selector(change2:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"日历模式" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn2 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    btn2.tag =2;
    btn2.backgroundColor = [UIColor whiteColor];
    
    
    btn1.frame = CGRectMake(0, self.view.frame.size.height-50, JFA_SCREEN_WIDTH/2, 50);
  btn2.frame = CGRectMake(JFA_SCREEN_WIDTH/2, self.view.frame.size.height-50, JFA_SCREEN_WIDTH/2, 50);

    
}
-(void)didClickShare
{
    
    [newHealthHistoryListVC enterRightPage];
}
-(void)change1:(UIButton *)sender
{
    if (btn1.selected==YES) {
        return;
    }
    btn1.selected = YES;
    btn1.backgroundColor = [UIColor orangeColor];
    btn2.selected =NO;
    btn2.backgroundColor =[UIColor whiteColor];
    
    bbScr.contentOffset = CGPointMake(0, 0);
    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(didClickShare)];
    self.navigationItem.rightBarButtonItem = rightitem;

}
-(void)change2:(UIButton *)sender
{
    if (btn2.selected==YES) {
        return;
    }

    btn2.selected = YES;
    btn2.backgroundColor = [UIColor orangeColor];
    btn1.selected =NO;
    btn1.backgroundColor =[UIColor whiteColor];
    
    bbScr.contentOffset = CGPointMake(JFA_SCREEN_WIDTH, 0);
   self.navigationItem.rightBarButtonItem = nil;
}


- (void)changeControllerFromOldController:(UIViewController *)oldController toNewController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    /**
     *  切换ViewController
     */
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        //做一些动画
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            //移除oldController，但在removeFromParentViewController：方法前不会调用willMoveToParentViewController:nil 方法，所以需要显示调用
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
//            currentVC = newController;
            
        }else
        {
//            currentVC = oldController;
        }
        
    }];
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
