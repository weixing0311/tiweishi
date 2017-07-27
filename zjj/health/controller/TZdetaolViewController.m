//
//  TZdetaolViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZdetaolViewController.h"
#import "HealthDetailSelectedCell.h"
#import "HealthDetailNormalCell.h"
#import "EvaluationDetailScroeDescriptionCell.h"
#import "HealthDetailsItem.h"
#import "DidShareViewController.h"
#import "ShareBottomView.h"
#import "ShareDetailView.h"
@interface TZdetaolViewController ()<healthDetailCellDelegate,HealthDetailNormalDelegate>

@end

@implementation TZdetaolViewController
{
    float cell1Height;
    float cell2Height;
    int   cellSelectBtnTag;


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBRedColor];
    self.title=@"体脂报告";
    // Do any additional setup after loading the view.
    cell1Height = 117;
    cell2Height = 117;
    self.selectIndex = nil;
    UIBarButtonItem * rig =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_"] style:UIBarButtonItemStyleDone target:self action:@selector(didShare)];
    
    self.navigationItem.rightBarButtonItem = rig;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self getInfo];
    [self buildFootView];
}
-(void)didShare
{
    [self buildShareView];
}
-(void)buildShareView
{
    UIImage * image = [self showShareView];

    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline image:image];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ image:image];

        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
}


-(void)buildFootView
{
    UIView * view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 100)];
    view.backgroundColor =[UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 269, 42)];
    button.center  = view.center;
    [button setBackgroundColor:HEXCOLOR(0xee0a3b)];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.frame.size.height / 2;
//    [button setBackgroundImage:[UIImage imageNamed:@"button_normal"] forState:UIControlStateNormal];
    [button setTitle:@"删除数据" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteInfo) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.tableview.tableFooterView = view;
}
-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:self.dataId forKey:@"dataId"];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kShareUserReviewInfoUrl paramters:param success:^(NSDictionary *dic) {
        [[HealthDetailsItem instance]getInfoWithDict:[dic objectForKey:@"data" ]];
        [self.tableview reloadData];
        DLog(@"%@",dic);
        
    } failure:^(NSError *error) {
        DLog(@"%@",error);
        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"请求超时"];
        }
    }];
}

-(void)deleteInfo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:@([HealthDetailsItem instance].DataId) forKey:@"dataId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/deleteEvaluatData.do" paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"删除成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deletePCINFO" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else{
        return 3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section ==0) {
        
        static NSString * identifier = @"EvaluationDetailScroeDescriptionCell";
        EvaluationDetailScroeDescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell ) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setUpinfoWithItem];
        return cell;
    }else{
        
        if (indexPath.row == self.selectIndex.row &&self.selectIndex!= nil){    //选中状态
        static NSString * identifier = @"HealthDetailSelectedCell";
        
        HealthDetailSelectedCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        [cell setUpWithItem:[HealthDetailsItem instance]];
        [cell setSliderInfoWithdict:[[HealthDetailsItem instance]setSliderInfoWithRow:indexPath.row btnTag:cellSelectBtnTag]];

        return cell;
        }else{
            static NSString * identifier = @"HealthDetailNormalCell";
            
            HealthDetailNormalCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.tag = indexPath.row;
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            [cell setUpWithItem:[HealthDetailsItem instance]];
            
            return cell;
  
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 400;
    }else{
        if (indexPath.row == self.selectIndex.row && self.selectIndex != nil){
            return 242;
        }else{
            return 117;
  
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        return;
    }else{
        
    }
}



#pragma mark ----share 
-(void) shareWithType:(SSDKPlatformType)type image:(UIImage *)image
{
    if (!image) {
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[image];
    
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:imageArray
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeImage];
    
    [shareParams SSDKEnableUseClientShare];
    [SVProgressHUD showWithStatus:@"开始分享"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [[UserModel shareInstance]dismiss];
//                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [[UserModel shareInstance]dismiss];
//                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [[UserModel shareInstance]dismiss];
//                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                 break;
             }
             default:
                 break;
         }
     }];
    
}

-(UIImage *)showShareView
{
    ShareDetailView * de = [self getXibCellWithTitle:@"ShareDetailView"];
    [self.view addSubview:de];
    [self.view bringSubviewToFront:de];
    return  [self getImageWithView:de];

}


-(UIImage *)getImageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    [view removeFromSuperview];
    return viewImage;
}
#pragma mark ---celldelegate
-(void)getBtnDidClickCount:(UIButton *)button  withCell:(HealthDetailSelectedCell*)cell
{
    NSIndexPath *indexPath;
    
    indexPath= [self.tableview indexPathForCell:cell];

    if (cellSelectBtnTag ==button.tag) {
        cellSelectBtnTag =0;
        self.selectIndex =nil;
    }else{
        cellSelectBtnTag = button.tag;
        
        [cell setSliderInfoWithdict:[[HealthDetailsItem instance]setSliderInfoWithRow:indexPath.row btnTag:cellSelectBtnTag]];
        
        
        
    }
    
    

    [self.tableview reloadData];

}
-(void)getButtonDidClickCount:(UIButton *)button  withCell:(HealthDetailNormalCell*)cell
{
    NSIndexPath *indexPath;
    
    indexPath= [self.tableview indexPathForCell:cell];
    
    self.selectIndex =indexPath;
    cellSelectBtnTag = button.tag;
    
    [self.tableview reloadData];


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
