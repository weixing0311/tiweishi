//
//  MineViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MineViewController.h"
#import "PublicCell.h"
#import "BaseWebViewController.h"
#import "EidtViewController.h"
#import "BodyFatDivisionAgreementViewController.h"
#import "OrderViewController.h"
@interface MineViewController ()

@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self getWaitPayCount];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationbar颜色
//    [self setNbColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfoView) name:kRefreshInfo object:nil];

    [self.headImageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.nickName.text = [UserModel shareInstance].nickName;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.waitSendLabel.hidden = YES;
    self.waitpayCountLabel .hidden = YES;
}
-(void)refreshMyInfoView
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:[UIImage imageNamed:@"head-default"]];
    self.nickName.text = [UserModel shareInstance].nickName;
}


/**
 *  查看待付款待配送数量
 */
-(void)getWaitPayCount
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/statusCount.do" paramters:param success:^(NSDictionary *dic) {
        NSDictionary *dict =[dic objectForKey:@"data"];
        
        int getWaitPayCount = [[dict safeObjectForKey:@"uncollected"]intValue];
        int unpaid          = [[dict safeObjectForKey:@"unpaid"]intValue];
        if (unpaid==0) {
            self.waitSendLabel.hidden = YES;
        }else{
            self.waitSendLabel.hidden =NO;
            self.waitSendLabel.text = [NSString stringWithFormat:@"%d",getWaitPayCount];
        }
        if (getWaitPayCount==0) {
            self.waitpayCountLabel.hidden = YES;
        }else{
            self.waitpayCountLabel.hidden =NO;
            self.waitpayCountLabel.text = [NSString stringWithFormat:@"%d",unpaid];

        }
    } failure:^(NSError *error) {
        self.waitSendLabel.hidden = YES;
        self.waitpayCountLabel.hidden = YES;
        
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    PublicCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *arr =[[NSBundle mainBundle]loadNibNamed:@"PublicCell" owner:nil options:nil];
        cell =[arr lastObject];
    }
    if (indexPath.row==0) {
        cell.titleLabel.text = @"帮助中心";
        cell.secondLabel.text = @"帮助文档";
        cell .headImageView.image= [UIImage imageNamed:@"personal-help-icon"];

    }else{
        cell.titleLabel.text = @"联系我们";
        cell.secondLabel .text = @"联系方式";
        cell.headImageView.image= [UIImage imageNamed:@"personal-lianxi"];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseWebViewController *web =[[BaseWebViewController alloc]init];
    
    if (indexPath.row ==0) {
        web.title = @"帮助中心";
        web.urlStr = @"";
    }else{
        web.title = @"联系我们";
        web.urlStr = @"";
    }
    web.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;

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

- (IBAction)didSetUp:(id)sender {
    EidtViewController *ed = [[EidtViewController alloc]init];
    ed.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:ed animated:YES];
}

- (IBAction)waitForPayment:(id)sender {
    OrderViewController * od =[[OrderViewController alloc]init];
    od.getOrderType = IS_WATE_PAY;
    od.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
    

    [self.navigationController pushViewController:od animated:YES];
}

- (IBAction)waitForGetGoods:(id)sender {
    OrderViewController * od =[[OrderViewController alloc]init];
    od.getOrderType = IS_WAIT_GETGOOD;
    od.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
    

    [self.navigationController pushViewController:od animated:YES];
}

- (IBAction)allTheOrder:(id)sender {
    OrderViewController * od =[[OrderViewController alloc]init];
    od.getOrderType =IS_ALL;
    od.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
    

    [self.navigationController pushViewController:od animated:YES];
}

- (IBAction)didTzs:(id)sender {
    BodyFatDivisionAgreementViewController *bd = [[BodyFatDivisionAgreementViewController alloc]init];
//    self.navigationController.navigationBarHidden = NO;

    bd.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bd animated:YES];
}
@end
