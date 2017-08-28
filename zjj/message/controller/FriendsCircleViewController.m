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
@interface FriendsCircleViewController ()<UITableViewDelegate,UITableViewDataSource,friendsCircleCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UIImageView * bigImageView;
@property (nonatomic,strong)UIScrollView   * blackView;
@property (nonatomic,assign)CGRect originalRect;

@end

@implementation FriendsCircleViewController
{
    int page;
    int pageSize;
    NSInteger lastClickImageCell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈推广";
    [self setTBRedColor];
    pageSize=30;
    lastClickImageCell=1000000;
    self.dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
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
            
            NSMutableArray * imageArr =[infoDic safeObjectForKey:@"pictures"];
//            NSString * cardUrl = [infoDic safeObjectForKey:@"cardUrl"];
//            [imageArr addObject:cardUrl];
            float rowHeight = [self CalculateCellHieghtWithContent:[infoDic safeObjectForKey:@"content"] images:imageArr];
            [infoDic safeSetObject:@(rowHeight) forKey:@"rowHeight"];
            NSMutableArray * images = [NSMutableArray array];
            NSMutableArray * shareImages = [NSMutableArray array];
            for (NSString * imgUrl in imageArr) {
                UIImage * image = [self getImageFromUrl:imgUrl imgViewWidth:(JFA_SCREEN_WIDTH-108)/3 imgViewHeight:(JFA_SCREEN_WIDTH-108)/3];
                UIImage * shareImage = [self getShareImageFormUrl:imgUrl];
                if (image) {
                    [images addObject:image];
                }
                if (shareImage) {
                    [shareImages addObject:shareImage];
                }
            }
            [infoDic safeSetObject:images forKey:@"images"];
            [infoDic safeSetObject:shareImages forKey:@"shareImages"];
        }

        
        [self.dataArray addObjectsFromArray:infoArr];
        
        [self.tableview reloadData];
        
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        [self.tableview footerEndRefreshing];
        [self.tableview headerEndRefreshing];
        [[UserModel shareInstance]showInfoWithStatus:[error.userInfo safeObjectForKey:@"NSLocalizedDescription"]];
    }];
    

}
-(float)CalculateCellHieghtWithContent:(NSString *)contentStr images:(NSArray * )images
{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;

    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};

    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(JFA_SCREEN_WIDTH-88, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    float imageHeight = 0.0f;
    CGFloat cellW = (JFA_SCREEN_WIDTH-108)/3;

    if (images.count<1)
    {
        imageHeight = 0;
    }
    else if (images.count>0&& images.count<=3)
    {
        imageHeight =cellW;
    }
    else if (images.count>3&&images.count<=6)
    {
        imageHeight = cellW*2+10;
    }
    else{
        imageHeight = cellW*3+20;
    }
    
    return size.height+imageHeight+105;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic =[self.dataArray objectAtIndex:indexPath.row];
    float rowheight = [[dic safeObjectForKey:@"rowHeight"]floatValue];
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
    NSDictionary * dic =[self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setInfoWithDict:dic];
    return cell;
}

#pragma mark ----celldelegate
-(void)didCheckImagesWithButton:(UIButton *)button cell:(FriendsCircleCell *)cell;
{
    NSDictionary * dic = [self.dataArray objectAtIndex:cell.tag];
    NSArray * images = [dic objectForKey:@"pictures"];
    
    FcBigImgViewController * fc =[[FcBigImgViewController alloc]init];
    fc.images = [NSMutableArray arrayWithArray:images];
    fc.page = button.tag-1;
    
    [self presentViewController:fc animated:YES completion:nil];
    
    
}
-(void)didClickShareWithCell:(FriendsCircleCell *)cell
{
    NSDictionary * dic = [_dataArray objectAtIndex:cell.tag];

    
    
    [self shareWithType:SSDKPlatformSubTypeWechatTimeline dict:dic];

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
-(void) shareWithType:(SSDKPlatformType)type dict:(NSDictionary *)dict
{
    if (!dict||[dict allKeys].count<1) {
        return;
    }
    
    NSArray * imageArray = [dict safeObjectForKey:@"shareImages"];
    NSArray * imageUrlArr = [dict safeObjectForKey:@"pictures"];
    NSMutableArray *array = [[NSMutableArray alloc]init];

    
    
    if (![[imageArray lastObject] isKindOfClass:[UIImage class]]||imageArray.count<1||!imageArray) {
        
    
    for (int i = 0; i <imageUrlArr.count; i++) {
        NSString *URL = imageUrlArr[i];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        UIImage *imagerang = [UIImage imageWithData:data];
        
        NSString *path_sandox = NSHomeDirectory();
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
        [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
        
        
        /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在吊起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
        
//        SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
        
        [array addObject:imagerang];
    }
    }
    else{
        array  = [NSMutableArray arrayWithArray:imageArray];
    }
    
    if (array.count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"分享出错 请重试"];

        return;
    }
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [dict safeObjectForKey:@"content"];
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
