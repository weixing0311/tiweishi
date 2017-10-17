//
//  HealthDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailViewController.h"
#import "NewHealthDetailHeaderCell.h"
#import "NewHealthDetailSecondCell.h"
#import "NewHealthDetailThirdCell.h"
#import "NewHealthDetailForthCell.h"
#import "NewHealthDetailFivthCell.h"
#import "NewHealthDetailSixCell.h"
#import "HealthDetailsItem.h"
@interface HealthDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NewHealthDetileFiveDelegate>
@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic,strong)NSMutableArray  * dataArray;
@property (nonatomic,strong)HealthDetailsItem * infoItem ;
@end

@implementation HealthDetailViewController
{
    
    int   ClickItemNo;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康报告";
    [self setTBWhiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    [self getInfo];
    // Do any additional setup after loading the view from its nib.
}


-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:self.dataId forKey:@"dataId"];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kShareUserReviewInfoUrl paramters:param success:^(NSDictionary *dic) {
        
        self.infoItem = [[HealthDetailsItem alloc]init];
        [self.infoItem getInfoWithDict:[dic objectForKey:@"data" ]];
        [self.tableview reloadData];
        DLog(@"%@",dic);
        
    } failure:^(NSError *error) {
        DLog(@"%@",error);
        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"请求超时"];
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    else if (indexPath.section ==1)
    {
        return 100;
    }
    else if (indexPath.section ==2)
    {
        return 60;
    }

    else if (indexPath.section ==3)
    {
        return 200;
    }

    else if (indexPath.section ==4)
    {
        if (((ClickItemNo>0&&ClickItemNo<4)&&indexPath.row==0)||
            ((ClickItemNo >3&&ClickItemNo<7)&&indexPath.row==1)||
            (ClickItemNo>6&&indexPath.row==2))
        {
            return (JFA_SCREEN_WIDTH-20)/3+340;
        }
        else
        {
        return (JFA_SCREEN_WIDTH-20)/3;
        }
    }

    else
    {
        return 0;
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        return 3;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        static NSString * identifier = @"NewHealthDetailHeaderCell";
        NewHealthDetailHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (indexPath.section ==1)
    {
        static NSString * identifier = @"NewHealthDetailSecondCell";
        NewHealthDetailSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else if (indexPath.section ==2)
    {
        static NSString * identifier = @"NewHealthDetailThirdCell";
        NewHealthDetailThirdCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else if (indexPath.section ==3)
    {
        static NSString * identifier = @"NewHealthDetailForthCell";
        NewHealthDetailForthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else /*if (indexPath.section ==4)*/
    {
        static NSString * identifier = @"NewHealthDetailFivthCell";
        NewHealthDetailFivthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.tag = indexPath.row+1;
        [cell setInfoWithDict:self.infoItem];

        if (!ClickItemNo|| ClickItemNo ==0) {
            cell.detailView.hidden = YES;
        }else if (((ClickItemNo>0&&ClickItemNo<4)&&indexPath.row==0)||
                ((ClickItemNo >3&&ClickItemNo<7)&&indexPath.row==1)||
                (ClickItemNo>6&&indexPath.row==2)) {
                cell.detailView.hidden = NO;
            
        }
        
        [cell setDetailViewContentWithButtonIndex:ClickItemNo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
//    else
//    {
//        static NSString * identifier = @"NewHealthDetailSixCell";
//        NewHealthDetailSixCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [self getXibCellWithTitle:identifier];
//        }
//        [cell setInfoWithDict:self.infoItem];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        return cell;
//    }

}



#pragma mark ---cellDelegate
-(void)didClickItemWithTag:(NSInteger)index showDetail:(int)show cell:(NewHealthDetailFivthCell*)cell
{
    
    int  currClickItem = 0;
    
    
    switch (cell.tag) {
        case 1:
            switch (index) {
                case 1:
                    currClickItem = 1;
                    break;
                case 2:
                    currClickItem = 2;
                    break;
                case 3:
                    currClickItem = 3;
                    break;

                default:
                    break;
            }
            break;
        case 2:
            switch (index) {
                case 1:
                    currClickItem = 4;
                    break;
                case 2:
                    currClickItem = 5;
                    break;
                case 3:
                    currClickItem = 6;
                    break;
                    
                default:
                    break;
            }

            break;
        case 3:
            switch (index) {
                case 1:
                    currClickItem = 7;
                    break;
                case 2:
                    currClickItem = 8;
                    break;
                case 3:
                    currClickItem = 9;
                    break;
                    
                default:
                    break;
            }

            break;

        default:
            break;
    }
    
    if (ClickItemNo ==currClickItem) {
        ClickItemNo = 0;
    }else{
        ClickItemNo = currClickItem;
    }
    
    [self.tableview reloadData];
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
