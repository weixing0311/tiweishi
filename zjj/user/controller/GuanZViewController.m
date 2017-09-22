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
@interface GuanZViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation GuanZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    [self setExtendedLayoutIncludesOpaqueBars:self.tableview];
    self.dataArray = @[@"1",@"1",@"1",@"1",@"1",@"1"];
    // Do any additional setup after loading the view from its nib.
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
}
    return _dataArray;

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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewMineHomePageViewController * np = [[NewMineHomePageViewController alloc]init];
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
