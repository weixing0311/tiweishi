//
//  ArticleDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ArticleDetailViewController.h"

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)getCommentList//评论列表
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //page pagesize articleId userid
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlecomment/queryArticlecomment.do" paramters:params success:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];

}
-(void)getCommentInfo//评论接口
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //articleId userId content
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlecomment/saveArticlecomment.do" paramters:params success:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];

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
