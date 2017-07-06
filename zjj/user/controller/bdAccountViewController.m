//
//  bdAccountViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "bdAccountViewController.h"

@interface bdAccountViewController ()

@end

@implementation bdAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号绑定";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
            cell.textLabel.text = @"手机号";
            cell.imageView.image = [UIImage imageNamed:@"phone_"];
            cell.detailTextLabel.text = @"已绑定";

            break;
        case 1:
            cell.textLabel.text = @"微信";
            cell.imageView.image = [UIImage imageNamed:@"weixin_"];
            cell.detailTextLabel.text = @"未绑定";
            break;
        case 2:
            cell.textLabel.text = @"QQ";
            cell.imageView.image = [UIImage imageNamed:@"qq_"];
            cell.detailTextLabel.text = @"未绑定";

            break;
            
        default:
            break;
    }
    return cell;
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
