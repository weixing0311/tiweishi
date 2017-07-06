//
//  TZdetaolViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZdetaolViewController.h"
#import "EvaluationDetailDatasCell.h"
#import "EvaluationDetailExtendCell.h"
#import "EvaluationDetailScroeDescriptionCell.h"
#import "HealthDetailsItem.h"
#import "DidShareViewController.h"
#import "ShareBottomView.h"
@interface TZdetaolViewController ()

@end

@implementation TZdetaolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    self.title=@"评测报告";
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem * rig =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_"] style:UIBarButtonItemStyleDone target:self action:@selector(didShare)];
    
    self.navigationItem.rightBarButtonItem = rig;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self getInfo];
    [self buildFootView];
}
-(void)didShare
{
    [self buildShareView];
//    DidShareViewController * share = [[DidShareViewController alloc]init];
//    [self.navigationController pushViewController:share animated:YES];
}
-(void)buildShareView
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    ShareBottomView * bv =[self getXibCellWithTitle:@"ShareBottomView"];
    UIView * bv =[[UIView alloc]init];
    bv.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 50);
    [al setView:bv];
    [self.navigationController pushViewController:al animated:YES];
}
-(void)buildFootView
{
    UIView * view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 100)];
    view.backgroundColor =[UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 269, 42)];
    button.center  = view.center;
    [button setBackgroundImage:[UIImage imageNamed:@"button_normal"] forState:UIControlStateNormal];
    [button setTitle:@"删除数据" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteInfo) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.tableview.tableFooterView = view;
}
-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:self.dataId forKey:@"dataId"];
    [param setObject:[UserModel shareInstance].healthId forKey:@"subUserId"];
    
    [[BaseSservice sharedManager]post1:kShareUserReviewInfoUrl paramters:param success:^(NSDictionary *dic) {
        [[HealthDetailsItem instance]getInfoWithDict:[dic objectForKey:@"data" ]];
        [self.tableview reloadData];
        DLog(@"%@",dic);
        
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

-(void)deleteInfo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:@([HealthDetailsItem instance].DataId) forKey:@"dataId"];
    [[BaseSservice sharedManager]post1:@"app/evaluatData/deleteEvaluatData.do" paramters:param success:^(NSDictionary *dic) {
        [self showError:@"删除成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deletePCINFO" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else{
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section ==0) {
        
        static NSString * identifier = @"EvaluationDetailScroeDescriptionCell";
        EvaluationDetailScroeDescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell ) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setUpinfoWithItem];
        return cell;
    }else{
        static NSString * identifier = @"EvaluationDetailDatasCell";
        
        EvaluationDetailDatasCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EvaluationDetailDatasCell" owner:nil options:nil];
            cell = [nibs lastObject];
        };
        cell.tag = indexPath.row;
        cell.backgroundColor = [UIColor clearColor];
        [cell setUpWithItem:[HealthDetailsItem instance]];
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 400;
    }else{
        return 117;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        return;
    }else{
        
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
