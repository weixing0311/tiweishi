//
//  WeighingViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WeighingViewController.h"
#import "WWXBlueToothManager.h"
#import "HealthModel.h"
@interface WeighingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UIButton *lLJBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chengImageView;

@end

@implementation WeighingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[SubUserItem shareInstance].headUrl] placeholderImage:getImage(@"head_default")];
    self.nickNameLb.text = [SubUserItem shareInstance].nickname;
    // Do any additional setup after loading the view from its nib.
    [self didUpdateinfo];
}
-(void)didUpdateinfo
{
    
    self.statuslb.text = @"请上秤。。。";
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [[WWXBlueToothManager shareInstance]startScanWithStatus:^(NSString *statusString) {
        self.statuslb.text =statusString;
        
    } success:^(NSDictionary *dic) {
        self.statuslb.text = @"测量成功！开始上传...";

        [[HealthModel shareInstance]setLogInUpLoadString:@"上传成功"];
        [[HealthModel shareInstance]UpdateBlueToothInfo];
        
        [self updataInfoWithDict:dic];
        
    } faile:^(NSError *error, NSString *errMsg) {
        [SVProgressHUD dismiss];
        [[WWXBlueToothManager shareInstance]stop];
        self.statuslb.text = errMsg;

        [[UserModel shareInstance] showErrorWithStatus:errMsg];
        [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"上传失败--error---%@",error]];
        self.lLJBtn.hidden =NO;
        [[HealthModel shareInstance]UpdateBlueToothInfo];
    }];
    
}
#pragma mark ---healthMainCelldelegate
/**
 * 上传数据
 */

-(void)updataInfoWithDict:(NSDictionary *)dic
{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setDictionary:dic];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    DLog(@"上传数据---%@",param);
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/addEvaluatData.do" paramters:param success:^(NSDictionary *dic) {
        
        self.statuslb.text = @"上传成功！";
        
    
        if (self.delegate &&[self.delegate respondsToSelector:@selector(weightingSuccess)]) {
            [self.delegate weightingSuccess];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
//        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
//        TZdetaolViewController * tzDetai =[[TZdetaolViewController alloc]init];
//        tzDetai.dataId = [[dic safeObjectForKey:@"data"] safeObjectForKey:@"DataId"];
//        tzDetai.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:tzDetai animated:YES];
        
        
        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",dic);
        
    } failure:^(NSError *error) {
        [[UserModel shareInstance] showErrorWithStatus:@"上传失败"];
        DLog(@"url-app/evaluatData/addEvaluatData.do  dic--%@",error);
        
    }];
}

- (IBAction)didClickClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didClickLj:(id)sender {
    self.lLJBtn.hidden = YES;
    [self didUpdateinfo];
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
