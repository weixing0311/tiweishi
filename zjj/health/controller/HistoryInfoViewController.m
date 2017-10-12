//
//  HistoryInfoViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryInfoViewController.h"
#import "HistoryHeaderView.h"
#import "HistoryInfoCell.h"
#import "NSDate+CustomDate.h"
#import "Daysquare.h"
#import "ShareHealthItem.h"
#import "HistorySectionView.h"
@interface HistoryInfoViewController ()<UITableViewDelegate,UITableViewDataSource,historyHeaderDelegate>
@property (weak,  nonatomic) IBOutlet UIView *rlView;
@property (nonatomic,strong) HistoryHeaderView * headerView;
@property (weak,  nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (nonatomic,strong)DAYCalendarView * calendarView;

@end

@implementation HistoryInfoViewController
{
    int tabRowCount;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    _infoDict = [NSMutableDictionary dictionary];
    self.headerView =[self getXibCellWithTitle:@"HistoryHeaderView"];
    self.headerView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 400);
    self.tableview.tableHeaderView = self.headerView;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    tabRowCount=0;
    
    
    
//    self.calendarView = [[DAYCalendarView alloc]initWithFrame:CGRectMake(10, 0, JFA_SCREEN_WIDTH-20, (JFA_SCREEN_WIDTH-20)*)];
//    [self.riView addSubview:self.calendarView];

    [self.headerView.calendarView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];

    // Do any additional setup after loading the view from its nib.
}
- (void)calendarViewDidChange:(id)sender {
//    self.datePicker.date = self.calendarView.selectedDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSLog(@"%@", [formatter stringFromDate:self.headerView.calendarView.selectedDate]);
    
    [self getInfoWithDate:[self.headerView.calendarView.selectedDate yyyymmddhhmmss]];
}

-(void)getInfoWithDate:(NSString *)dateStr
{
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:self.dataId forKey:@"dataId"];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kShareUserReviewInfoUrl paramters:param success:^(NSDictionary *dic) {
        DLog(@"%@",dic);
        _infoDict = [dic safeObjectForKey:@"data"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HistorySectionView * view =[self getXibCellWithTitle:@"HistorySectionView"];
    view.tag = section;
    view.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 400);
    view.delegate = self;
    view.weightlb.text =[NSString stringWithFormat:@"%.1f",[[_infoDict safeObjectForKey:@"weight"]floatValue]];
    view.tzlLb.text = [NSString stringWithFormat:@"%.1f%%",[[_infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
    view.timeLb.text = [self getTimeWithString:[_infoDict safeObjectForKey:@"createTime"]];

    return view;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tabRowCount;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"HistoryInfoCell";
    HistoryInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    
    
    /*
     status = success,
     message = 获取用户评测数据成功,
     data = {
     proteinWeightMax = 12.08845,
     DataId = 175069,
     fatControl = 0,
     proteinLevel = 1,
     score = 79.550804,
     fatPercentageMax = 0.2,
     muscleLevel = 1,
     fatWeight = 13.348648,
     weight = 70.90000000000001,
     boneMuscleWeightMax = 44.39631,
     mBone = 3.2,
     lbm = 54.20505,
     fatWeightLevel = 1,
     proteinWeight = 11.558467,
     standardWeight = 67.55370000000001,
     fatWeightMin = 7.09,
     warn = 0,
     weightLevel = 2,
     boneMuscleWeight = 38.49808,
     muscleWeightMax = 59.19508,
     serious = 0,
     boneWeightMax = 3.8995,
     mMuscle = 32.7,
     userId = 2615,
     visceralFatPercentageLevel = 1,
     muscleWeight = 53.956665,
     bmr = 1667.75,
     boneWeightMin = 3.1905,
     normal = 9,
     mCalorie = 1702,
     proteinWeightMin = 9.890549999999999,
     height = 175,
     mFat = 15.1,
     waterLevel = 1,
     waterWeightMax = 46.794,
     fatPercentageMin = 0.1,
     fatPercentage = 0.18827431,
     fatWeightMax = 14.18,
     visceralFatPercentage = 6,
     muscleWeightMin = 48.43234,
     age = 28,
     mVisceralFat = 6,
     boneLevel = 1,
     fatPercentageLevel = 1,
     mWater = 0.598,
     lastWeight = 80,
     boneMuscleLevel = 1,
     boneMuscleWeightMin = 36.324253,
     waterWeightMin = 38.286,
     waterWeight = 42.3982,
     bmi = 23.15102,
     bodyLevel = 5,
     boneWeight = 3.5946853,
     createTime = 2017-08-24 17:30:08,
     weightControl = -3.3463,
     waterPercentage = 0.598,
     bmiLevel = 2,
     bodyAge = 28,
     subUserId = 122175

     */

    switch (indexPath.row) {
        case 0:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"BMI";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[_infoDict safeObjectForKey:@"bmi"]floatValue]];
            cell.secondLb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"bmiLevel"]intValue] status:IS_BMI];
;
            break;
        case 1:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"肌肉";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[_infoDict safeObjectForKey:@"muscleWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"muscleLevel"]intValue] status:IS_SAME];
            break;
        case 2:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"内脏脂肪";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[_infoDict safeObjectForKey:@"visceralFatPercentage"]floatValue]];
            cell.secondLb.text = [[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"visceralFatPercentageLevel"]intValue] status:IS_VISCERALFAT];
            break;
        case 3:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"基础代谢率";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[_infoDict safeObjectForKey:@"bmr"]floatValue]];

            break;
        case 4:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"蛋白质";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[_infoDict safeObjectForKey:@"proteinWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"proteinLevel"]intValue] status:IS_SAME];
            break;
        case 5:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"身体年龄";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[_infoDict safeObjectForKey:@"bodyAge"]floatValue]];

            break;
        case 6:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"骨量";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[_infoDict safeObjectForKey:@"boneWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"boneLevel"]intValue] status:IS_SAME];


            break;
        case 7:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"水分";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[_infoDict safeObjectForKey:@"waterWeight"]floatValue]];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"waterLevel"]intValue] status:IS_SAME];


            break;
        case 8:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"脂肪重量";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1fkg",[[_infoDict safeObjectForKey:@"fatWeight"]floatValue]];
           cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"fatWeightLevel"]intValue] status:IS_SAME];

            break;
        case 9:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"体脂指数";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f%%",[[_infoDict safeObjectForKey:@"fatPercentage"]floatValue]*100];
            cell.secondLb.text =[[ShareHealthItem shareInstance] getHeightWithLevel:[[_infoDict safeObjectForKey:@"visceralFatPercentageLevel"]intValue] status:IS_SAME];

            break;
        case 10:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"肥胖等级";
            cell.valuelb.text = [self getwl:[[_infoDict objectForKey:@"weightLevel"]intValue]];

            break;
        case 11:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"体型";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[_infoDict safeObjectForKey:@""]floatValue]];

            break;
        case 12:
            cell.headImageView.image  = getImage(@"");
            cell.titlelb.text = @"正常体重";
            cell.valuelb.text = [NSString stringWithFormat:@"%.1f",[[_infoDict safeObjectForKey:@"standardWeight"]floatValue]];

            break;

        default:
            break;
    }
    
    return cell;
}


#pragma mark ---subView DELEGATE
-(void)didShowDetailInfoWithIndex:(int)index
{
    if (!_infoDict|| [_infoDict allKeys].count<1) {
        return;
    }
    HistorySectionView * view =[self.view viewWithTag:index];
    if (view.showBtn.selected==YES) {
        view.showBtn.selected =NO;
        tabRowCount=0;
    }
    else{
        view.showBtn.selected =YES;
        tabRowCount=13;
    }
    [self.tableview reloadData];
}


-(NSString *)getwl:(int )weightLevel
{
    
    NSString * levelStr;
    switch (weightLevel) {
        case 1:
            levelStr = [NSString stringWithFormat:@"偏瘦"];
            break;
        case 2:
            levelStr = [NSString stringWithFormat:@"正常"];
            break;
        case 3:
            levelStr = [NSString stringWithFormat:@"偏胖"];
            break;
        case 4:
            levelStr = [NSString stringWithFormat:@"偏胖"];
            break;
        case 5:
            levelStr = [NSString stringWithFormat:@"超重"];
            break;
        case 6:
            levelStr = [NSString stringWithFormat:@"超重"];
            break;
            
        default:
            break;
    }
    return levelStr;
    
}
-(NSString *)getTimeWithString:(NSString *)str
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    NSLog(@"date= %@", inputDate);
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"hh:mm"];
    NSString *string= [outputFormatter stringFromDate:inputDate];
    return string;
    
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
