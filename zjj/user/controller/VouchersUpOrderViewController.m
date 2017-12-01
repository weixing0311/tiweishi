//
//  VouchersUpOrderViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersUpOrderViewController.h"
#import "IntegralOrderViewController.h"
#import "BaseWebViewController.h"
@interface VouchersUpOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *integrallb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *totallb;
@property (weak, nonatomic) IBOutlet UILabel *bottomlb;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsTitlelb;
@property (weak, nonatomic) IBOutlet UILabel *countlb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPricelb;



@end

@implementation VouchersUpOrderViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.param = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewInfo];
    self.title = @"订单信息";
    [self setTBWhiteColor];
}
-(void)setViewInfo
{
    NSString * priceStr = self.model.productPrice;
    NSString * integral = self.model.productIntegral;
    
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picture] placeholderImage:getImage(@"default")];
    self.goodsTitlelb.text = self.model.viceTitle;
    self.countlb.text = [NSString stringWithFormat:@"×%d",self.goodsCount];

    if (priceStr.floatValue>0&&integral.intValue>0) {
        self.goodsPricelb.text = [NSString stringWithFormat:@"%@积分+%.2f元",integral,[priceStr floatValue]];
        
    }else{
        if (priceStr.floatValue>0) {
            self.goodsPricelb.text = [NSString stringWithFormat:@"￥%.2f",[priceStr floatValue]];
        }else{
            self.goodsPricelb.text = [NSString stringWithFormat:@"%@积分",integral];
        }
    }

    self.integrallb.text = [NSString stringWithFormat:@"%d积分",[self.model.productIntegral intValue]*self.goodsCount];
    self.pricelb.text = [NSString stringWithFormat:@"￥%@",self.model.productPrice];
    
    
    if (integral.intValue>0&&priceStr.floatValue>0) {
        self.bottomlb.text =[NSString stringWithFormat:@"实付款：%d积分+%.2f元",[integral intValue]*self.goodsCount,[priceStr floatValue]*self.goodsCount];
        self.totallb.text = [NSString stringWithFormat:@"%d积分+%.2f元",[integral intValue]*self.goodsCount,[priceStr floatValue]*self.goodsCount];
        
    }else{
        if (integral.intValue>0) {
            self.bottomlb.text =[NSString stringWithFormat:@"实付款：%d积分",[integral intValue]*self.goodsCount ];
            self.totallb.text =[NSString stringWithFormat:@"%d积分",[integral intValue]*self.goodsCount ];
        }else{
            self.bottomlb.text = [NSString stringWithFormat:@"实付款：%.2f元",[priceStr floatValue]*self.goodsCount];
            self.totallb.text = [NSString stringWithFormat:@"%.2f元",[priceStr floatValue]*self.goodsCount];
        }
    }
}


- (IBAction)didBuy:(id)sender {
    
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:[UserModel shareInstance].phoneNum forKey:@"consigneePhone"];
    [self.param safeSetObject:@([self.model.productPrice floatValue]*self.goodsCount) forKey:@"totalPrice"];
    [self.param safeSetObject:@([self.model.productPrice floatValue]*self.goodsCount) forKey:@"payableAmount"];
    [self.param safeSetObject:self.model.stockCode forKey:@"warehouseNo"];
    [self.param safeSetObject:@([self.model.productIntegral intValue]*self.goodsCount) forKey:@"integral"];
    [self.param safeSetObject:self.model.couponId forKey:@"couponId"];

    
    
    DLog(@"上传数据---%@",self.param);
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/order/saveCouponOrderInfo.do" HiddenProgress:NO paramters:self.param success:^(NSDictionary *dic) {
        DLog(@"下单成功--%@",dic);
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        [[UserModel shareInstance]showSuccessWithStatus:@"提交成功"];
        
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
        float price = [[dataDic safeObjectForKey:@"payableAmount"]floatValue];
        if (price==0) {
            IntegralOrderViewController * ordVC = [[IntegralOrderViewController alloc]init];
            ordVC.hidesBottomBarWhenPushed = YES;
            NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [arr removeLastObject];
            [arr addObject:ordVC];
            [self.navigationController setViewControllers:arr];
        }else{
            BaseWebViewController *web = [[BaseWebViewController alloc]init];
            web.urlStr = @"app/checkstand.html";
            web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
            //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值 5积分购买
            web.payType =5;
            web.opt =1;
            web.integral = @"1";
            web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
            web.title  =@"收银台";
            [self.navigationController pushViewController:web animated:YES];
        }
        
        
    } failure:^(NSError *error) {
        //        [[UserModel shareInstance]showErrorWithStatus:@"提交失败"];
        
        DLog(@"下单失败--%@",error);
    }];
    
    
    
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
