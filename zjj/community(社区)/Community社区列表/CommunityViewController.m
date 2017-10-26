//
//  CommunityViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CommunityViewController.h"
#import "PublicArticleCell.h"
#import "CommunityModel.h"
//#import "PostArticleViewController.h"
#import "WriteArtcleViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "ArticleDetailViewController.h"
#import "CommunityCell.h"
#import "FcBigImgViewController.h"
#import "NewMineHomePageViewController.h"
#import "WriteArtcleViewController.h"
#import "CommunityCell.h"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PublicArticleCellDelegate,BigImageArticleCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;

/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;

@end

@implementation CommunityViewController
{
    int page;
    int pageSize;
    CommunityCell * PlayingCell;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (self.isMyMessagePage==YES) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        self.title = @"我的消息";
        [self setTBWhiteColor];
        self.tabBarController.tabBar.hidden = YES;

    }else{
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        self.tabBarController.tabBar.hidden = NO;

    }

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_playerView destroyPlayer];
    _playerView = nil;
    PlayingCell = nil;
    [self clearSDCeche];



}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView) name:@"SENDARTICLESUCCESS" object:nil];
    [self ChangeMySegmentStyle:self.segment];

    
    if (_isMyMessagePage !=YES) {
        [self buildRightNaviBarItem];
    }
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    pageSize= 30;
    self.segment.selectedSegmentIndex = 1;
    [self.tableview headerBeginRefreshing];
}
-(void)refreshTableView
{
    [self.tableview headerBeginRefreshing];
}
-(void)buildRightNaviBarItem
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings_"] style:UIBarButtonItemStylePlain target:self action:@selector(didEnterWritePage)];
    
    self.navigationItem.rightBarButtonItem = rightItem;

}
- (IBAction)enterWirte:(id)sender {
    [self didEnterWritePage];
}
-(void)didEnterWritePage
{
    WriteArtcleViewController * pr = [[WriteArtcleViewController alloc]init];
//    PostArticleViewController * pr = [[PostArticleViewController alloc]init];
    pr.hidesBottomBarWhenPushed = YES;
    pr.shareType = @"5";
    [self.navigationController pushViewController:pr animated:YES];
}

-(void)headerRereshing
{
    page =1;
    [self getinfo];
}
-(void)footerRereshing
{
    page++;
    [self getinfo];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (IBAction)didEdit:(id)sender {
}
#pragma mark ---newwork requeset  网络请求
-(void)getinfo
{
    NSString * urlStr = @"";
    if (self.isMyMessagePage ==YES) {
        urlStr = @"app/community/articlepage/queryMyMsg.do";
    }else{
    if (self.segment.selectedSegmentIndex ==0) {
        urlStr =@"app/community/articlepage/queryAllArticleByUserId.do";
    }else{
        urlStr =@"app/community/articlepage/queryAllArticle.do";
    }
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    self.currentTasks = [[BaseSservice sharedManager]post1:urlStr paramters:params success:^(NSDictionary *dic) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.tableview setFooterHidden:NO];
        }
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSMutableArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        for (NSMutableDictionary * infoDic in infoArr) {
            CommunityModel * item = [[CommunityModel alloc]init];
            [item setInfoWithDict:infoDic];
            [self.dataArray addObject:item];
        }
        [self.tableview reloadData];
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        if (page ==1) {
            [_dataArray removeAllObjects];
            [self.tableview reloadData];
        }
    }];
}

//关注接口


#pragma mark ---tableview delegate dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
    
    float rowheight = item.rowHieght;
    return rowheight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
    
    
    if (item.pictures.count==1||item.movieStr.length>5) {
        static  NSString * identifier = @"CommunityCell";
        CommunityCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        [cell setInfoWithDict:item];
        
        if (self.segment.selectedSegmentIndex ==0||self.isMyMessagePage==YES||[item.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.gzBtn.hidden = YES;
        }else{
            cell.gzBtn.hidden = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        static  NSString * identifier = @"PublicArticleCell";
        PublicArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        [cell setInfoWithDict:item];
        [cell loadImagesWithItem:item];
        
        if (self.segment.selectedSegmentIndex ==0||self.isMyMessagePage==YES||[item.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.gzBtn.hidden = YES;
        }else{
            cell.gzBtn.hidden = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }

}
//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([PlayingCell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [_playerView destroyPlayer];
        PlayingCell = nil;
    }
}



#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // visibleCells 获取界面上能显示出来了cell
    NSArray<PublicArticleCell *> *array = [self.tableview visibleCells];
    //enumerateObjectsUsingBlock 类似于for，但是比for更快
    [array enumerateObjectsUsingBlock:^(PublicArticleCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj cellOffset];
    }];
}
//#pragma mark - 布局
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//        make.width.equalTo(self.view);
//    }];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self enterDetailPageWithIndex:indexPath.row];
    
}



#pragma mark ---cell delegate

-(void)didGzWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.userId forKey:@"followId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
        model.isFollow = @"1";
        PublicArticleCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
        currCell.gzBtn.selected =YES;
        currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

    } failure:^(NSError *error) {
        
    }];


}
-(void)didZanWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"" forKey:@"commentId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    if (model.isFabulous) {
        [params safeSetObject:@"0" forKey:@"isFabulous"];//1是点赞 0取消
    }else{
        [params safeSetObject:@"1" forKey:@"isFabulous"];//1是点赞 0取消
    }
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];

    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" paramters:params success:^(NSDictionary *dic) {
        if (model.isFabulous&&[model.isFabulous isEqualToString:@"1"]) {
            [[UserModel shareInstance]showSuccessWithStatus:@"取消点赞成功"];
            
        }else{
            [[UserModel shareInstance]showSuccessWithStatus:@"点赞成功"];
            
        }
        [self refreshZanInfoWithCell:cell];
    } failure:^(NSError *error) {
        
    }];

}
-(void)refreshZanInfoWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    if ([model.isFabulous isEqualToString:@"1"]) {
        model.isFabulous = @"0";//1是点赞 0取消
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount-1];
        cell.zanImageView.image = getImage(@"praise");
        cell.zanCountlb.textColor = HEXCOLOR(0x666666);

    }else{
        model.isFabulous = @"1";
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount+1];
        cell.zanImageView.image = getImage(@"praise_Selected");
        cell.zanCountlb.textColor = [UIColor orangeColor];

    }
    
}

-(void)didPLWithCell:(PublicArticleCell*)cell
{
    [self enterDetailPageWithIndex:cell.tag];
//
}
-(void)didShareWithCell:(PublicArticleCell*)cell
{
    [self shareWithIndex:cell.tag];
    
//    /app/community/article/updateForwardingnum.do
//        参数：    id //文章Id
}

-(void)didShowBigImageWithCell:(PublicArticleCell*)cell index:(NSInteger)index
{
    [self showBigImageViewWithIndex:cell.tag page:index];

}
-(void)didJBWithCell:(PublicArticleCell *)cell
{
    [self didJbWithIndex:cell.tag];
}
-(void)didTapHeadImageViewWithCell:(PublicArticleCell *)cell
{
    [self enterUserPageViewWithIndex:cell.tag];
}
-(void)refreshCellRowHeightWithBigCell:(CommunityCell*)cell height:(double)height
{
    
}
-(void)didPlayWithBigCell:(CommunityCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    //记录被点击的Cell
    PlayingCell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, (JFA_SCREEN_WIDTH-40), (JFA_SCREEN_WIDTH-40)*0.6)];
    _playerView = playerView;
    [cell.playerBgView addSubview:_playerView];
    [cell.playerBgView bringSubviewToFront:_playerView];
    //    _playerView.fillMode = ResizeAspectFill;
    
    //视频地址
    _playerView.url = [NSURL URLWithString:model.movieStr];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
        [_playerView destroyPlayer];
        _playerView = nil;
        PlayingCell = nil;

    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        PlayingCell = nil;
        
        NSLog(@"播放完成");
    }];

}
-(void)didGzWithBigCell:(CommunityCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.userId forKey:@"followId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
        model.isFollow = @"1";
        CommunityCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
        currCell.gzBtn.selected =YES;
        currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

    } failure:^(NSError *error) {
        
    }];

}
-(void)didZanWithBigCell:(CommunityCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"" forKey:@"commentId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    if (model.isFabulous) {
        [params safeSetObject:@"0" forKey:@"isFabulous"];//1是点赞 0取消
    }else{
        [params safeSetObject:@"1" forKey:@"isFabulous"];//1是点赞 0取消
    }
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" paramters:params success:^(NSDictionary *dic) {
        if (model.isFabulous&&[model.isFabulous isEqualToString:@"1"]) {
            [[UserModel shareInstance]showSuccessWithStatus:@"取消点赞成功"];
            
        }else{
            [[UserModel shareInstance]showSuccessWithStatus:@"点赞成功"];
            
        }
        [self refreshZanInfoWithBigCell:cell];
    } failure:^(NSError *error) {
        
    }];

}
-(void)refreshZanInfoWithBigCell:(CommunityCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    if ([model.isFabulous isEqualToString:@"1"]) {
        model.isFabulous = @"0";//1是点赞 0取消
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount-1];
        cell.zanImageView.image = getImage(@"praise");
        cell.zanCountlb.textColor = HEXCOLOR(0x666666);

    }else{
        model.isFabulous = @"1";
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount+1];
        cell.zanImageView.image = getImage(@"praise_Selected");
        cell.zanCountlb.textColor = [UIColor orangeColor];
    }
    
}

-(void)didPLWithBigCell:(CommunityCell*)cell
{
    [self enterDetailPageWithIndex:cell.tag];
}
-(void)didShareWithBigCell:(CommunityCell*)cell
{
    [self shareWithIndex:cell.tag];
}
-(void)didShowBigImageWithBigCell:(CommunityCell*)cell index:(NSInteger)index
{
    [self showBigImageViewWithIndex:cell.tag page:index];
}
-(void)didJBWithBigCell:(CommunityCell *)cell
{
    [self didJbWithIndex:cell.tag];
}
-(void)loadImageSuccessWithBigCell:(CommunityCell *)cell
{
    
}
-(void)didTapHeadImageViewWithBigCell:(CommunityCell *)cell
{
    [self enterUserPageViewWithIndex:cell.tag];
}



-(void)enterUserPageViewWithIndex:(NSInteger)index
{
    CommunityModel * model =[_dataArray objectAtIndex:index];
    
    
    NewMineHomePageViewController * mine = [[NewMineHomePageViewController alloc]init];
    mine.userId = model.userId;
    [self.navigationController pushViewController:mine animated:YES];
    
}

-(void)showBigImageViewWithIndex:(NSInteger)index page:(int)page
{
    CommunityModel * item = [_dataArray objectAtIndex:index];
    FcBigImgViewController * fc =[[FcBigImgViewController alloc]init];
    fc.images = [NSMutableArray arrayWithArray:item.pictures];
    fc.page = page;
    
    [self presentViewController:fc animated:YES completion:nil];

}
-(void)didJbWithIndex:(NSInteger)index
{
    ///app/reportArticle/updateIsreported.do
    //参数：    userId //用户Id
    //articleId //文章Id
    //reportContent //举报原因

    CommunityModel * model = [_dataArray objectAtIndex:index];
    
    if ([model.userId isEqualToString:[UserModel shareInstance].userId]) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定要删除此文章吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params safeSetObject:model.uid forKey:@"articleId"];
            [params safeSetObject:alert.textFields.firstObject.text forKey:@"reportContent"];
            [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
            self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/articlepage/deleteArticle.do" paramters:params success:^(NSDictionary *dic) {
                [[UserModel shareInstance]showSuccessWithStatus:@"删除成功"];
                [_dataArray removeObject:model];
                [self.tableview reloadData];
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

        
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"希望您能正确对待社区内容，不要随意举报他人，请确认该用户发表不良信息再进行举报。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *strUrl = [alert.textFields.firstObject.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (strUrl.length<5) {
                [[UserModel shareInstance]showInfoWithStatus:@"举报内容不能小于5个字。"];
                return ;
            }
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params safeSetObject:model.uid forKey:@"articleId"];
            [params safeSetObject:alert.textFields.firstObject.text forKey:@"reportContent"];
            [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
            self.currentTasks =[[BaseSservice sharedManager]post1:@"app/reportArticle/updateIsreported.do" paramters:params success:^(NSDictionary *dic) {
                [[UserModel shareInstance]showSuccessWithStatus:@"您已成功举报"];
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    

}

-(void)enterDetailPageWithIndex:(NSInteger)index
{
    CommunityModel * model = [_dataArray objectAtIndex:index];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    ard.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ard animated:YES];

}



-(void)loadImageSuccessWithCell:(PublicArticleCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    model.loadSuccess = @"1";
}


#pragma  mark -----share

-(void)shareWithIndex:(NSInteger)index
{
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"分享" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline index:index];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession index:index];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ index:index];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];

}

-(void) shareWithType:(SSDKPlatformType)type index:(NSInteger)index
{
    CommunityModel * model = [_dataArray objectAtIndex:index];
    NSString * title  = [NSString stringWithFormat:@"%@发表的文章",model.title];
    NSString * content = model.content;
    if (content.length>100) {
        content = [content substringToIndex:100];
    }
    NSMutableDictionary * params  =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/shareArticleLink.do" paramters:params success:^(NSDictionary *dic) {
        
        NSString * shareUrl = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"url"];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (type ==SSDKPlatformSubTypeWechatTimeline||type==SSDKPlatformSubTypeWechatSession) {
            [shareParams SSDKSetupWeChatParamsByText:content title:title url:[NSURL URLWithString:shareUrl] thumbImage:[UserModel shareInstance].headUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
            
        }else if (type==SSDKPlatformTypeQQ)
        {
            [shareParams SSDKSetupShareParamsByText:content
                                             images:[UserModel shareInstance].headUrl
                                                url:[NSURL URLWithString:shareUrl]
                                              title:title
                                               type:SSDKContentTypeWebPage];
            
        }
        
        
        
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
                     
                     [[UserModel shareInstance]didCompleteTheTaskWithId:@"4"];
                     
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     [[UserModel shareInstance]dismiss];
                     //                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                     DLog(@"error-%@",error);
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
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)clearSDCeche
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}



- (IBAction)didClickSegment:(UISegmentedControl *)sender {
    
    [self.tableview headerBeginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearSDCeche];
    
    // Dispose of any resources that can be recreated.
}

@end
