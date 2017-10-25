//
//  NewHealthHistoryListViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthHistoryListViewController.h"
#import "HistoryBigCell.h"
#import "NSDate+CustomDate.h"
#import "Daysquare.h"
#import "ShareHealthItem.h"
#import "HistoryBigCell.h"
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import "ShareListView.h"
#import "HistoryCell.h"
#import "WriteArtcleViewController.h"
@interface NewHealthHistoryListViewController ()<UITableViewDelegate,UITableViewDataSource,historySectionCellDelegate,historyCellDelegate>
@property (weak,  nonatomic) IBOutlet UIView *rlView;
@property (strong,  nonatomic)  UITableView *tableview;
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * chooseArray;

@end

@implementation NewHealthHistoryListViewController
{
    int page;
    int pageSize;
    NSMutableDictionary * selectedIndexes;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    selectedIndexes = [NSMutableDictionary dictionary];
    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithImage:getImage(@"share_") style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
    self.navigationItem.rightBarButtonItem = rightitem;

    
    
    pageSize = 30;
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
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
    [al addAction: [UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatListNew.do" paramters:param success:^(NSDictionary *dic) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
        if (page==1) {
            self.tableview.footerHidden = NO;
            [_dataArray removeAllObjects];
            [_chooseArray removeAllObjects];

        }
        
        NSDictionary * dict =[dic safeObjectForKey:@"data"];
        
        NSArray * arr =[dict safeObjectForKey:@"array"];
        [_dataArray addObjectsFromArray:arr];
        if (arr.count<30) {
            self.tableview.footerHidden = YES;
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self cellIsSelected:indexPath]) {
        return 700;
    }
    // Cell isn't selected so return single height
    return 100;
}

//    NSDictionary * dic =[_dataArray objectAtIndex:indexPath.row];
//    NSString *rowHeight = [dic safeObjectForKey:@"rowHeight"];
//    if (rowHeight) {
//        return  [rowHeight intValue];
//    }else{
//        return 100;
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * identifier = @"HistoryBigCell";
//    HistoryBigCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [self getXibCellWithTitle:identifier];
//    }
//    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
//    for (HistoryBigCell * chooseCell in _chooseArray) {
//        if (chooseCell.tag ==indexPath.row) {
//            cell.chooseBtn.selected = YES;
//        }else{
//            cell.chooseBtn.selected = NO;
//        }
//    }
//    cell.delegate = self;
//    [cell setInfoWithDict:dic];
    static NSString * identifier = @"HistoryCell";
    HistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    for (HistoryBigCell * chooseCell in _chooseArray) {
        if (chooseCell.tag ==indexPath.row) {
            cell.chooseBtn.selected = YES;
        }else{
            cell.chooseBtn.selected = NO;
        }
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInfoWithDict:dic];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect cell
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];

    HistoryCell * cell = [self.tableview cellForRowAtIndexPath:indexPath];
    // Toggle 'selected' state
    BOOL isSelected = ![self cellIsSelected:indexPath];
    
    if (isSelected==YES) {
        cell.infoView.hidden = NO;
    }else{
        cell.infoView.hidden = YES;

    }
    
    
    // Store cell 'selected' state keyed on indexPath
    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
    [selectedIndexes removeAllObjects];
    [selectedIndexes setObject:selectedIndex forKey:indexPath];
    
    
    // This is where magic happens...
    
    [self.tableview beginUpdates];
    [self.tableview endUpdates];
    
}
- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
    // Return whether the cell at the specified index path is selected or not
    NSNumber*selectedIndex = [selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

#pragma mark ---subView DELEGATE
-(void)showCellTabWithCell:(HistoryCell*)cell
{
    NSMutableDictionary * dic = [_dataArray objectAtIndex:cell.tag];
    if (!dic) {
        return;
    }
    if (cell.showBtn.selected ==YES) {
        [dic safeSetObject:@"100" forKey:@"rowHeight"];
        if ([[dic allKeys]containsObject:@"isSelected"]) {
            [dic removeObjectForKey:@"isSelected"];
        }
    }else{
        [dic safeSetObject:@"isSelected" forKey:@"isSelected"];
        [dic safeSetObject:@"700" forKey:@"rowHeight"];
    }
    [self.tableview reloadData];
}
-(void)didChooseWithCell:(HistoryCell *)cell
{
    if (cell.chooseBtn.selected==YES) {
        cell.chooseBtn.selected =NO;
        [self.chooseArray removeObject:cell];
    }else{
        if (self.chooseArray.count<2) {
            cell.chooseBtn.selected = YES;
            [self.chooseArray addObject:cell];
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
    
    HistoryBigCell * cell1 = [self.chooseArray objectAtIndex:0];
    HistoryBigCell * cell2 = [self.chooseArray objectAtIndex:1];
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
    postVC.shareType  =0;
    [self.navigationController pushViewController:postVC animated:YES];

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
