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
#import "PostArticleViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"
#import "Masonry.h"
#import "EditUserInfoImageCell.h"
#import "ArticleDetailViewController.h"
#import "EditUserInfoViewController.h"
#import "BeforeAfterContrastCell.h"
#import "FcBigImgViewController.h"
#import "PostArticleViewController.h"
@interface NewMineHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,PublicArticleCellDelegate,NewMineHomePageHeaderCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
    PublicArticleCell * PlayingCell;
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
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/usertArticleDetail/queryUserHome.do" paramters:params success:^(NSDictionary *dic) {
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
        return JFA_SCREEN_WIDTH/320*199;
    }
    else if(indexPath.section ==1)
    {
        return 130;
    }
    else if(indexPath.section==2)
    {
        if (fatBefore.length>0)
        {
            return 250;
        }else{
            return 0;
        }
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
        if (fatBefore.length>0)
        {
            return 1;
        }else{
            return 0;
        }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal placeholderImage:getImage(@"defaultHead")
         ];
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"backGroundImg"]] placeholderImage:getImage(@"newMineBg_")];
        
        
        cell.nicknamelb.text = [_infoDict safeObjectForKey:@"nickName"];
        NSString * introduction = [_infoDict safeObjectForKey:@"introduction"];
        if (introduction.length<1) {
            cell.jjlb.text = @"还没有编辑简介~";
        }else{
            cell.jjlb.text = [NSString stringWithFormat:@"简介：%@",introduction];
        }
        int  sex = [UserModel shareInstance].gender;
        if (sex ==1) {
            cell.sexImageView.image = getImage(@"man");
            
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
        cell.beforeWeightlb.text = [NSString stringWithFormat:@"%.0fkg",[[_infoDict safeObjectForKey:@"beforeWeight"] floatValue]];
        cell.afterweightlb.text = [NSString stringWithFormat:@"%.0fkg",[[_infoDict safeObjectForKey:@"afterWeight"] floatValue]];
        cell.continuousDatelb.text = [NSString stringWithFormat:@"%@",[_infoDict safeObjectForKey:@"registerDate"]?[_infoDict safeObjectForKey:@"registerDate"]:@"0"];
        cell.lossWeightlb.text = [NSString stringWithFormat:@"%.0f",[[_infoDict safeObjectForKey:@"beforeWeight"]floatValue]-[[_infoDict safeObjectForKey:@"afterWeight"]floatValue]];

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

        [cell.fatBeforeBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatBefore"]] placeholderImage:getImage(@"before")];
        [cell.fatAfterBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"fatAfter"]] placeholderImage:getImage(@"last")];
        
        return cell;
        
    }
    else
    {
        CommunityModel * item =[self.dataArray objectAtIndex:indexPath.row];
        static  NSString * identifier = @"PublicArticleCell";
        PublicArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gzBtn.hidden = YES;

        if ([self.userId isEqualToString:[UserModel shareInstance].userId]) {
            cell.jbBtn.hidden = YES;
        }else{
            cell.jbBtn.hidden = NO;
        }
        
        [cell setInfoWithDict:item];
        if (self.tableview.dragging==NO&&self.tableview.decelerating ==NO) {
            [cell loadImagesWithItem:item];
        }

        return cell;
        
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
        return @"最新动态";

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
    
    UIImage * image = [self getImage];
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self shareWithType:SSDKPlatformSubTypeWechatSession image:image];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline image:image];

    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"社区" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        PostArticleViewController * postVC =[[PostArticleViewController alloc]init];
        postVC.firstImage = image;
        [self.navigationController pushViewController:postVC animated:YES];
        
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

-(void)didJBWithCell:(PublicArticleCell *)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
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

-(void)refreshZanInfoWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    if ([model.isFabulous isEqualToString:@"1"]) {
        model.isFabulous = @"0";//1是点赞 0取消
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount-1];
        model.greatnum = [NSString stringWithFormat:@"%d",[model.greatnum intValue]-1];
        cell.zanImageView.image = getImage(@"praise");
        
    }else{
        model.isFabulous = @"1";
        int zanCount = [cell.zanCountlb.text intValue];
        cell.zanCountlb.text = [NSString stringWithFormat:@"%d",zanCount+1];
        model.greatnum = [NSString stringWithFormat:@"%d",[model.greatnum intValue]+1];
        cell.zanImageView.image = getImage(@"praise_Selected");
    }
    
}

-(void)didPLWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    ArticleDetailViewController * ard =[[ArticleDetailViewController alloc]init];
    ard.infoModel = model;
    ard.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ard animated:YES];
    
    //
}
-(void)didShareWithCell:(PublicArticleCell*)cell
{
    CommunityModel * model = [_dataArray objectAtIndex:cell.tag];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:model.uid forKey:@"id"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/community/article/updateForwardingnum.do" paramters:params success:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
    
    //    /app/community/article/updateForwardingnum.do
    //        参数：    id //文章Id
}


-(void)didGzUserWithCell:(NewMineHomePageCell *)cell
{
    if (cell.gzBtn.selected ==YES) {
        [self cancelGzWithId:[_infoDict safeObjectForKey:@"userId"] cell:cell];
    }else{
        NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
        [params setObject:[_infoDict safeObjectForKey:@"userId"] forKey:@"followId"];
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/followUser.do" paramters:params success:^(NSDictionary *dic) {
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
        self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/userfollow/removeUserFollow.do" paramters:params success:^(NSDictionary *dic) {
            DLog(@"dic-取消关注成功--%@",dic);
            cell.gzBtn.selected = YES;
            [[UserModel shareInstance]showSuccessWithStatus: @"取消成功"];
            [self.tableview headerBeginRefreshing];

        } failure:^(NSError *error) {
            
        }];
        
    }]];
    
    [self presentViewController:al animated:YES completion:nil];
    
    
    
}

-(void)didShowBigImageWithCell:(PublicArticleCell*)cell index:(int)index
{
    CommunityModel * item = [_dataArray objectAtIndex:cell.tag];
    FcBigImgViewController * fc =[[FcBigImgViewController alloc]init];
    fc.images = [NSMutableArray arrayWithArray:item.pictures];
    fc.page = index;
    
    [self presentViewController:fc animated:YES completion:nil];

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
        UIImage *image =info[UIImagePickerControllerEditedImage];
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
        [self.tableview headerBeginRefreshing];
        [[UserModel shareInstance] showSuccessWithStatus:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshInfo object:nil];
    } failure:^(NSError *error) {
        
        DLog(@"faile-error-%@",error);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (NSIndexPath * indexPath in [self.tableview indexPathsForVisibleRows]) {
        if (indexPath.section ==3) {
            CommunityModel * item = [_dataArray objectAtIndex:indexPath.row];
            PublicArticleCell * cell = [self.tableview cellForRowAtIndexPath:indexPath];
            [cell loadImagesWithItem:item];

        }
    }
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
