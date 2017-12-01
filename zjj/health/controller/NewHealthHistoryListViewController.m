//
//  NewHealthHistoryListViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthHistoryListViewController.h"
#import "NSDate+CustomDate.h"
#import "Daysquare.h"
#import "ShareHealthItem.h"
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import "ShareListView.h"
#import "HistoryCell.h"
#import "WriteArtcleViewController.h"
@interface NewHealthHistoryListViewController ()<UITableViewDelegate,UITableViewDataSource,historyCellDelegate>
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * chooseArray;

@end

@implementation NewHealthHistoryListViewController
{
    int page;
    int pageSize;
    NSInteger showIndexPathRow;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    showIndexPathRow = 1000000000;
    self.title = @"历史记录";
    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
    self.navigationItem.rightBarButtonItem = rightitem;

    
    UIView * tisView = [[UIView alloc]initWithFrame: CGRectMake(0, 64, JFA_SCREEN_WIDTH, 70)];
    tisView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tisView];

    UIImageView * imageView = [UIImageView new];
    imageView.frame = CGRectMake(10, 25, 20, 20);
    imageView.image = getImage(@"white!_");
    [tisView addSubview:imageView];
    
    UILabel * tsLabel = [UILabel new];
    tsLabel.text = @"请选择您测量结果中的2条数据,并生成体脂趋势报告分享给好友";
    tsLabel.frame = CGRectMake(40, 10, tisView.frame.size.width-50, 50);
    tsLabel.font = [UIFont systemFontOfSize:14];
    tsLabel.numberOfLines = 2;
    tsLabel.textColor = [UIColor whiteColor];
    [tisView addSubview:tsLabel];
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 69, JFA_SCREEN_WIDTH, 1);
    lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    [tisView addSubview:lineView];
    
    
    pageSize = 30;
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 134, JFA_SCREEN_WIDTH, self.view.frame.size.height-70) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    _infoDict = [NSMutableDictionary dictionary];
    _dataArray = [NSMutableArray array];
    self.chooseArray =[NSMutableArray array];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    

}
-(void)enterRightPage
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction: [UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didShareFriedns:nil];
        
    }]];
    [al addAction: [UIAlertAction actionWithTitle:@"朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didShareVX:nil];
    }]];
    [al addAction: [UIAlertAction actionWithTitle:@"社群" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didShareQQ:nil];
    }]];
    [al addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];

}
-(void)headerRereshing
{
    page = 1;
    [self getShareInfo];
    
}
-(void)footerRereshing
{
    page ++;
    [self getShareInfo];
    
}
-(void)getShareInfo
{
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:@(page) forKey:@"page"];
    [param safeSetObject:@(pageSize) forKey:@"pageSize"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatListNew.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        
        if (page==1) {
            self.tableview.mj_footer.hidden = NO;
            [_dataArray removeAllObjects];
            [_chooseArray removeAllObjects];

        }
        
        NSDictionary * dict =[dic safeObjectForKey:@"data"];
        
        NSArray * arr =[dict safeObjectForKey:@"array"];
        [_dataArray addObjectsFromArray:arr];
        if (arr.count<30) {
            self.tableview.mj_footer.hidden = YES;
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==showIndexPathRow) {
        return 606;
    }
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"HistoryCell";
    HistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    
    if ([dic safeObjectForKey:@"choose"]&&[[dic safeObjectForKey:@"choose"]isEqualToString:@"1"])
    {
        cell.chooseBtn.selected = YES;
    }
    else
    {
        cell.chooseBtn.selected =NO;
    }
    
    if (showIndexPathRow==indexPath.row) {
        [cell setInfoWithDict:dic isHidden:NO];
    }else{
        [cell setInfoWithDict:dic isHidden:YES];
    }
    
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect cell
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    if (indexPath.row ==showIndexPathRow) {
        showIndexPathRow =100000000000;
    }else{
        showIndexPathRow=indexPath.row;
    }
    [self.tableview reloadData];
}
-(void)didDeleteWithCell:(HistoryCell*)cell
{
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认要删除本条记录？" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction: [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * dict = [_dataArray objectAtIndex:cell.tag];
        [self deleteListWithDict:dict IndexPath:cell.tag];

    }]];
    [al addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:al animated:YES completion:nil];
}
///删除
-(void)deleteListWithDict:(NSDictionary *)dict IndexPath:(NSInteger )index
{
    [SVProgressHUD showWithStatus:@"删除中.."];
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:[dict safeObjectForKey:@"DataId"] forKey:@"dataId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/deleteEvaluatData.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [[UserModel shareInstance] showSuccessWithStatus:@"删除成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deletePCINFO" object:nil];
        HistoryCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if ([_chooseArray containsObject:cell]) {
            [_chooseArray removeObject:[_dataArray objectAtIndex:index]];
        }
        [_dataArray removeObjectAtIndex:index];
        // 从列表中删除
        [self.tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];

        
    } failure:^(NSError *error) {
        
    }];

}



#pragma mark ---subView DELEGATE
//-(void)showCellTabWithCell:(HistoryCell*)cell
//{
//    NSMutableDictionary * dic = [_dataArray objectAtIndex:cell.tag];
//    if (!dic) {
//        return;
//    }
//    if (cell.showBtn.selected ==YES) {
//        [dic safeSetObject:@"100" forKey:@"rowHeight"];
//        if ([[dic allKeys]containsObject:@"isSelected"]) {
//            [dic removeObjectForKey:@"isSelected"];
//        }
//    }else{
//        [dic safeSetObject:@"isSelected" forKey:@"isSelected"];
//        [dic safeSetObject:@"700" forKey:@"rowHeight"];
//    }
//    [self.tableview reloadData];
//}
-(void)didChooseWithCell:(HistoryCell *)cell
{
    NSMutableDictionary * dic = [_dataArray objectAtIndex:cell.tag];

    if (cell.chooseBtn.selected==YES) {
        cell.chooseBtn.selected =NO;
        [self.chooseArray removeObject:cell];
        [dic safeSetObject:@"0" forKey:@"choose"];
        
    }else{
        if (self.chooseArray.count<2) {
            cell.chooseBtn.selected = YES;
            [self.chooseArray addObject:cell];
            [dic safeSetObject:@"1" forKey:@"choose"];
        }else{
            [[UserModel shareInstance] showInfoWithStatus:@"最多只能选两条"];
        }
    }

}

#pragma mark ---share
-(UIImage *)showShareView
{
    
    NSString * qrCode = [UserModel shareInstance].qrcodeImageUrl;
    if (!qrCode||qrCode.length<1) {
        [[UserModel shareInstance]getbalance];
    }
    ShareListView * shareTr = [self getXibCellWithTitle:@"ShareListView"];
    HistoryCell * cell1 = [self.chooseArray objectAtIndex:0];
    HistoryCell * cell2 = [self.chooseArray objectAtIndex:1];
    ShareHealthItem * item1 = [self.dataArray objectAtIndex:cell1.tag];
    ShareHealthItem * item2 =[self.dataArray objectAtIndex:cell2.tag];
    NSMutableArray * arr =[NSMutableArray array];
    [arr addObject:item1];
    [arr addObject:item2];
    [shareTr setInfoWithArr:arr];
    [self.view addSubview:shareTr];
    [self.view bringSubviewToFront:shareTr];
    
    
    
    return  [self getImageWithView:shareTr];
    
}
- (void)didShareVX:(id)sender {
    
    if (self.chooseArray.count!=2) {
        [[UserModel shareInstance] showInfoWithStatus:@"请选择两条数据"];
        return ;
    }
    UIImage * image = [self showShareView];
    
    [self shareWithType:SSDKPlatformSubTypeWechatTimeline image:image];
}

- (void)didShareFriedns:(id)sender {
    if (self.chooseArray.count!=2) {
        [[UserModel shareInstance] showInfoWithStatus:@"请选择两条数据"];
        return ;
    }
    UIImage * image = [self showShareView];
    [self shareWithType:SSDKPlatformSubTypeWechatSession image:image];
}

- (void)didShareQQ:(id)sender {
    if (self.chooseArray.count!=2) {
        [[UserModel shareInstance] showInfoWithStatus:@"请选择两条数据"];
        return ;
    }
    UIImage * image = [self showShareView];
    WriteArtcleViewController*postVC = [[WriteArtcleViewController alloc]init];
    postVC.firstImage = image;
    postVC.shareType  =nil;
    postVC.textStr = [NSString stringWithFormat:@"[减脂第%d天]",[UserModel shareInstance].userDays];
    [self.navigationController pushViewController:postVC animated:YES];

}

-(void) shareWithType:(SSDKPlatformType)type image:(UIImage *)image
{
    if (!image) {
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[image];
    
    [shareParams SSDKSetupShareParamsByText:ShareContentInfo
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
