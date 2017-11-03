//
//  NewMineHomePageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineHomePageViewController.h"
#import "PublicArticleCell.h"
#import "NewMineHomePageCell.h"
#import "CommunityModel.h"
//#import "PostArticleViewController.h"
#import "WriteArtcleViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"
#import "Masonry.h"
#import "EditUserInfoImageCell.h"
#import "ArticleDetailViewController.h"
#import "EditUserInfoViewController.h"
#import "BeforeAfterContrastCell.h"
#import "FcBigImgViewController.h"
#import "CommunityCell.h"
@interface NewMineHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,PublicArticleCellDelegate,NewMineHomePageHeaderCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BigImageArticleCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, weak) CLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@end

@implementation NewMineHomePageViewController
{
    int page;
    int pageSize;
    CommunityCell * PlayingCell;
    int changeImageNum;
    
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self.tableview headerBeginRefreshing];
    [self setTBWhiteColor];


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
    self.title = @" ";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyInfo) name:@"refreshHomePageInfo" object:nil];
    if (![self.userId isEqualToString:[UserModel shareInstance].userId]) {
        self.shareBtn.hidden = YES;
    }else{
        self.shareBtn.hidden = NO;
    }
    self.tableview.delegate=self;
    self.tableview.dataSource= self;
    pageSize = 30;
    self.dataArray = [NSMutableArray array];
    self.infoDict = [NSMutableDictionary dictionary];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
}
-(void)refreshMyInfo
{
    [self.tableview headerBeginRefreshing];
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

-(void)getinfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.userId forKey:@"userId"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/queryUserHome.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.tableview setFooterHidden:NO];
            
        }
        
        
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        self.infoDict = [dataDic safeObjectForKey:@"article"];
        
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
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
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * fatBefore =[_infoDict safeObjectForKey:@"fatBefore"];

    if (indexPath.section ==0) {
        return JFA_SCREEN_WIDTH*0.56;
    }
    else if(indexPath.section ==1)
    {
        return 130;
    }
    else if(indexPath.section==2)
    {
        return JFA_SCREEN_WIDTH*0.7;
    }

    else
    {
        CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
        float rowheight = item.rowHieght;
        return rowheight;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * fatBefore =[_infoDict safeObjectForKey:@"fatBefore"];
    
    if (section ==0) {
        return 1;
    }
    else if(section ==1)
    {
        return 1;
    }
    else if(section==2)
    {
        return 1;
    }
    else
    {
        return self.dataArray.count;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0||section ==1) {
        return 1;
    }
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"NewMineHomePageCell";
        NewMineHomePageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.height/2;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal placeholderImage:getImage(@"defaultHead")
         ];
        
        
//        [cell.bgImageView getImageWithUrl:[_infoDict safeObjectForKey:@"backGroundImg"] getImageFinish:^(UIImage *image, NSError *error) {
//            cell.bgImageView.image = image;
//        }];
        
        
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"backGroundImg"]] placeholderImage:getImage(@"newMineBg_") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                return ;
            }
            cell.bgImageView.image = [self cutImage:image imgViewWidth:image.size.width imgViewHeight:image.size.width*0.56];
        }];
                
        
        cell.nicknamelb.text = [_infoDict safeObjectForKey:@"nickName"];
        NSString * introduction = [_infoDict safeObjectForKey:@"introduction"];
        if (introduction.length<1) {
            cell.jjlb.text = @"还没有编辑简介~";
        }else{
            cell.jjlb.text = [NSString stringWithFormat:@"简介：%@",introduction];
        }
        int  sex = [UserModel shareInstance].gender;
        if (sex ==1) {
            cell.sexImageView.image = getImage(@"man_");
            
        }else{
            cell.sexImageView.image =getImage(@"woman_");
        }
        
        if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.gzBtn.hidden = YES;
        }else{
            cell.gzBtn.hidden = NO;
            
            if ([[_infoDict safeObjectForKey:@"isFollow"]isEqualToString:@"1"]) {
                cell.gzBtn.selected = YES;
            }else{
                cell.gzBtn.selected = NO;
            }            
        }
        
        return cell;
    }
    
    else if(indexPath.section ==1)
    {
        static NSString * identifier = @"BeforeAfterContrastCell";
        BeforeAfterContrastCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.beforeWeightlb.text = [NSString stringWithFormat:@"%.1fkg",[[_infoDict safeObjectForKey:@"beforeWeight"] floatValue]];
        cell.afterweightlb.text = [NSString stringWithFormat:@"%.1fkg",[[_infoDict safeObjectForKey:@"afterWeight"] floatValue]];
        cell.continuousDatelb.text = [NSString stringWithFormat:@"%@",[_infoDict safeObjectForKey:@"registerDate"]?[_infoDict safeObjectForKey:@"registerDate"]:@"0"];
        
        double befortWeight =[[_infoDict safeObjectForKey:@"beforeWeight"]doubleValue];
        double afterWeight =[[_infoDict safeObjectForKey:@"afterWeight"]doubleValue];

        
        float lossWeight  = befortWeight-afterWeight;
        
        if (lossWeight>0) {
            cell.afterweightlb.textColor = [UIColor greenColor];
        }else{
            cell.afterweightlb.textColor = [UIColor orangeColor];
        }
        cell.lossWeightlb.text = [NSString stringWithFormat:@"%.0f",lossWeight>0?lossWeight:0];

        return cell;
    }
    else if(indexPath.section ==2)
    {
        static NSString * identifier = @"EditUserInfoImageCell";
        EditUserInfoImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.fatBeforeImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatBefore"]] placeholderImage:getImage(@"fatBefore_") options:SDWebImageRetryFailed];
        [cell.fatAfterImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatAfter"]] placeholderImage:getImage(@"fatBefore_") options:SDWebImageRetryFailed];

        
//        [cell.fatBeforeBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatBefore"]] placeholderImage:getImage(@"fatBefore_")];
//        [cell.fatAfterBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatAfter"]] placeholderImage:getImage(@"fatAfter_")];
        
        return cell;
        
    }
    else
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
            
            if ([item.userId isEqualToString:[UserModel shareInstance].userId]) {
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
            
            if ([item.userId isEqualToString:[UserModel shareInstance].userId]) {
                cell.gzBtn.hidden = YES;
            }else{
                cell.gzBtn.hidden = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }

    }
}
//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if (indexPath.section ==1) {
        if ([PlayingCell isEqual:cell]) {
            //区分是否是播放器所在cell,销毁时将指针置空
            [_playerView destroyPlayer];
            PlayingCell = nil;
        }

    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return @"";
    }
    else if (section==1)
    {
        return @"";
    }else if(section ==2){
        return @"减脂前后";
    }else{
        return @"最新状态";

    }

}
#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // visibleCells 获取界面上能显示出来了cell
    NSArray<PublicArticleCell *> *array = [self.tableview visibleCells];
    //enumerateObjectsUsingBlock 类似于for，但是比for更快
    [array enumerateObjectsUsingBlock:^(PublicArticleCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [obj cellOffset];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==3){
    CommunityModel * model = [_dataArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    [self.navigationController pushViewController:ard animated:YES];
    }
    else if(indexPath.section ==2)
    {
        [self didShowChangeUserInfoPage];
    }
}



#pragma mark ---cell delegate

-(void)didPlayWithCell:(PublicArticleCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    //记录被点击的Cell
    PlayingCell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, (JFA_SCREEN_WIDTH-20), (JFA_SCREEN_WIDTH-20)*0.7)];
    _playerView = playerView;
    [cell.collectionView addSubview:_playerView];
    //    _playerView.fillMode = ResizeAspectFill;
    
    //视频地址
    _playerView.url = [NSURL URLWithString:model.movieStr];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
//        PlayingCell.playerBtn.hidden = NO;
        _playerView = nil;
        PlayingCell = nil;
        
        NSLog(@"播放完成");
    }];
    
}

- (IBAction)didClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didClickShare:(id)sender {
    
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"分享" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];
}

#pragma  mark ---cell delegate
-(void)didShowChangeUserInfoPage
{
    
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
        EditUserInfoViewController * edit =[[EditUserInfoViewController alloc]init];
        edit.infoDict = self.infoDict;

         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"userId"] forKey:@"userId"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"heigth"] forKey:@"heigth"];
         [edit.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];
        [self.navigationController pushViewController:edit animated:YES];
    }
}
-(void)didChangeHeaderImage
{
    
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
        [self didShowChangeUserInfoPage];
    }
}
-(void)changeBgImageView
{
    if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
        changeImageNum =2;
        [self ChangeHeadImageWithTitle:@"更换背景"];

    }
//    app/user/uploadBackGroundImg.do   userId   imgurl
}
-(void)didShareMyInfo
{
    
}
-(void)didGzWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];

    [SVProgressHUD showWithStatus:@"修改中"];
    if (cell.gzBtn.selected==YES) {
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:model.userId forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            
            model.isFollow = @"0";
            PublicArticleCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
            if (_dataArray.count>100) {
                return ;
            }
            for (CommunityModel * allmodel  in _dataArray) {
                if ([allmodel.userId isEqualToString:model.userId]) {
                    allmodel.isFollow = @"0";
                }
            }
            [[UserModel shareInstance]showSuccessWithStatus: @"取消关注成功"];
            
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.userId forKey:@"followId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
        model.isFollow = @"1";
        PublicArticleCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
        currCell.gzBtn.selected =YES;
        currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

    } failure:^(NSError *error) {
        
    }];
    
    }
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
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
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
    [SVProgressHUD showWithStatus:@"修改中。。。"];
    if (cell.gzBtn.selected==YES) {
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:model.userId forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            
            model.isFollow = @"0";
            CommunityCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
            if (_dataArray.count>100) {
                return ;
            }
            for (CommunityModel * allmodel  in _dataArray) {
                if ([allmodel.userId isEqualToString:model.userId]) {
                    allmodel.isFollow = @"0";
                }
            }
            [[UserModel shareInstance]showSuccessWithStatus: @"取消关注成功"];
            
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.userId forKey:@"followId"];
    [params safeSetObject:model.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
        model.isFollow = @"1";
        CommunityCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
        currCell.gzBtn.selected =YES;
        currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;

    } failure:^(NSError *error) {
        
    }];
    }
    
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
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
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
            self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/articlepage/deleteArticle.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
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
            self.currentTasks =[[BaseSservice sharedManager]post1:@"app/reportArticle/updateIsreported.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
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
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/shareArticleLink.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
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
                     //                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                     [[UserModel shareInstance]didCompleteTheTaskWithId:@"5"];
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

-(void)didGzUserWithCell:(NewMineHomePageCell *)cell
{
    if (cell.gzBtn.selected ==YES) {
        [self cancelGzWithId:[_infoDict safeObjectForKey:@"userId"] cell:cell];
    }else{
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:[_infoDict safeObjectForKey:@"userId"] forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/followUser.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            DLog(@"dic-关注成功--%@",dic);
            cell.gzBtn.selected = YES;
            [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
            [self.tableview headerBeginRefreshing];
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)cancelGzWithId:(NSString * )followId cell:(NewMineHomePageCell*)cell
{
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"确定不在关注此人吗？" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [al addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:followId forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            DLog(@"dic-取消关注成功--%@",dic);
            cell.gzBtn.selected = YES;
            [[UserModel shareInstance]showSuccessWithStatus: @"取消成功"];
            [self.tableview headerBeginRefreshing];

        } failure:^(NSError *error) {
            
        }];
    }]];
    [self presentViewController:al animated:YES completion:nil];
}


- (void)ChangeHeadImageWithTitle:(NSString *)title{
    
    
    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    
    [al addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
    
}
#pragma mark ----imagepickerdelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image =info[UIImagePickerControllerOriginalImage];
        [image scaledToSize:CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/image.size.width*image.size.height)];
        
        [self dismissViewControllerAnimated:YES completion:nil];

        if (changeImageNum ==1) {
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.001);
            [self updateImageWithImage:fileDate];
            
        }else if(changeImageNum ==2){
            NSData *  fileDate = UIImageJPEGRepresentation(image, 0.1);

            [self updateBGImageWithImage:fileDate];
            
        }
        
    }
}//点击cancel 调用的方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateImageWithImage:(NSData *)fileData
{
    
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/uploadHeadImg.do" paramters:param imageData:fileData imageName:@"headimgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] setHeadImageUrl: [[dic objectForKey:@"data"]objectForKey:@"headimgurl"]];
        [self.tableview reloadData];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];
}


#pragma  mark --上传背景图
-(void)updateBGImageWithImage:(NSData *)fileData
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/user/uploadBackGroundImg.do" paramters:param imageData:fileData imageName:@"imgurl" success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableview headerBeginRefreshing];
        });

        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];
}

-(void) shareWithType:(SSDKPlatformType)type
{
    
    
    NSMutableDictionary * params  =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/shareHomeLink.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        NSString * shareUrl = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"url"];
        
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (type ==SSDKPlatformSubTypeWechatTimeline||type==SSDKPlatformSubTypeWechatSession) {
            [shareParams SSDKSetupWeChatParamsByText:ShareContentInfo title:[NSString stringWithFormat:@"%@的个人主页",[UserModel shareInstance].nickName] url:[NSURL URLWithString:shareUrl] thumbImage:[UserModel shareInstance].headUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
            
        }else if (type==SSDKPlatformTypeQQ)
        {
            [shareParams SSDKSetupShareParamsByText:ShareContentInfo
                                             images:[UserModel shareInstance].headUrl
                                                url:[NSURL URLWithString:shareUrl]
                                              title:[UserModel shareInstance].nickName
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
#ifdef DEBUG
                   [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
#endif
                 [[UserModel shareInstance]didCompleteTheTaskWithId:@"7"];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     [[UserModel shareInstance]dismiss];
#ifdef DEBUG
                     [[UserModel shareInstance] showErrorWithStatus:@"error"];
#endif
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
///完成获取积分任务--- 分享主页 分享健康报告
-(void)getIntegral
{
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:@"7" forKey:@"taskId"];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        } failure:^(NSError *error) {
            
        }];
}


- (UIImage *)cutImage:(UIImage*)image imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height

{
    
    //压缩图片
    
    
    
    CGSize newSize;
    
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (width / height)) {
        
        newSize.width = image.size.width;
        
        newSize.height = image.size.width * height /width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, newSize.width, newSize.height));
        
    } else {
        
        newSize.height = image.size.height;
        
        newSize.width = image.size.height * width / height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
    
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

/*
 * 清理sd_webImage缓存
 **/
-(void)clearSDCeche
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearSDCeche];
    // Dispose of any resources that can be recreated.
}






@end
