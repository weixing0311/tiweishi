//
//  CommunityViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommunityViewController.h"
#import "PublicArticleCell.h"
#import "LoadedImageModel.h"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation CommunityViewController
{
    int page;
    int pageSize;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    pageSize= 30;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    [self.tableview headerBeginRefreshing];
}



-(void)headerRereshing
{
    page =1;
    [self getinfo];
}
-(void)footerRereshing
{
    page++;
    [self getinfo];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (IBAction)didEdit:(id)sender {
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
            [self.dataArray removeAllObjects];
            [self.tableview setFooterHidden:NO];
            
        }
                
        
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        for (NSMutableDictionary * infoDic in infoArr) {
            LoadedImageModel * item = [[LoadedImageModel alloc]init];
            [item setInfoWithDict:infoDic];
            [self.dataArray addObject:item];
            
        }
        [self.tableview reloadData];
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
    }];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadedImageModel * item =[self.dataArray objectAtIndex:indexPath.row];
    float rowheight = item.rowHieght;
    return rowheight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString * identifier = @"PublicArticleCell";
    PublicArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    LoadedImageModel * item =[self.dataArray objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    [cell setInfoWithDict:item];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
