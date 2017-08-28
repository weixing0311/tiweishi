//
//  ResignListViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ResignListViewController.h"
#import "QRCodeResignViewController.h"
#import "ResignViewController.h"
@interface ResignListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ResignListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"注册";
    [self setTBRedColor];
    self.tableview .delegate = self;
    self.tableview .dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row ==0) {
        cell.textLabel.text = @"扫描二维码";
    }else{
        cell.textLabel.text = @"推荐人注册";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0) {
        QRCodeResignViewController * rq= [[QRCodeResignViewController alloc]init];
        [self.navigationController pushViewController:rq animated:YES];
    }else{
        ResignViewController * rg= [[ResignViewController alloc]init];
        [self.navigationController pushViewController:rg animated:YES];
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
