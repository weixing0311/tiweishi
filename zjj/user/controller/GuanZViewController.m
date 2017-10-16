//
//  GuanZViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/22.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GuanZViewController.h"
#import "NewMineHomePageViewController.h"
#import "UserListCell.h"
#import "GuanzModel.h"
@interface GuanZViewController ()<UITableViewDelegate,UITableViewDataSource,UserListCellGZDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation GuanZViewController
{
    int page;
    int pageSize;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    pageSize = 30;
    _dataArray = [NSMutableArray array];

    if (self.pageType != IS_SEARCH) {
        [self setRefrshWithTableView:self.tableview];
        [self.tableview headerBeginRefreshing];
    }else{
        [self getInfo];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)headerRereshing
{
    page =1;
    [self getInfo];
}
-(void)footerRereshing
{
    page++;
    [self getInfo];
}

//获取关注列表
-(void)getInfo
{
    if (self.pageType ==IS_FUNS) {//粉丝接口
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param safeSetObject:@(page) forKey:@"page"];
        [param safeSetObject:@(pageSize) forKey:@"pageSize"];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/queryFans.do" paramters:param success:^(NSDictionary *dic) {
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
            
            for (NSDictionary *dic in infoArr) {
                GuanzModel * model = [[GuanzModel alloc]init];
                [model setGzInfoWithDict:dic];
                [_dataArray addObject:model];
            }
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            [self.tableview footerEndRefreshing];
            [self.tableview headerEndRefreshing];
            
        }];

    }else if(self.pageType ==IS_GZ){
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [param safeSetObject:@(page) forKey:@"page"];
        [param safeSetObject:@(pageSize) forKey:@"pageSize"];

    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/queryUserFollow.do" paramters:param success:^(NSDictionary *dic) {
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
        for (NSDictionary *dic in infoArr) {
            GuanzModel * model = [[GuanzModel alloc]init];
            [model setGzInfoWithDict:dic];
            [_dataArray addObject:model];
        }

        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];

    }];
    }
    else{
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];

        NSArray * arr = [self.dict safeObjectForKey:@"array"];
        
        for (NSDictionary *dic in arr) {
            GuanzModel * model = [[GuanzModel alloc]init];
            [model setSearchInfoFromDict:dic];
            [_dataArray addObject:model];
        }
        
        [self.tableview reloadData];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier  =@"UserListCell";
    UserListCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    GuanzModel * model = [_dataArray objectAtIndex:indexPath.row];
    [cell.headerimageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]placeholderImage:getImage(@"default")];
    cell.nicknamelb.text = model.nickname;
    
    if ([model.userId isEqualToString:[UserModel shareInstance].userId]) {
        cell.gzbtn.hidden = YES;
    }else{
        cell.gzbtn.hidden =NO;
    }
    
    if (model.isFollow||self.pageType ==IS_GZ) {
        cell.gzbtn.selected =YES;
    }else
    {
        cell.gzbtn.selected = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GuanzModel * model =[_dataArray objectAtIndex:indexPath.row];
    NewMineHomePageViewController * np = [[NewMineHomePageViewController alloc]init];
    np.userId =model.userId;
    [self.navigationController pushViewController:np animated:YES];
}

#pragma mark --celldelegate
-(void)didClickGzBtnWithCell:(UserListCell*)cell;
{
    GuanzModel * model =[_dataArray objectAtIndex:cell.tag];
    if (cell.gzbtn.selected==YES||self.pageType ==IS_GZ) {
        UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"确定不在关注此人吗？" preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [al addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary * params =[NSMutableDictionary dictionary];
            [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
            [params setObject:model.userId forKey:@"followId"];
            self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" paramters:params success:^(NSDictionary *dic) {
                DLog(@"dic-取消关注成功--%@",dic);
                cell.gzbtn.selected = NO;
                [[UserModel shareInstance]showSuccessWithStatus: @"取消关注成功"];
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        
        [self presentViewController:al animated:YES completion:nil];

    }else{
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:model.userId forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/followUser.do" paramters:params success:^(NSDictionary *dic) {
            DLog(@"dic-关注成功--%@",dic);
            cell.gzbtn.selected =YES;
            [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
