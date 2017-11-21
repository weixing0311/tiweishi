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
//#import "HistoryBigCell.h"
#import "NewHealthHistoryListViewController.h"
#import "HistoryCell.h"
#import "SZCalendarPicker.h"

@interface HistoryInfoViewController ()<UITableViewDelegate,UITableViewDataSource,historyCellDelegate>
@property (nonatomic,strong) HistoryHeaderView * headerView;
@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (nonatomic,strong)DAYCalendarView * calendarView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)SZCalendarPicker *calendarPicker;

@end

@implementation HistoryInfoViewController
{
    NSInteger showIndexPathRow;
    
}
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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, JFA_SCREEN_WIDTH, self.view.frame.size.height-120) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    _infoDict = [NSMutableDictionary dictionary];
    _dataArray = [NSMutableArray array];
//    self.headerView =[self getXibCellWithTitle:@"HistoryHeaderView"];
//    if (IS_IPHONE5) {
//        self.headerView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 352);
//    }else{
//        self.headerView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 352);
//    }
    
    
    
//    self.tableview.tableHeaderView = self.headerView;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    __weak HistoryInfoViewController * weakSelf = self;
    self.calendarPicker = [[[NSBundle mainBundle] loadNibNamed:@"SZCalendarPicker" owner:nil options:nil] lastObject];
    
    int width =(JFA_SCREEN_WIDTH-20);
    int yu = width%7;
    self.calendarPicker.frame = CGRectMake(0, 0,JFA_SCREEN_WIDTH-20-yu, 352);
    self.tableview.tableHeaderView =self.calendarPicker;
    self.calendarPicker.today = [NSDate date];
    self.calendarPicker.date = self.calendarPicker.today;
    self.calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){

        
        NSString * dateStr = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld",(long)year,month<10?@"0":@"",(long)month,day<10?@"0":@"",(long)day];
        [weakSelf getInfoWithDate:dateStr];
    };

//    [self.headerView.calendarView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];
    
    [self getInfoWithDate:[[NSDate date]yyyymmdd]];

    // Do any additional setup after loading the view from its nib.
}

-(void)getInfoWithDate:(NSString *)dateStr
{
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:dateStr forKey:@"nowDate"];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatOneDay.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"%@",dic);
        _infoDict = [dic safeObjectForKey:@"data"];
        _dataArray = [NSMutableArray arrayWithArray:[_infoDict safeObjectForKey:@"array"]];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"%@",error);
        if (error.code ==402) {
            [_dataArray removeAllObjects];
            [self.tableview reloadData];
        }
    }];

    
    return;
    
    
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/queryUserHome.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        _infoDict = [dic safeObjectForKey:@"data"];
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==showIndexPathRow) {
        return 626;
    }
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"HistoryCell";
    HistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    if (showIndexPathRow==indexPath.row) {
        [cell setInfoWithDict:dic isHidden:NO];
    }else{
        [cell setInfoWithDict:dic isHidden:YES];
    }
    cell.chooseBtn.hidden = YES;
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    if (indexPath.row ==showIndexPathRow) {
        showIndexPathRow =100000000000;
    }else{
        showIndexPathRow=indexPath.row;
    }
    [self.tableview reloadData];

}
-(void)didDeleteWithCell:(HistoryCell*)cell
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认要删除本条记录？" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction: [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * dict = [_dataArray objectAtIndex:cell.tag];
        [self deleteListWithDict:dict IndexPath:cell.tag];
        
    }]];
    [al addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];
}
///删除
-(void)deleteListWithDict:(NSDictionary *)dict IndexPath:(NSInteger )index
{
    [SVProgressHUD showWithStatus:@"删除中.."];
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:[dict safeObjectForKey:@"DataId"] forKey:@"dataId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/deleteEvaluatData.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"删除成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deletePCINFO" object:nil];
        [_dataArray removeObjectAtIndex:index];
        // 从列表中删除
        [self.tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark ---subView DELEGATE
//-(void)showCellTabWithCell:(HistoryCell*)cell
//{
//    NSMutableDictionary * dic = [_dataArray objectAtIndex:cell.tag];
//    if (!dic) {
//        return;
//    }
//    if (cell.showBtn.selected ==YES) {
//        cell.showBtn.selected = NO;
//        [dic safeSetObject:@"100" forKey:@"rowHeight"];
//        cell.infoView.hidden = YES;
//        if ([[dic allKeys]containsObject:@"isSelected"]) {
//            [dic removeObjectForKey:@"isSelected"];
//        }
//    }else{
//        [dic safeSetObject:@"isSelected" forKey:@"isSelected"];
//        [dic safeSetObject:@"700" forKey:@"rowHeight"];
//        cell.infoView.hidden = NO;
//        cell.showBtn.selected = YES;
//    }
//    [self.tableview reloadData];
//}

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
