
//
//  MessageViewController.m
//  zhijiangjun
//
//  Created by iOSdeveloper on 2017/6/10.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MessageViewController
{
    NSMutableArray * dataArray;
    UITableView * tb;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UserModel shareInstance]showInfoWithStatus:@"该功能暂未开放"];
    
    [tb headerBeginRefreshing];

    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    tb =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tb.delegate = self;
    tb.dataSource = self;
    [self.view addSubview:tb];
    [self setExtraCellLineHiddenWithTb:tb];
    [self setRefrshWithTableView:tb];
    [tb setFooterHidden:YES];
    dataArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
}
-(void)headerRereshing
{
    [self getInfo];
}
-(void) getInfo{
    [[BaseSservice sharedManager]post1:@"app/test/getMsg.do" paramters:nil success:^(NSDictionary *dic) {
        [tb headerEndRefreshing];
        dataArray =[[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"];
        [tb reloadData];
    } failure:^(NSError *error) {
        [tb headerEndRefreshing];
        [[UserModel shareInstance]showInfoWithStatus:@"没有新消息"];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
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
