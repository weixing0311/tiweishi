//
//  ArticleDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArtcleDetailTextCell.h"
#import "ArtcleDetaileImageCell.h"
#import "ArtcleDetailCommentCell.h"
#import "CommentView.h"
#import "SDImageCache.h"
#import "FcBigImgViewController.h"
#import "PublicArticleCell.h"
#import "ArtcleDetailNumCell.h"
#import "CommunityCell.h"
#import "ArtcleZanViewController.h"
#import "GuanzModel.h"
@interface ArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,commentViewDelegate,ArtcleDetailCommentDelegate,UIPickerViewDelegate,UIPickerViewDataSource,PublicArticleCellDelegate,BigImageArticleCellDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic,strong) NSMutableArray * zanCountArray;
@property (nonatomic,strong) NSMutableDictionary * infoDict;;
@property (nonatomic, weak) CLPlayerView *playerView;
@end

@implementation ArticleDetailViewController
{
    CommentView * commentView;
    UIView * zzView;
    int page;
    int pageSize;
    CommunityCell * PlayingCell;
    NSString * gzStatus;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setTBWhiteColor];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_playerView destroyPlayer];
    _playerView = nil;
    [self clearSDCeche];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([gzStatus isEqualToString:@"999"]) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(refreshGzStatusWithModel:isFollow:)]) {
            [self.delegate refreshGzStatusWithModel:_dataArray[0]isFollow:gzStatus];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    [self setNotification];
    page =1;
    gzStatus =@"999";//是否点击过关注的状态
    _dataArray = [NSMutableArray array];
    _commentArray =[NSMutableArray array];
    _infoDict =[NSMutableDictionary dictionary];
    _zanCountArray =[NSMutableArray array];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-60) style:UITableViewStylePlain];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
//    [self setRefrshWithTableView:self.tableview];
    [self buildCommentView];
    [self getCommentList];
    

    // Do any additional setup after loading the view from its nib.
}





-(void)buildCommentView
{
    
    
    commentView = [self getXibCellWithTitle:@"CommentView"];
    commentView.frame = CGRectMake(0,JFA_SCREEN_HEIGHT-60, JFA_SCREEN_WIDTH, 60);
    commentView.delegate  = self;
    [self.view addSubview:commentView];
}
#pragma mark
#pragma mark keyboardWillShow
- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)closeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    // 键盘弹出和收回的时间
    CGFloat duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 键盘初始时刻的frame
    CGRect beginKeyboardRect = [[dict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // 键盘停止后的frame
    CGRect endKeyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 相减为键盘高度
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    // 根据yOffset判断键盘是弹出还是收回
    if (yOffset < 0) {
        // 键盘弹出,改变当前Controller的view的frame
        [UIView animateWithDuration:duration animations:^{
            commentView.frame = CGRectMake(0, JFA_SCREEN_HEIGHT-endKeyboardRect.size.height-60, JFA_SCREEN_WIDTH, 60);
        }];
        if (!zzView) {
            zzView = [[UIView alloc]init];
            [zzView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenMe)]];
            zzView.backgroundColor = [UIColor clearColor];

            [self.view addSubview:zzView];

        }
        zzView.hidden = NO;
        zzView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH, commentView.frame.origin.y);
    } else {
        // 键盘收回,把view的frame恢复原状
        [UIView animateWithDuration:duration animations:^{
            commentView.frame = CGRectMake(0, JFA_SCREEN_HEIGHT-60, JFA_SCREEN_WIDTH, 60);
        }];
        [self hiddenMe];
    }
}

#pragma mark ---接口



-(void)getCommentList//评论列表
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //page pagesize articleId userid
    [params safeSetObject:@"30" forKey:@"pageSize"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:self.infoModel.uid forKey:@"articleId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlecomment/queryArticlecomment.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        if (page==1) {
            [self.dataArray removeAllObjects];
            [self.commentArray removeAllObjects];
        }

        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        _infoDict = [dataDict safeObjectForKey:@"article"];
        
        [self getZanPersonInfo];
        CommunityModel * item = [[CommunityModel alloc]init];
        [item setInfoWithDict:_infoDict];
        [self.dataArray addObject:item];

        
        _commentArray = [dataDict safeObjectForKey:@"array"];
        
        
        [self.tableview reloadData];

    } failure:^(NSError *error) {
        
    }];

}
-(void)getCommentInfoWithComment:(NSString *)commentStr//评论接口
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //articleId userId content
    [params safeSetObject:commentStr forKey:@"content"];
    [params safeSetObject:self.infoModel.uid forKey:@"articleId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlecomment/saveArticlecomment.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [commentView.commentTf resignFirstResponder];
        commentView.commentTf.text = @"";
        [[UserModel shareInstance]showSuccessWithStatus:@"发表成功"];
        
        
        [self getCommentList];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(refreshCommentWithModel:)]) {
            [self.delegate refreshCommentWithModel:self.infoModel];
        }
//        NSMutableDictionary * infoDict =[NSMutableDictionary dictionary];
//        [infoDict safeSetObject:[UserModel shareInstance].headUrl forKey:@"headimgurl"];
//        [infoDict safeSetObject:[UserModel shareInstance].nickName forKey:@"nickName"];
//        [infoDict safeSetObject:commentStr forKey:@"content"];
//        [infoDict safeSetObject:@"0" forKey:@"greatnum"];
//        [infoDict safeSetObject:@"0" forKey:@"createTime"];

        
    } failure:^(NSError *error) {
        
    }];
}

///获取点赞人信息
-(void)getZanPersonInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:[_infoDict safeObjectForKey:@"id"] forKey:@"articleId"];
    [param safeSetObject:@"1" forKey:@"page"];
    [param safeSetObject:@"15" forKey:@"pageSize"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/queryGreatPerson.do" HiddenProgress:YES paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        
        for (NSDictionary *dic in infoArr) {
            GuanzModel * model = [[GuanzModel alloc]init];
            [model setGzInfoWithDict:dic];
            [_zanCountArray addObject:model];
        }
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _dataArray.count;
            break;
        case 1:
            return 1;
            break;
        default:
            return _commentArray.count;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0)
    {
        CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
        
        float rowheight = item.rowHieght;
        return rowheight;
    }
    else if (indexPath.section ==1)
    {
        
        return 88;
    }
    else
    {
        NSDictionary *dic =[_commentArray objectAtIndex:indexPath.row];
        NSString * contentStr = [dic safeObjectForKey:@"content"];
        return 80+[self getContentHeightWithContent:contentStr Font:14];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        CommunityModel * item = [_dataArray objectAtIndex:indexPath.row];
        
        if (item.movieImageStr.length>5||item.pictures.count==1) {
            static  NSString * identifier = @"CommunityCell";
            CommunityCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [self getXibCellWithTitle:identifier];
            }
            cell.delegate = self;
            cell.tag = indexPath.row;
            [cell setInfoWithDict:item];
            
            cell.nemuView.hidden = YES;
//            cell.gzBtn.hidden = YES;
//            cell.jbBtn.hidden = YES;
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
            cell.nemuView.hidden = YES;
//            cell.gzBtn.hidden = YES;
//            cell.jbBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
        
    }
    else if (indexPath.section ==1)
    {
        static NSString * identifer = @"ArtcleDetailNumCell";
        ArtcleDetailNumCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifer];
        }
        
        cell.firstLb.text = [NSString stringWithFormat:@"评论 %@",[_infoDict safeObjectForKey:@"commentnum"]?[_infoDict safeObjectForKey:@"commentnum"]:@"0"];
        
        
        NSString * ZanName ;
        int zanCount = [[_infoDict safeObjectForKey:@"greatnum"]intValue];

        if (self.zanCountArray.count<1||!self.zanCountArray) {
            ZanName = @"暂时还没有人点赞";
            cell.zanLabel.text = [NSString stringWithFormat:@"%@",ZanName];
        }
        else if (self.zanCountArray.count<4) {
            for (int i =0; i<self.zanCountArray.count; i++) {
                GuanzModel * model = [self.zanCountArray objectAtIndex:i];
                ZanName =[NSString stringWithFormat:@"%@%@",ZanName?[NSString stringWithFormat:@"%@、",ZanName]:@"",model.nickname];
            }
            cell.zanLabel.text = [NSString stringWithFormat:@"%@赞了%d次",ZanName,zanCount];

        }else{
            GuanzModel * model1 = [self.zanCountArray objectAtIndex:0];
            GuanzModel * model2 = [self.zanCountArray objectAtIndex:1];
            GuanzModel * model3 = [self.zanCountArray objectAtIndex:2];
            GuanzModel * model4 = [self.zanCountArray objectAtIndex:2];

            ZanName =[NSString stringWithFormat:@"%@、%@、%@、%@...",model1.nickname,model2.nickname,model3.nickname,model4.nickname];
            cell.zanLabel.text = [NSString stringWithFormat:@"%@",ZanName];

        }

        
        if (zanCount<4) {
            cell.zanCountLb.text = @"";
        }else{
            cell.zanCountLb.text = [NSString stringWithFormat:@"共赞了%d次",zanCount];
        }
        
        
        [cell.zanBtn addTarget:self action:@selector(showZanPersons) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        static NSString * identifer = @"ArtcleDetailCommentCell";
        ArtcleDetailCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifer];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        NSDictionary * dict = [_commentArray objectAtIndex:indexPath.row];
        
        [cell.headImgBtn sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")options:SDWebImageRetryFailed];
        
        cell.nicknamelb.text = [dict safeObjectForKey:@"nickName"];
        cell.timelb.text = [dict safeObjectForKey:@"createTime"];
        cell.contentlb.text = [dict safeObjectForKey:@"content"];
        cell.zanCountlb.text = [dict safeObjectForKey:@"greatnum"];
        cell.levelLb.text = [dict safeObjectForKey:@"gradeId"];
        if ([dict safeObjectForKey:@"isFabulous"]) {
            cell.zanImageView.image = getImage(@"praise_Selected");
        }else{
            cell.zanImageView.image = getImage(@"praise");
        }
        return cell;
  
    }
    
}
-(void)showZanPersons
{
    ArtcleZanViewController * artcl = [[ArtcleZanViewController alloc]init];
    artcl.articleId = [_infoDict safeObjectForKey:@"id"];
    [self.navigationController pushViewController:artcl animated:YES];
}
-(void)didPlayWithBigCell:(CommunityCell *)cell
{
    NSString * videoPath = [_infoDict safeObjectForKey:@"videoPath"];
        //销毁播放器
        [_playerView destroyPlayer];
        CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0,0, (JFA_SCREEN_WIDTH-40), (JFA_SCREEN_WIDTH-40)*0.6)];
        _playerView = playerView;
    [cell.playerBgView addSubview:_playerView];
    [cell.playerBgView bringSubviewToFront:_playerView];
        //视频地址
        _playerView.url = [NSURL URLWithString:videoPath];
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
            _playerView = nil;
            
            NSLog(@"播放完成");
        }];
}

-(void)didShowBigImageWithCell:(PublicArticleCell*)cell index:(NSInteger)index
{
    [self showBigImageViewWithIndex:cell.tag page:index];
    
}
-(void)didShowBigImageWithBigCell:(CommunityCell*)cell index:(NSInteger)index
{
    [self showBigImageViewWithIndex:cell.tag page:index];
}
-(void)showBigImageViewWithIndex:(NSInteger)index page:(int)page
{
    CommunityModel * item = [_dataArray objectAtIndex:index];
    FcBigImgViewController * fc =[[FcBigImgViewController alloc]init];
    fc.images = [NSMutableArray arrayWithArray:item.pictures];
    fc.page = page;
    [self presentViewController:fc animated:YES completion:nil];

}



-(double)getContentHeightWithContent:(NSString *)contentStr Font:(int)ft
{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    
    UIFont *font = [UIFont systemFontOfSize:ft];
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};
    
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(JFA_SCREEN_WIDTH-20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;

}
#pragma mark ---上传评论
-(void)didSendCommentWithText:(NSString *)textStr
{
    
    NSString *strUrl = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (strUrl.length>0) {
        [self getCommentInfoWithComment:textStr];
  
    }else{
        [[UserModel shareInstance]showInfoWithStatus:@"不能发送空评论"];
    }
}
#pragma mark ---cellDelegate
-(void)didZanCommentWithCell:(ArtcleDetailCommentCell*)cell
{
    NSMutableDictionary * dic =[_commentArray objectAtIndex:cell.tag];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[dic safeObjectForKey:@"id"] forKey:@"commentId"];
    [params safeSetObject:@"" forKey:@"articleId"];
    if ([dic safeObjectForKey:@"isFabulous"]) {
        [params safeSetObject:@"0" forKey:@"isFabulous"];//1是点赞 0取消
    }else{
        [params safeSetObject:@"1" forKey:@"isFabulous"];//1是点赞 0取消
    }
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@""];
        [self refreshZanInfoWithCell:cell];
    } failure:^(NSError *error) {
        
    }];
}

-(void)refreshZanInfoWithCell:(ArtcleDetailCommentCell*)cell
{
    NSMutableDictionary * weakDict = [_commentArray objectAtIndex:cell.tag];
    if ([[weakDict allKeys]containsObject:@"isFabulous"]&& [[weakDict safeObjectForKey:@"isFabulous"]isEqualToString:@"1"]) {
        [weakDict removeObjectForKey:@"isFabulous"];//1是点赞 0取消
        cell.zanImageView.image = getImage(@"praise");

        if ([cell.zanCountlb.text isEqualToString:@"0"]) {
            return;
        }
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount-1];
        
    }else{
        [weakDict safeSetObject:@"1" forKey:@"isFabulous"];//1是点赞 0取消
        cell.zanImageView.image = getImage(@"praise_Selected");
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount+1];

    }

}


-(void)didGzWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    if (cell.gzBtn.selected==YES) {
        [SVProgressHUD showWithStatus:@"修改中"];
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:model.userId forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            
            model.isFollow = @"0";
            gzStatus =@"0";
            PublicArticleCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
            [[UserModel shareInstance]showSuccessWithStatus: @"取消关注成功"];
            
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        [SVProgressHUD showWithStatus:@"修改中"];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params safeSetObject:model.userId forKey:@"followId"];
        [params safeSetObject:model.uid forKey:@"articleId"];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/attentUser.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
            [[UserModel shareInstance]showSuccessWithStatus:@"关注成功"];
            model.isFollow = @"1";
            gzStatus =@"1";
            PublicArticleCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
            [self.tableview reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
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
            gzStatus =0;
            CommunityCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
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
            gzStatus =@"1";
            CommunityCell * currCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0]];
            currCell.gzBtn.selected =YES;
            currCell.gzBtn.layer.borderColor = HEXCOLOR(0x666666).CGColor;
            
            [self.tableview reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark---举报
-(void)didJBWithCell:(PublicArticleCell *)cell
{
    [self didJbWithIndex:cell.tag];
}
-(void)didJBWithBigCell:(CommunityCell *)cell
{
    [self didJbWithIndex:cell.tag];
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

-(void)clearSDCeche
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}
-(void)hiddenMe
{
    if ( zzView) {
        zzView.hidden = YES;
        [commentView.commentTf resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearSDCeche];
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
