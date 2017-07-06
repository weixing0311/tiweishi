//
//  ShareViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareCell.h"
#import "ShareHealthItem.h"
#import "ShareListView.h"
@interface ShareViewController ()
@property (nonatomic,strong)NSMutableArray * chooseArray;
@end

@implementation ShareViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.chooseArray =[NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"分享";
    [self setNbColor];
    self.tableview.delegate =self;
    self.tableview.dataSource= self;

    [self getShareInfo];
    
}
-(void)getShareInfo
{
    
    NSDate * endDate = [NSDate date];
    NSDate * beginDate =[endDate dateByAddingTimeInterval:(-30 * 24 * 60 * 60)];

    
    NSMutableDictionary * param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:beginDate forKey:@"startDate"];
    [param safeSetObject:endDate forKey:@"endDate"];
    [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatList.do" paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dict =[dic safeObjectForKey:@"data"];
        
        NSArray * arr =[dict safeObjectForKey:@"array"];
        [_dataArray removeAllObjects];

        for (int i =0; i<arr.count; i++) {
            NSDictionary * ListInfo = [arr objectAtIndex:i];
            ShareHealthItem * item =[[ShareHealthItem alloc]init];
            [item setobjectWithDic:ListInfo];
            [_dataArray addObject:item];
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ShareCell";
    
    ShareCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self getXibCellWithTitle:identifier];
        
    };
    cell.tag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    ShareHealthItem * item = [self.dataArray objectAtIndex:indexPath.row];
    [cell setUpCellWithItem:item];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.navigationController.navigationBarHidden = NO;
    ShareCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.chooseBtn.selected==YES) {
        cell.chooseBtn.selected =NO;
        [self.chooseArray removeObject:cell];
    }else{
        if (self.chooseArray.count<2) {
            cell.chooseBtn.selected = YES;
            [self.chooseArray addObject:cell];
        }else{
            [self showError:@"最多只能选两条"];
        }
    }
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
-(void)showShareView
{
    if (self.chooseArray.count!=2) {
        [self showError:@"请选择两条数据"];
        return;
    }
    ShareListView * shareTr = [self getXibCellWithTitle:@"ShareListView"];
    
    ShareCell * cell1 = [self.chooseArray objectAtIndex:0];
    ShareCell * cell2 = [self.chooseArray objectAtIndex:1];
    ShareHealthItem * item1 = [self.dataArray objectAtIndex:cell1.tag];
    ShareHealthItem * item2 =[self.dataArray objectAtIndex:cell2.tag];
    NSMutableArray * arr =[NSMutableArray array];
    [arr addObject:item1];
    [arr addObject:item2];
    [shareTr setInfoWithArr:arr];
    [self.view addSubview:shareTr];
    [self.view bringSubviewToFront:shareTr];
    [self getImageWithView:shareTr];
}
- (IBAction)didShareVX:(id)sender {
    
    [self showShareView];
    
}

- (IBAction)didShareFriedns:(id)sender {
    [self showShareView];
}

- (IBAction)didShareQQ:(id)sender {
    [self showShareView];
}


-(void)getImageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    [view removeFromSuperview];
}


@end
