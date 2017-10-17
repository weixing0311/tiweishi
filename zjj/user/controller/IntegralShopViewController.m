//
//  IntegralShopViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralShopViewController.h"
#import "integralShopCell.h"
#import "IntegralOrderViewController.h"
#import "NewMineIntegralShopDetailViewController.h"
@interface IntegralShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign)int   page;
@property (nonatomic,assign)int   count;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UILabel *jifenlb;

@end

@implementation IntegralShopViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self getJiFen];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分商城";
    [self setTBWhiteColor];
    self.jifenlb.adjustsFontSizeToFitWidth = YES;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    
    
    _dataArray = [NSMutableArray array];
    [self.collectionView registerNib:[UINib nibWithNibName:@"integralShopCell"bundle:nil]forCellWithReuseIdentifier:@"integralShopCell"];
    
    [self setRefrshWithTableView:(UITableView *)self.collectionView];
    [self.collectionView headerBeginRefreshing];
}
-(void)headerRereshing
{
    [super headerRereshing];
    self.page =1;
    self.count =30;
    
    [self getInfo];
    
}
-(void)footerRereshing
{
    [super footerRereshing];
    self.page ++;
    [self getInfo];
    
}

-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(self.count) forKey:@"pageSize"];
//    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];

    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/integral/product/queryProductintegral.do" paramters:param success:^(NSDictionary *dic) {
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        
        if (self.page ==1) {
            [_dataArray removeAllObjects];
            self.collectionView.footerHidden = NO;
            
        }
        
        self.dataArray = [[dic objectForKey:@"data"] objectForKey:@"array"];
        
        [self.collectionView reloadData];

    } failure:^(NSError *error) {
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
    }];
}

-(void)getJiFen
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryIntegeralAndSucc.do" paramters:param success:^(NSDictionary *dic) {
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        self.jifenlb.text = [NSString stringWithFormat:@"积分 %@",[dataDict safeObjectForKey:@"currentIntegeral"]];
        
    } failure:^(NSError *error) {
    }];

}
- (IBAction)showjifen:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showOrder:(id)sender {
    IntegralOrderViewController * orderVC = [[IntegralOrderViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [_dataArray objectAtIndex:indexPath.row];
    integralShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"integralShopCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"picture"]] placeholderImage:getImage(@"")];
    cell.titlelb .text = [dict safeObjectForKey:@"viceTitle"];
    cell.timelb  .text = [dict safeObjectForKey:@""];
    NSString * gradeStr =[dict safeObjectForKey:@"grade"];
    if ( [gradeStr isEqualToString:@"0"]||!gradeStr) {
        cell.secondlb .text = @"无限制";
    }else{
    cell.secondlb.text = [NSString stringWithFormat:@"%@级以上",[dict safeObjectForKey:@"grade"]];
    }
    NSString * priceStr = [dict safeObjectForKey:@"productPrice"];
    NSString * integral = [dict safeObjectForKey:@"productIntegral"];
    if (integral.intValue>0&&priceStr.intValue>0) {
        cell.pricelb.text =[NSString stringWithFormat:@"￥%.2f+%@积分",[priceStr floatValue],integral];
        
        
    }else{
        if (integral.intValue>0) {
            cell.pricelb.text =[NSString stringWithFormat:@"%@积分",integral];
            
        }else{
            cell.pricelb.text =[NSString stringWithFormat:@"￥%.2f",[priceStr floatValue]];
        }
        
    }
    cell.pricelb.adjustsFontSizeToFitWidth = YES;
//    cell.pricelb .text = [NSString stringWithFormat:@"￥%@",[dict safeObjectForKey:@"productPrice"]];
    return cell;
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((JFA_SCREEN_WIDTH-20)/2, (JFA_SCREEN_WIDTH-20)/2+30);
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    NewMineIntegralShopDetailViewController * nmd = [[NewMineIntegralShopDetailViewController alloc]init];
    nmd.productNo = [dic safeObjectForKey:@"productNo"];
    [self.navigationController pushViewController:nmd animated:YES];
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
