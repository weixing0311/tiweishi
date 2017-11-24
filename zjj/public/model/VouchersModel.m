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
    
    [[BaseSservice sharedManager]post1:@"app/coupon/queryMyCouponByProduct.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
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






@end
