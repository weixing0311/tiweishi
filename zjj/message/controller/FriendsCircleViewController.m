//
//  FriendsCircleViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "FriendsCircleViewController.h"
#import "FriendsCircleCell.h"
#import "FcBigImgViewController.h"
#import "LoadedImageModel.h"
@interface FriendsCircleViewController ()<UITableViewDelegate,UITableViewDataSource,friendsCircleCellDelegate>
@property (strong, nonatomic)  UIView *segBgView;

@property (strong, nonatomic)  UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UIImageView * bigImageView;
@property (nonatomic,strong)UIScrollView   * blackView;
@property (nonatomic,assign)CGRect originalRect;

@end
///
@implementation FriendsCircleViewController
{
    int page;
    int pageSize;
    NSInteger lastClickImageCell;
    UISegmentedControl * segment;
    NSArray * _segmentArray;
    NSString * showSegType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈推广";
    [self setTBRedColor];
    self.segBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, JFA_SCREEN_WIDTH, 48)];
    self.segBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segBgView];
    [self.view bringSubviewToFront: self.segBgView];

    self.tableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+48, JFA_SCREEN_WIDTH, self.view.frame.size.height-48) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    

    [self getSegmentInfo];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    pageSize=30;
    lastClickImageCell=1000000;
    self.dataArray = [NSMutableArray array];
    _segmentArray = [NSArray array];
    
}
////获取segment
-(void)getSegmentInfo
{
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/sysShareMsgType/sysShareMsgTypeList.do" paramters:nil success:^(NSDictionary *dic) {
        _segmentArray = [[dic safeObjectForKey:@"data"]objectForKey:@"array"];
        NSMutableArray * titleArray =[NSMutableArray array];
        for (int i =0; i<_segmentArray.count; i++) {
            NSDictionary * dic = [_segmentArray objectAtIndex:i];
            NSString * title = [dic safeObjectForKey:@"msgtype"];
            [titleArray addObject:title];
        }
        segment =[[UISegmentedControl alloc]initWithItems:titleArray];
//        for (int i =0; i<_segmentArray.count; i++) {
//            NSDictionary * dict = [_segmentArray objectAtIndex:i];
//            [segment setTitle:[dict safeObjectForKey:@"msgtype"] forSegmentAtIndex:i];
//        }
        segment.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 48);
        [segment addTarget:self action:@selector(didClickSegment:) forControlEvents:UIControlEventValueChanged];
        [self.segBgView addSubview:segment];
        [self ChangeMySegmentStyle:segment];
        segment.selectedSegmentIndex=0;
        showSegType = [[_segmentArray objectAtIndex:0] safeObjectForKey:@"id"];
        [self.tableview headerBeginRefreshing];
        
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)didClickSegment:(UISegmentedControl *)segment
{
    NSDictionary * dic =_segmentArray[segment.selectedSegmentIndex];
    showSegType = [dic safeObjectForKey:@"id"];
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
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params  safeSetObject:showSegType forKey:@"shareMsgType"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/informate/queryShareMsgList.do" paramters:params success:^(NSDictionary *dic) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            [self.tableview setFooterHidden:NO];

        }
        
        
        
        
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            [self.tableview setFooterHidden:YES];
        }
        for (NSMutableDictionary * infoDic in infoArr) {
            LoadedImageModel * item = [[LoadedImageModel alloc]init];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadedImageModel * item =[self.dataArray objectAtIndex:indexPath.row];
    float rowheight = item.rowHieght;
    return rowheight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"FriendsCircleCell";
    FriendsCircleCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LoadedImageModel * item =[self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setInfoWithDict:item];
    return cell;
}

#pragma mark ----celldelegate
-(void)didCheckImagesWithButton:(UIButton *)button cell:(FriendsCircleCell *)cell;
{
    LoadedImageModel * item = [self.dataArray objectAtIndex:cell.tag];
    NSArray * images = item.pictures;
    
    FcBigImgViewController * fc =[[FcBigImgViewController alloc]init];
    fc.images = [NSMutableArray arrayWithArray:images];
    fc.page = button.tag-1;
    
    [self presentViewController:fc animated:YES completion:nil];
    
    
}
-(void)didClickShareWithCell:(FriendsCircleCell *)cell
{
    LoadedImageModel * item = [_dataArray objectAtIndex:cell.tag];

    NSArray * imageArray = cell.loadedImage;
    
    [self shareWithType:SSDKPlatformSubTypeWechatTimeline dict:item arr:imageArray];

}
-(void)insertImage:(NSMutableArray * )arr cell:(FriendsCircleCell*)cell
{
    LoadedImageModel * item =[self.dataArray objectAtIndex:cell.tag];
    [item.loadedImageArray addObjectsFromArray:arr];
    
    
}
-(void)didHiddenMe
{
    [UIView animateWithDuration:.3 animations:^{
        self.bigImageView.frame = self.originalRect;
    } completion:^(BOOL finished) {
        self.blackView.hidden = YES;
    }];

}
#pragma mark ----share
-(void) shareWithType:(SSDKPlatformType)type dict:(LoadedImageModel *)item arr:(NSArray*)arr
{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];

    if (item.loadedImageArray&&item.loadedImageArray.count==item.pictures.count) {
        
        array  = [NSMutableArray arrayWithArray:item.loadedImageArray];

    }else{
        
        array = [NSMutableArray arrayWithArray:arr];
    }
    for (UIImage * image in array) {
        if (![image isKindOfClass:[UIImage class]]) {
            return;
        }
    }
    
    if (array.count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"分享出错 请重试"];

        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:item.uid forKey:@"id"];
    
    
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/msg/countShareNum.do" paramters:params success:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = item.content;
    [[UserModel shareInstance]showInfoWithStatus:@"文案已复制，请在分享时长按粘贴"];
    
    
    NSArray *activityItems = array;
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:TRUE completion:nil];

}


#pragma mark-------根据imgView的宽高获得图片的比例

-(UIImage *)getImageFromUrl:(NSString *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    
    UIImage * newImage = [self getImageWithUrl:imgUrl imgViewWidth:width imgViewHeight:height];
    
    return newImage;
    
}
-(UIImage * )getShareImageFormUrl:(NSString*)url
{
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)url,
                                                              
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              
                                                              NULL,
                                                              
                                                              kCFStringEncodingUTF8));
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
   UIImage *  image =[UIImage imageWithData:data];
    return image;
}
//对象方法

-(UIImage *)getImageWithUrl:(NSString *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)imgUrl,
                                                              
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              
                                                              NULL,
                                                              
                                                              kCFStringEncodingUTF8));

    //data 转image
    
    UIImage * image ;
    
    //根据网址将图片转化成image
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    image =[UIImage imageWithData:data];
    
    //图片剪切
    
    UIImage * newImage = [self cutImage:image imgViewWidth:width imgViewHeight:height];
    
    return newImage;
    
}

//裁剪图片

- (UIImage *)cutImage:(UIImage*)image imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height

{
    
    //压缩图片
    
    CGSize newSize;
    
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (width / height)) {
        
        newSize.width = image.size.width;
        
        newSize.height = image.size.width * height /width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        
        newSize.height = image.size.height;
        
        newSize.width = image.size.height * width / height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
    
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
