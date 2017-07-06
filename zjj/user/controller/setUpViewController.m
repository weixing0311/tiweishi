//
//  setUpViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "setUpViewController.h"
#import "AboutUsViewController.h"
@interface setUpViewController ()

@end

@implementation setUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"意见反馈";
            
            break;
        case 1:
            cell.textLabel.text = @"关于我们";
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        
    }else{
        AboutUsViewController *ab= [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:ab animated:YES];
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
