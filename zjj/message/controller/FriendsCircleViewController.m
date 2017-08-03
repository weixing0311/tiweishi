//
//  FriendsCircleViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "FriendsCircleViewController.h"
#import "FriendsCircleCell.h"
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
    int lastClickImageCell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"盆友圈分享";
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
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[button convertRect: button.bounds toView:window];
    
    self.originalRect = rect;
    NSDictionary * dic = [self.dataArray objectAtIndex:cell.tag];
    NSArray * images = [dic objectForKey:@"pictures"];
    NSString * imageUrl =[images objectAtIndex:button.tag-1];
    
    if (!self.blackView) {
        self.blackView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT)];
        self.blackView.contentSize = CGSizeMake(JFA_SCREEN_WIDTH*images.count, 0);
        self.blackView.backgroundColor =RGBACOLOR(0, 0, 0, 0.6);
    }
    if (lastClickImageCell!=cell.tag) {
        
        for (UIView * view in self.blackView.subviews) {
            [view removeFromSuperview];
        }
    
        for (int i =0; i<images.count; i++) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:images[i]]];
            UIImage *image = [UIImage imageWithData:data];
            
            float imageHeight = JFA_SCREEN_WIDTH * image.size.height/image.size.width ;
            
            UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(i*JFA_SCREEN_WIDTH+5, (JFA_SCREEN_HEIGHT-imageHeight)/2, JFA_SCREEN_WIDTH-10, imageHeight)];
            imageView.image = image;
            imageView.tag = 100+i;
            imageView.userInteractionEnabled = YES;
            [self.blackView addSubview:imageView];
        
        [self.blackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didHiddenMe)]];
        [self.view.window addSubview:self.blackView];
        }
        lastClickImageCell = cell.tag;
    }
    self.blackView.pagingEnabled = YES;
    self.blackView.contentOffset = CGPointMake((button.tag-1)*JFA_SCREEN_WIDTH, 0);
    self.bigImageView.frame  = rect;
    [self.bigImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    self.bigImageView.hidden =NO;
    self.blackView.hidden =NO;
    [UIView animateWithDuration:.3 animations:^{
        self.bigImageView.frame = CGRectMake(0, (JFA_SCREEN_HEIGHT-JFA_SCREEN_WIDTH)/2, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH);
    } completion:^(BOOL finished) {
        
    }];
    
    
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
    
    NSArray* imageArray = [dict safeObjectForKey:@"images"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i <imageArray.count; i++) {
        NSString *URL = imageArray[i];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        UIImage *imagerang = [UIImage imageWithData:data];
        
        NSString *path_sandox = NSHomeDirectory();
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
        [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
        
        
        /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在吊起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
        
//        SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
        
        [array addObject:imagerang];
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [dict safeObjectForKey:@"content"];
    [[UserModel shareInstance]showInfoWithStatus:@"文案已复制，请在分享时长按粘贴"];
    
    
    
    
    NSArray *activityItems = array;
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:TRUE completion:nil];


    
    
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
