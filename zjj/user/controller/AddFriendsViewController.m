//
//  AddFriendsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "GuanZViewController.h"
@interface AddFriendsViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchtf;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem = rightItem;
    self.searchtf.delegate = self;
    self.searchtf.returnKeyType  = UIReturnKeyGo;
    self.searchtf.clearButtonMode = UITextFieldViewModeWhileEditing;
    // Do any additional setup after loading the view from its nib.
}

-(void)getInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //userid nickname
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.searchtf.text forKey:@"nickName"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/searchUserFollow.do" paramters:params success:^(NSDictionary *dic) {
        
        GuanZViewController * gz = [[GuanZViewController alloc]init];
        gz.title = @"搜索结果";
        gz.pageType = IS_SEARCH;
        gz.dict = [NSMutableDictionary dictionaryWithDictionary:[dic safeObjectForKey:@"data"]];
        [self.navigationController pushViewController:gz animated:YES];
    } failure:^(NSError *error) {
        
    }];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated: YES];
}
- (IBAction)didGetqrcode:(id)sender {
}
- (IBAction)showmyQRcode:(id)sender {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getInfo];
    return YES;
    
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
