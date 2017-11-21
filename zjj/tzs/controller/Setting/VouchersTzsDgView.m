//
//  VouchersTzsDgView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersTzsDgView.h"
#import "MyVouchersCell.h"
@implementation VouchersTzsDgView
{
    UIView * titleView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray array];
        [self initViews];
        
    }
    return self;
}
-(void)initViews
{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_HEIGHT, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-200)];
    self.contentView.backgroundColor =[UIColor whiteColor];
    [self addSubview:self.contentView];
    
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 45)];
    [self.contentView addSubview:titleView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((JFA_SCREEN_WIDTH-100)/2, 0, 100, 44)];
    titleLabel.text = @"优惠券";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH-40, 0, 40, 44)];
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn setImage:getImage(@"close_") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(didhidden) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBtn];
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 44, JFA_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    [titleView addSubview:lineView];

    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, JFA_SCREEN_WIDTH, self.contentView.frame.size.height-110) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource  = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableview];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-60, JFA_SCREEN_WIDTH, 60)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    
    
    UIView * line1View =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 1)];
    line1View.backgroundColor = HEXCOLOR(0xeeeeee);
    [bottomView addSubview:line1View];
    
    UILabel * b1lb = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, JFA_SCREEN_WIDTH/3*2-10, 20)];
    b1lb.backgroundColor = [UIColor whiteColor];
    b1lb.textAlignment = NSTextAlignmentLeft;
    b1lb.textColor = HEXCOLOR(0x6666666);
    b1lb.adjustsFontSizeToFitWidth = YES;
    b1lb.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:b1lb];
    
    UILabel * b2lb = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, JFA_SCREEN_WIDTH/3*2-10, 20)];
    b2lb.backgroundColor = [UIColor whiteColor];
    b2lb.textAlignment = NSTextAlignmentLeft;
    b2lb.textColor = HEXCOLOR(0x6666666);
    b2lb.adjustsFontSizeToFitWidth = YES;
    b2lb.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:b2lb];

    UIButton * didBuyBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/3*2, 1, JFA_SCREEN_WIDTH/3, 59)];
    didBuyBtn.backgroundColor = [UIColor redColor];
    [didBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [didBuyBtn setTitle:@"结算" forState:UIControlStateNormal];
    [didBuyBtn addTarget:self action:@selector(didBuy) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:didBuyBtn];
    
}

-(void)didshow
{
    self.hidden =NO;
    [self.tableview reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0, 200-64, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-200);
    }];
}

-(void)didhidden
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0, JFA_SCREEN_HEIGHT, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-200);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)didBuy
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MyVouchersCell";
    MyVouchersCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil]lastObject];
    }
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    cell.titlelb.text = [dic safeObjectForKey:@"templateName"];
    cell.timelb.text = [NSString stringWithFormat:@"有效期至:%@",[dic safeObjectForKey:@"validEndTime"]];
    
    
    int type = [[dic safeObjectForKey:@"type"]intValue];
    if (type ==2) {
        cell.faceValuelb.text = [NSString stringWithFormat:@"%.0f折",[[dic safeObjectForKey:@"discountAmount"]floatValue]*10];
    }else{
        cell.faceValuelb.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"discountAmount"]];
    }
    
    //    cell.faceValuelb.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"discountAmount"]];
    cell.headImageView.image = getImage(@"default");
    
    //useRange//使用范围 0全部商品 1脂将军饼干 2 体脂称
    int userRange = [[dic safeObjectForKey:@"useRange"]intValue];
    if (userRange ==1) {
        cell.limitGoodslb.text =@"仅限脂将军饼干使用";
    }
    else if(userRange ==2)
    {
        cell.limitGoodslb.text = @"仅限脂将军饼干使用";
    }else
    {
        cell.limitGoodslb.text = @"(无限制)";
    }
    
    int startAmount = [[dic safeObjectForKey:@"startAmount"]intValue];
    if (!startAmount||startAmount ==0) {
        cell.limitPricelb.text = @"(无限制)";
    }else{
        cell.limitPricelb.text = [NSString stringWithFormat:@"满%d可用",startAmount];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
