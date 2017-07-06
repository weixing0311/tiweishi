//
//  InfomationViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "InfomationViewController.h"
#import "InfomationCell.h"
#import "BaseWebViewController.h"
@interface InfomationViewController ()

@end

@implementation InfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNbColor];
    // Do any additional setup after loading the view from its nib.
    UITableView *tab =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    InfomationCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"InfomationCell" owner:nil options:nil];
        cell = [arr lastObject];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseWebViewController *web = [[BaseWebViewController alloc]init];
    web.title = @"";
    web.urlStr = @"";
    [self.navigationController pushViewController:web animated:YES];
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
