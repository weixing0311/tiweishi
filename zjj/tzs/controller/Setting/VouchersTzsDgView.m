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
    NSDictionary * chooseDict;
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
        chooseDict = [NSDictionary dictionary];
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
//    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn setImage:getImage(@"close_") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(didClickhidden) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.value1lb = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, JFA_SCREEN_WIDTH/3*2-10, 20)];
    self.value1lb.backgroundColor = [UIColor whiteColor];
    self.value1lb.textAlignment = NSTextAlignmentLeft;
    self.value1lb.textColor = HEXCOLOR(0x6666666);
    self.value1lb.adjustsFontSizeToFitWidth = YES;
    self.value1lb.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:self.value1lb];
    
    self.value2lb = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, JFA_SCREEN_WIDTH/3*2-10, 20)];
    self.value2lb.backgroundColor = [UIColor whiteColor];
    self.value2lb.textAlignment = NSTextAlignmentLeft;
    self.value2lb.textColor = HEXCOLOR(0x6666666);
    self.value2lb.adjustsFontSizeToFitWidth = YES;
    self.value2lb.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:self.value2lb];

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
    self.value2lb.text = [NSString stringWithFormat:@"总额：￥%.2f，优惠：￥%.2f",self.totalPrice,self.Preferentialprice];
    self.value1lb.text = [NSString stringWithFormat:@"实付款:￥%.2f", self.totalPrice-self.Preferentialprice];

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
-(void)didClickhidden
{
    chooseDict = nil;
    [self didhidden];
}
-(void)didBuy
{
//    if (!chooseDict) {
//        return;
//    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didBuyWithDictionary:)]) {
        [self.delegate didBuyWithDictionary:chooseDict];
    }
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
    cell.titlelb.text = [dic safeObjectForKey:@"grantName"];
    cell.limitGoodslb.hidden = YES;
    cell.limit2Goodslb.hidden = NO;

    
    NSString * startTime = [[dic safeObjectForKey:@"validStartTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符
    NSString * endTime  = [[dic safeObjectForKey:@"validEndTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];//替换字符
    
    cell.timelb.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];

    if (chooseDict) {
        NSString * chooseNo = [chooseDict safeObjectForKey:@"couponNo"];
        NSString * cellNo = [dic safeObjectForKey:@"couponNo"];
        if ([chooseNo isEqualToString:cellNo]) {
            cell.didChooseImage.hidden = NO;;
        }else{
            cell.didChooseImage.hidden = YES;
        }
    }else{
        cell.didChooseImage.hidden = YES;
    }
    
    int type = [[dic safeObjectForKey:@"type"]intValue];
    if (type ==2) {
        cell.faceValuelb.text = [NSString stringWithFormat:@"%.1f折",[[dic safeObjectForKey:@"discountAmount"]floatValue]*10];
    }else{
        NSString * faceValue = [NSString stringWithFormat:@"￥%@",[dic safeObjectForKey:@"discountAmount"]];
        NSMutableAttributedString * tisString = [[NSMutableAttributedString alloc]initWithString:faceValue];

        [tisString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        cell.faceValuelb.attributedText = tisString;

    }
    
    //    cell.faceValuelb.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"discountAmount"]];
    
    //useRange//使用范围 0全部商品 1脂将军饼干 2 体脂称
    cell.limit2Goodslb.text = [cell getlimitWithArr:[dic safeObjectForKey:@"products"]];

    int startAmount = [[dic safeObjectForKey:@"startAmount"]intValue];
    if (!startAmount||startAmount ==0) {
        cell.limitPricelb.text = @"(无限制)";
    }else{
        cell.limitPricelb.text = [NSString stringWithFormat:@"满%d可用",startAmount];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)changeValueInfo
{
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    
    if (chooseDict) {
        NSString * chooseNo = [chooseDict safeObjectForKey:@"couponNo"];
        NSString * cellNo = [dic safeObjectForKey:@"couponNo"];
        if ([chooseNo isEqualToString:cellNo]) {
            chooseDict =nil;
        }else{
            chooseDict = dic;
        }
    }else{
        chooseDict =dic;
    }

    float amount = [[chooseDict safeObjectForKey:@"amount"]floatValue];
    float prefrenPrice = self.Preferentialprice +amount;
    self.value2lb.text = [NSString stringWithFormat:@"总额：￥%.2f，优惠：￥%.2f",self.totalPrice,prefrenPrice];
    self.value1lb.text = [NSString stringWithFormat:@"实付款:￥%.2f", self.totalPrice-prefrenPrice];
    [self.tableview reloadData];
}
@end
