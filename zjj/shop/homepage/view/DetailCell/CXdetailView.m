//
//  CXdetailView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "CXdetailView.h"
#import "DetailCxCell.h"
@implementation CXdetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.bgView.backgroundColor =RGBACOLOR(0, 0, 0, 0.5);
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        [self buildTableView];
        [self buildTabHeaderView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(hiddenMe)];
        tap.delegate =self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)buildTableView
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,JFA_SCREEN_HEIGHT- 64, JFA_SCREEN_WIDTH, 400) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self addSubview:self.tableview];
    
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableview setTableFooterView:view];

}
-(void)buildTabHeaderView
{
    UIView *Headview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 60)];
    Headview.backgroundColor = [UIColor clearColor];
    UILabel * titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleLabel.text = @"促销";
    titleLabel.center = Headview.center;
    [Headview addSubview:titleLabel];
    
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH-50, 10, 40, 40)];
    
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hiddenCuXiaoTabView) forControlEvents:UIControlEventTouchUpInside];
    [Headview addSubview:closeBtn];
    
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    [Headview addSubview:lineView];

    UIView * lineView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 59, JFA_SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = HEXCOLOR(0xeeeeee);
    [Headview addSubview:lineView1];
    [self.tableview setTableHeaderView:Headview];
    

}
-(void)hiddenMe
{
    [self hiddenCuXiaoTabView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"DetailCxCell";
    DetailCxCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell  =[[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil]lastObject];
    }
    
    NSDictionary * dic =[self.dataArray objectAtIndex:indexPath.row];
    int hdtype = [[dic objectForKey:@"promotionType"]intValue];
    if (hdtype ==1) {
        cell.cxImgLabel.text = @"满减";
    }else{
        cell.cxImgLabel.text= @"满赠";
    }
    cell.cxContentLabel.text = [dic objectForKey:@"promotionDetail"];
//    cell.selectionStyle =UITableViewCellSelectionStyleNone;



    return cell;
}

-(void)showCuxiaoTabViewWithArray:(NSArray *)arr
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:arr];
    
    [self.tableview reloadData];
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableview.frame = CGRectMake(0, self.frame.size.height-390, JFA_SCREEN_WIDTH, 400);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hiddenCuXiaoTabView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tableview.frame = CGRectMake(0, self.frame.size.height, JFA_SCREEN_WIDTH, 400);
    } completion:^(BOOL finished) {
        self .hidden = YES;
    }];
}
@end
