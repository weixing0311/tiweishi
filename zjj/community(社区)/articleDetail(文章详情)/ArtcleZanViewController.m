//
//  ArtcleZanViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/26.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ArtcleZanViewController.h"
#import "UserListCell.h"
#import "GuanzModel.h"
#import "NewMineHomePageViewController.h"
@interface ArtcleZanViewController ()<UITableViewDelegate,UITableViewDataSource,UserListCellGZDelegate>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ArtcleZanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource  = self;
    [self.view addSubview:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    [self getZanPersonInfo];
    // Do any additional setup after loading the view.
}
-(void)getZanPersonInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:self.articleId forKey:@"articleId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/queryGreatPerson.do" paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        
        for (NSDictionary *dic in infoArr) {
            GuanzModel * model = [[GuanzModel alloc]init];
            [model setGzInfoWithDict:dic];
            [_dataArray addObject:model];
        }
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        if ([error code] ==402) {
            [_dataArray removeAllObjects];
            [self.tableview reloadData];
        }
        
    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    cell.secondLb.text = model.introduction;
    if ([model.userId isEqualToString:[UserModel shareInstance].userId]) {
        cell.gzbtn.hidden = YES;
    }else{
        cell.gzbtn.hidden =NO;
    }
    UIColor * bgColor ;
    UIColor * layerColor;
    if (model.isFollow) {
        cell.gzbtn.selected =YES;
        cell.gzbtn.layer.borderWidth= 1;
        bgColor = [UIColor whiteColor];
        layerColor = HEXCOLOR(0x666666);
        
    }else
    {
        cell.gzbtn.selected = NO;
        cell.gzbtn.layer.borderWidth= 1;
        bgColor = [UIColor redColor];
        layerColor = [UIColor redColor];
    }
    cell.gzbtn.layer.borderColor = layerColor.CGColor;
    cell.gzbtn.backgroundColor = bgColor;
    
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
