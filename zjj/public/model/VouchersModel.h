//
//  VouchersModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VouchersModel : NSObject
+(VouchersModel*)shareInstance;
//最佳优惠券
typedef void (^getBestVoucherSuccess)(NSDictionary *dic);
typedef void (^getBestVoucherFail)(NSString  *errorStr);

//所有适用优惠券
typedef void (^getVouchersSuccess)(NSArray *resultArr);
typedef void (^getVouchersFail)(NSString  *errorStr);

///获取所有适用优惠券
-(void)getMyUseVoucthersArrayWithproductArr:(NSString *)productArr
                                    Success:(getVouchersSuccess)success
                                       fail:(getVouchersFail)fail;


///获取最佳优惠券
-(void)getMyUseVoucthersWithproductArr:(NSString *)productArr
                               Success:(getBestVoucherSuccess)success
                                  fail:(getBestVoucherFail)fail;
///优惠券排序后选择最佳
-(void)getBestVouchersWithArr:(NSArray*)arr
                      Success:(getBestVoucherSuccess)success;

///获取选择的优惠券
-(NSDictionary *)getChooseVoucherWithArr:(NSArray*)myMutableArr
                                couponNo:(NSString *)couponNo;
@end
