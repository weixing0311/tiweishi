//
//  VouchersModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "VouchersModel.h"
static VouchersModel * model;
@implementation VouchersModel
+(VouchersModel*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[VouchersModel alloc]init];
    });
    return model;
}


-(void)getMyUseVoucthersArrayWithproductArr:(NSString *)productArr
                                    Success:(getVouchersSuccess)success
                                       fail:(getVouchersFail)fail
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:productArr forKey:@"productArr"];
    
    [[BaseSservice sharedManager]post1:@"app/coupon/queryMyCouponByProduct.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        NSArray * dataArr =[[dic objectForKey:@"data"]objectForKey:@"array"];
        success(dataArr);
    } failure:^(NSError *error) {
        fail(@"nil");
    }];
}



-(void)getMyUseVoucthersWithproductArr:(NSString *)productArr
                               Success:(getBestVoucherSuccess)success
                                  fail:(getVouchersFail)fail
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:productArr forKey:@"productArr"];
    
    [[BaseSservice sharedManager]post1:@"app/coupon/queryMyCouponByProduct.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        NSArray * dataArr =[[dic objectForKey:@"data"]objectForKey:@"array"];
        if (dataArr.count<1) {
            success(dic);
        }
        [self getBestVouchersWithArr:dataArr Success:success];
    } failure:^(NSError *error) {
        fail(@"nil");
    }];
    
}
-(void)getBestVouchersWithArr:(NSMutableArray*)myMutableArr
                      Success:(getBestVoucherSuccess)success
{
  NSArray *  sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES]];
    [myMutableArr sortUsingDescriptors:sortDescriptors];
    NSLog(@"排序后的数组%@",myMutableArr);
    success([myMutableArr lastObject]);
}

-(NSDictionary *)getChooseVoucherWithArr:(NSArray*)myMutableArr couponNo:(NSString *)couponNo
{
    for (NSDictionary * dic in myMutableArr) {
        NSString * currCouponNo= [dic safeObjectForKey:@"couponNo"];
        if ([currCouponNo isEqualToString:couponNo]) {
            return dic;
        }
    }
    return nil;
}

-(float)getUhpriceWithDict:(NSDictionary *)dict weightPrice:(NSString *)weightStr
{
    if (!dict||[dict allKeys].count<1||![dict isKindOfClass:[NSDictionary class]]) {
        return 0.00;
    }
    if (!weightStr) {
        return 0.00;
    }
    int type = [[dict safeObjectForKey:@"type"]intValue];
    float amount = [[dict safeObjectForKey:@"amount"]floatValue];
    float weightPrice = [weightStr floatValue];
    if (type ==4) {
        return weightPrice;
    }
    else if (type==5)
    {
        return weightPrice-amount>0?amount:weightPrice;
    }else{
        return amount;
    }
}
-(float)getPayAmountWeightWithDict:(NSDictionary *)dict Weight:(NSString*)weightStr
{
    if (!dict||[dict allKeys].count<1||![dict isKindOfClass:[NSDictionary class]]) {
        return [weightStr floatValue];
    }
    if (!weightStr) {
        return 0.00;
    }
    int type = [[dict safeObjectForKey:@"type"]intValue];
    float amount = [[dict safeObjectForKey:@"amount"]floatValue];

    if (type ==4) {
        return 0;
    }
    else if ( type ==5)
    {
        return [weightStr floatValue]-amount>0?[weightStr floatValue]-amount:0;
    }else{
        return [weightStr floatValue];
    }
}



@end
