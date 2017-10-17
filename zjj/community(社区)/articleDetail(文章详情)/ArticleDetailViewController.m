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
@interface ArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,commentViewDelegate,ArtcleDetailCommentDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic,strong) NSMutableDictionary * infoDict;;
@property (nonatomic, weak) CLPlayerView *playerView;
@end

@implementation ArticleDetailViewController
{
    CommentView * commentView;
    UIView * zzView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_playerView destroyPlayer];
    _playerView = nil;
    [self clearSDCeche];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章详情";
    [self setTBWhiteColor];
    [self setNotification];
    
    _dataArray = [NSMutableArray array];
    _commentArray =[NSMutableArray array];
    _infoDict =[NSMutableDictionary dictionary];
    [self getCommentList];

    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-60) style:UITableViewStylePlain];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
//    [self setRefrshWithTableView:self.tableview];
    [self buildCommentView];

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
-(void)getDetailInfo
{
    
}

-(void)hiddenMe
{
    if ( zzView) {
        zzView.hidden = YES;
        [commentView.commentTf resignFirstResponder];
    }
}

-(void)getCommentList//评论列表
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //page pagesize articleId userid
    [params safeSetObject:@"30" forKey:@"pageSize"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@"1" forKey:@"page"];
    [params safeSetObject:self.infoModel.uid forKey:@"articleId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlecomment/queryArticlecomment.do" paramters:params success:^(NSDictionary *dic) {
        
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        _infoDict = [dataDict safeObjectForKey:@"article"];
        NSString * videoPath = [_infoDict safeObjectForKey:@"videoPath"];
        if (videoPath.length>5) {
            NSMutableDictionary * dic =[NSMutableDictionary dictionary];
            [dic safeSetObject:[_infoDict safeObjectForKey:@"videoImg"] forKey:@"imgUrl"];
            [dic safeSetObject:@(JFA_SCREEN_WIDTH-20) forKey:@"width"];
            [dic safeSetObject:@((JFA_SCREEN_WIDTH-20)*0.6) forKey:@"height"];
            [_dataArray addObject:dic];

        }
        else
        {
            for ( int i =0; i<9; i++) {
                NSString * imageUrl = [_infoDict safeObjectForKey:[NSString stringWithFormat:@"picture%d",i+1]];
                if (imageUrl&&imageUrl.length>0) {
                    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
                    [dic safeSetObject:imageUrl forKey:@"imgUrl"];
                    [dic safeSetObject:@(JFA_SCREEN_WIDTH-20) forKey:@"width"];
                    [dic safeSetObject:@((JFA_SCREEN_WIDTH-20)*0.6) forKey:@"height"];
                    [_dataArray addObject:dic];
                }
            }
        }
        
//        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
        
        _commentArray = [dataDict safeObjectForKey:@"array"];
        
        
        [self.tableview reloadData];
//        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];

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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlecomment/saveArticlecomment.do" paramters:params success:^(NSDictionary *dic) {
        [commentView.commentTf resignFirstResponder];
        commentView.commentTf.text = @"";
        [[UserModel shareInstance]showSuccessWithStatus:@"发表成功"];
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
            return 1;
            break;
        case 1:
            return _dataArray.count;
            break;
        default:
            return _commentArray.count;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        NSString * contentStr = [_infoDict safeObjectForKey:@"content"];
        return 65+([self getContentHeightWithContent:contentStr Font:15]<20?20:[self getContentHeightWithContent:contentStr Font:15]);
      
    }
    else if(indexPath.section ==1)
    {
        
        NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
        NSString * videoPath =[_infoDict objectForKey:@"videoPath"];
        if (videoPath.length>5) {
            return JFA_SCREEN_WIDTH*0.8;
        }else{
        // 先从缓存中查找图片
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: [dic safeObjectForKey:@"imgUrl"]];
        
        // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
        if (!image) {
            image = getImage(@"default");
            return (JFA_SCREEN_WIDTH-20)*0.6;

        }
        
        //手动计算cell
        CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        return imgHeight;  
        }
    }else
    {
        NSDictionary *dic =[_commentArray objectAtIndex:indexPath.row];
        NSString * contentStr = [dic safeObjectForKey:@"content"];
        return 80+[self getContentHeightWithContent:contentStr Font:14];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.section ==0) {
        static NSString * identifer = @"ArtcleDetailTextCell";
        ArtcleDetailTextCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifer];
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
        cell.nickNamelb.text = [_infoDict safeObjectForKey:@"nickName"];
        cell.contentlb.text = [_infoDict safeObjectForKey:@"content"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        return cell;
   
    }
    else if (indexPath.section ==1)
    {
        static NSString * identifer = @"ArtcleDetaileImageCell";
        ArtcleDetaileImageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifer];
        }
        NSString * videoPath = [_infoDict safeObjectForKey:@"videoPath"];
        
        if (videoPath.length>5) {
            cell.playImageView.hidden = NO;
        }
        else{
            cell.playImageView.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        [self configureCell:cell atIndexPath:indexPath];
        
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
        [cell.headImgBtn sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal placeholderImage:getImage(@"head_default")];
        cell.nicknamelb.text = [dict safeObjectForKey:@"nickName"];
        cell.timelb.text = [dict safeObjectForKey:@"createTime"];
        cell.contentlb.text = [dict safeObjectForKey:@"content"];
        cell.zanCountlb.text = [dict safeObjectForKey:@"greatnum"];
        return cell;
  
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1) {
        NSString * videoPath = [_infoDict safeObjectForKey:@"videoPath"];
        NSString * contentStr = [_infoDict safeObjectForKey:@"content"];
        float height = 65+([self getContentHeightWithContent:contentStr Font:15]<20?20:[self getContentHeightWithContent:contentStr Font:15]);
        if (videoPath.length>5) {
            //记录被点击的Cell
            //销毁播放器
            [_playerView destroyPlayer];
            CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(10,height+10, (JFA_SCREEN_WIDTH-20), (JFA_SCREEN_WIDTH-20)*0.8)];
            _playerView = playerView;
            [self.tableview addSubview:_playerView];
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
            
        }else{
            FcBigImgViewController * fc =[[FcBigImgViewController alloc]init];
            fc.images = _dataArray;
            fc.page = indexPath.row;
            
            [self presentViewController:fc animated:YES completion:nil];

        }

    }
}
-(double)getContentHeightWithContent:(NSString *)contentStr Font:(int)ft
{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    
    UIFont *font = [UIFont systemFontOfSize:ft];
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};
    
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(JFA_SCREEN_WIDTH-20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;

}
- (void)configureCell:(ArtcleDetaileImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *imgURL = [self.dataArray[indexPath.row]safeObjectForKey:@"imgUrl"];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    
    if ( !cachedImage ) {
        [self downloadImage:[self.dataArray[indexPath.row]safeObjectForKey:@"imgUrl"] forIndexPath:indexPath];
        cell.HeadImgView.image = getImage(@"default");
    } else {
        cell.HeadImgView.image =cachedImage;
    }
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    
    
    NSMutableDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        [dic safeSetObject:@(JFA_SCREEN_WIDTH-20) forKey:@"width"];
        [dic safeSetObject:@((JFA_SCREEN_WIDTH-20)/image.size.width*image.size.height) forKey:@"height"];
        
        [[SDImageCache sharedImageCache]storeImage:image forKey:imageURL completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });

    }];
    
    
}
#pragma mark ---上传评论
-(void)didSendCommentWithText:(NSString *)textStr
{
    if (textStr.length>1) {
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/userGreat/updateIsFabulous.do" paramters:params success:^(NSDictionary *dic) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
