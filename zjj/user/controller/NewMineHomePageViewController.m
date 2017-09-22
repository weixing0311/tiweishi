//
//  NewMineHomePageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineHomePageViewController.h"
#import "PublicArticleCell.h"
#import "NewMineHomePageCell.h"
@interface NewMineHomePageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation NewMineHomePageViewController
{
    int page;
    int pageSize;
    NSInteger lastClickImageCell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate=self;
    self.tableview.dataSource= self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
}
-(void)getinfo
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/queryShareMsgList.do" paramters:params success:^(NSDictionary *dic) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
        if (page ==1) {
//            [self.dataArray removeAllObjects];
//            [self.tableview setFooterHidden:NO];
            
        }
        
        
        
        
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        for (NSMutableDictionary * infoDic in infoArr) {
//            LoadedImageModel * item = [[LoadedImageModel alloc]init];
//            [item setInfoWithDict:infoDic];
//            [self.dataArray addObject:item];
            
        }
        [self.tableview reloadData];
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 250;
    }else
    {
        return 250;
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"NewMineHomePageCell";
    NewMineHomePageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:getImage(@"")];
        cell.nicknamelb.text = [UserModel shareInstance].nickName;
        cell.jjlb.text = @"简介：凤兮凤兮求其凰~";
        int  sex = [UserModel shareInstance].gender;
        if (sex ==1) {
            cell.sexImageView.image = getImage(@"man");

        }else{
            cell.sexImageView.image =getImage(@"women_");
        }
        return cell;
    }
    else
    {
    static NSString * identifier = @"PublicArticleCell";
    PublicArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
        return cell;
        
    }
}
- (IBAction)didClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didClickShare:(id)sender {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
