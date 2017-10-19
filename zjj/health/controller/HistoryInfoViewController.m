//
//  HistoryInfoViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryInfoViewController.h"
#import "HistoryHeaderView.h"
#import "NSDate+CustomDate.h"
#import "Daysquare.h"
#import "ShareHealthItem.h"
#import "HistoryBigCell.h"
#import "NewHealthHistoryListViewController.h"
#import "HistoryCell.h"
@interface HistoryInfoViewController ()<UITableViewDelegate,UITableViewDataSource,historySectionCellDelegate,historyCellDelegate>
@property (nonatomic,strong) HistoryHeaderView * headerView;
@property (weak,  nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (nonatomic,strong)DAYCalendarView * calendarView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation HistoryInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setTBWhiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    _infoDict = [NSMutableDictionary dictionary];
    _dataArray = [NSMutableArray array];
    self.headerView =[self getXibCellWithTitle:@"HistoryHeaderView"];
    if (IS_IPHONE5) {
        self.headerView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH);
    }else{
        self.headerView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH*0.7);

    }
    self.tableview.tableHeaderView = self.headerView;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    [self.headerView.calendarView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];
    
    [self getInfoWithDate:[[NSDate date]yyyymmdd]];

    // Do any additional setup after loading the view from its nib.
}
- (void)calendarViewDidChange:(id)sender {
//    self.datePicker.date = self.calendarView.selectedDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSLog(@"%@", [formatter stringFromDate:self.headerView.calendarView.selectedDate]);
    
    [self getInfoWithDate:[self.headerView.calendarView.selectedDate yyyymmdd]];
}

-(void)getInfoWithDate:(NSString *)dateStr
{
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:dateStr forKey:@"nowDate"];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatOneDay.do" paramters:param success:^(NSDictionary *dic) {
        DLog(@"%@",dic);
        _infoDict = [dic safeObjectForKey:@"data"];
        _dataArray = [NSMutableArray arrayWithArray:[_infoDict safeObjectForKey:@"array"]];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"%@",error);
        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"请求超时"];
        }
    }];

    
    return;
    
    
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/queryUserHome.do" paramters:params success:^(NSDictionary *dic) {
        _infoDict = [dic safeObjectForKey:@"data"];
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic =[_dataArray objectAtIndex:indexPath.row];
    NSString *rowHeight = [dic safeObjectForKey:@"rowHeight"];
    if (rowHeight) {
        return  [rowHeight intValue];
    }else{
        return 100;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * identifier = @"HistoryBigCell";
//    HistoryBigCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [self getXibCellWithTitle:identifier];
//    }
//    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
//    cell.delegate = self;
//    [cell setInfoWithDict:dic];
    static NSString * identifier = @"HistoryCell";
    HistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setInfoWithDict:dic];

    return cell;
}


#pragma mark ---subView DELEGATE
-(void)showCellTabWithCell:(HistoryCell*)cell
{
    NSMutableDictionary * dic = [_dataArray objectAtIndex:cell.tag];
    if (!dic) {
        return;
    }
    if (cell.showBtn.selected ==YES) {
        cell.showBtn.selected = NO;
        [dic safeSetObject:@"100" forKey:@"rowHeight"];
        cell.infoView.hidden = YES;
        if ([[dic allKeys]containsObject:@"isSelected"]) {
            [dic removeObjectForKey:@"isSelected"];
        }
    }else{
        [dic safeSetObject:@"isSelected" forKey:@"isSelected"];
        [dic safeSetObject:@"700" forKey:@"rowHeight"];
        cell.infoView.hidden = NO;
        cell.showBtn.selected = YES;
    }
    [self.tableview reloadData];
}

- (IBAction)didEnterShareListView:(id)sender {
    NewHealthHistoryListViewController * nhl = [[NewHealthHistoryListViewController alloc]init];
    [self.navigationController pushViewController:nhl animated:YES];
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
