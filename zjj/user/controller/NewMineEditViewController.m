
//
//  NewMineEditViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineEditViewController.h"
#import "AboutUsViewController.h"
#import "ChangePasswordViewController.h"
#import "LoignViewController.h"
@interface NewMineEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation NewMineEditViewController
{
    NSArray * dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setTBWhiteColor];

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    dataArray  =@[@"修改密码",@"消息设置",@"清空缓存",@"版本更新",@"关于我们",];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        ChangePasswordViewController * cb = [[ChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:cb animated:YES];
    }
    else if (indexPath.row==1)
    {
        
    }
    else if (indexPath.row==2)
    {
        
    }

    else if (indexPath.row==3)
    {
        
    }

    else
    {
        AboutUsViewController * ab= [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:ab animated:YES];
    }

}
- (IBAction)loignOut:(id)sender {
    UIAlertController * la =[UIAlertController alertControllerWithTitle:@"是否确认退出登录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [la addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyloignInfo];
        [[UserModel shareInstance]removeAllObject];
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController = lo;
    }]];
    [la addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:la animated:YES completion:nil];

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
