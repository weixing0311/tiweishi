//
//  HealthDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailViewController.h"
#import "NewHealthDetailHeaderCell.h"
#import "NewHealthDetailSecondCell.h"
#import "NewHealthDetailThirdCell.h"
#import "NewHealthDetailForthCell.h"
#import "NewHealthDetailFivthCell.h"
#import "NewHealthDetailSixCell.h"
#import "HealthDetailsItem.h"
#import "WriteArtcleViewController.h"
@interface HealthDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NewHealthDetileFiveDelegate,NewHealthDetailThirdDelegate>
@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic,strong)NSMutableArray  * dataArray;
@property (nonatomic,strong)HealthDetailsItem * infoItem ;
@end

@implementation HealthDetailViewController
{
    
    int   ClickItemNo;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setTBWhiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康报告";
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    _dataArray = [NSMutableArray array];
    [self getInfo];
    [self buildRightNaviBarItem];
    
    
    if (self.subtractMaxWeight.length>0) {
        [self showAlertViewWithsubtractMaxWeight:self.subtractMaxWeight];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)buildRightNaviBarItem
{
    
    
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shareWhite_"] style:UIBarButtonItemStylePlain target:self action:@selector(didShare)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}


-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:self.dataId forKey:@"dataId"];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kShareUserReviewInfoUrl HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        self.infoItem = [[HealthDetailsItem alloc]init];
        [self.infoItem getInfoWithDict:[dic objectForKey:@"data" ]];
        [self.tableview reloadData];
        DLog(@"%@",dic);
        
    } failure:^(NSError *error) {
        DLog(@"%@",error);
        if (error.code ==-1001) {
            [[UserModel shareInstance] showErrorWithStatus:@"请求超时"];
        }
    }];
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    else if (indexPath.section ==1)
    {
        return 70;
    }
    else if (indexPath.section ==2)
    {
        return 45;
    }

    else if (indexPath.section ==3)
    {
        return 155;
    }

    else if (indexPath.section ==4)
    {
        if (((ClickItemNo>0&&ClickItemNo<4)&&indexPath.row==0)||
            ((ClickItemNo >3&&ClickItemNo<7)&&indexPath.row==1)||
            (ClickItemNo>6&&indexPath.row==2))
        {
            return 90+340;
        }
        else
        {
        return 90;
        }
    }

    else
    {
        return 0;
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        return 3;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        static NSString * identifier = @"NewHealthDetailHeaderCell";
        NewHealthDetailHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (indexPath.section ==1)
    {
        static NSString * identifier = @"NewHealthDetailSecondCell";
        NewHealthDetailSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else if (indexPath.section ==2)
    {
        static NSString * identifier = @"NewHealthDetailThirdCell";
        NewHealthDetailThirdCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else if (indexPath.section ==3)
    {
        static NSString * identifier = @"NewHealthDetailForthCell";
        NewHealthDetailForthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setInfoWithDict:self.infoItem];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else /*if (indexPath.section ==4)*/
    {
        static NSString * identifier = @"NewHealthDetailFivthCell";
        NewHealthDetailFivthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.tag = indexPath.row+1;
        [cell setInfoWithDict:self.infoItem];

        if (!ClickItemNo|| ClickItemNo ==0) {
            cell.detailView.hidden = YES;
        }else if (((ClickItemNo>0&&ClickItemNo<4)&&indexPath.row==0)||
                ((ClickItemNo >3&&ClickItemNo<7)&&indexPath.row==1)||
                (ClickItemNo>6&&indexPath.row==2)) {
                cell.detailView.hidden = NO;
            
        }
        
        [cell setDetailViewContentWithButtonIndex:ClickItemNo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
//    else
//    {
//        static NSString * identifier = @"NewHealthDetailSixCell";
//        NewHealthDetailSixCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [self getXibCellWithTitle:identifier];
//        }
//        [cell setInfoWithDict:self.infoItem];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        return cell;
//    }

}



#pragma mark ---cellDelegate
-(void)didClickItemWithTag:(NSInteger)index showDetail:(int)show cell:(NewHealthDetailFivthCell*)cell
{
    
    int  currClickItem = 0;
    
    
    switch (cell.tag) {
        case 1:
            switch (index) {
                case 1:
                    currClickItem = 1;
                    break;
                case 2:
                    currClickItem = 2;
                    break;
                case 3:
                    currClickItem = 3;
                    break;

                default:
                    break;
            }
            break;
        case 2:
            switch (index) {
                case 1:
                    currClickItem = 4;
                    break;
                case 2:
                    currClickItem = 5;
                    break;
                case 3:
                    currClickItem = 6;
                    break;
                    
                default:
                    break;
            }

            break;
        case 3:
            switch (index) {
                case 1:
                    currClickItem = 7;
                    break;
                case 2:
                    currClickItem = 8;
                    break;
                case 3:
                    currClickItem = 9;
                    break;
                    
                default:
                    break;
            }

            break;

        default:
            break;
    }
    
    if (ClickItemNo ==currClickItem) {
        ClickItemNo = 0;
    }else{
        ClickItemNo = currClickItem;
    }
    
    [self.tableview reloadData];
}

#pragma  mark ---cellDelegate
-(void)didShareImage
{
    UIImage * image = [self getImage];
    WriteArtcleViewController * write = [[WriteArtcleViewController alloc]init];
    write.firstImage = image;
    write.shareType = @"";
    [self.navigationController pushViewController:write animated:YES];
}

-(void)didShare
{
    UIImage * image = [self getImage];
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self shareWithType:SSDKPlatformSubTypeWechatSession image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];

}

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
                 
                [[UserModel shareInstance]didCompleteTheTaskWithId:@"7"];
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

-(UIImage *)getImage
{
    
    UIGraphicsBeginImageContext(CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.navigationController.view.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
-(void)showAlertViewWithsubtractMaxWeight:(NSString *)subtractMaxWeight
{
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"" message:[self getDUDUAlertCtitle:[subtractMaxWeight floatValue]] preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //添加跳转
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];

}


-(NSString *)getDUDUAlertCtitle:(float)lastkg
{
    return [NSString stringWithFormat:@"恭喜您，已减%.1f斤，发条动态向各位减脂同道分享自己的变化吧！记录数据，超越自己。",lastkg*2];
    
}



//-(NSString *)getAlertViewTitle:(HealthDetailsItem*)item
//{
//
//    if (item.weight ==item.lastWeight) {
//        return [NSString stringWithFormat:@"您现在体重为%.1fkg，发条动态吧，记录数据，超越自己。",item.weight];
//    }else
//    {
//        NSString * status = @"";
//        if (item.weight-item.lastWeight>0) {
//            status = @"重";
//        }else{
//            status = @"轻";
//        }
//
//        return [NSString stringWithFormat:@"您比上次%@了%.1fkg，发条动态向各位减脂同道分享自己的变化据吧！记录数据，超越自己。",status,fabsf(item.weight-item.lastWeight)];
//    }
//
//}
//

    
    
    


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
