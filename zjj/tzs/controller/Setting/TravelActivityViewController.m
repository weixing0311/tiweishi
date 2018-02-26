//
//  TravelActivityViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/1/18.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TravelActivityViewController.h"
#import "TravelActiveCell.h"
#import "TravleDetailViewController.h"
@interface TravelActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation TravelActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)buildTabelView
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"TravelActiveCell";
    TravelActiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    
    NSDictionary * dic= [_dataArray objectAtIndex:indexPath.row];
    cell.titlelb.text = [dic safeObjectForKey:@"title"];
    cell.timelb.text = [NSString stringWithFormat:@"%@至%@",[dic safeObjectForKey:@"startTime"],[dic safeObjectForKey:@"startTime"]];
    [cell.headImageView  sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"image"]] placeholderImage:getImage(@"bigDefalut_")];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TravleDetailViewController * tr =[[TravleDetailViewController alloc]init];
    [self.navigationController pushViewController:tr animated:YES];
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
