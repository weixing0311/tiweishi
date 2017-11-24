//
//  VouchersTzsDgView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol vouchersTzsDgDelegate;
@interface VouchersTzsDgView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,copy)NSString * productArr;
@property (nonatomic,strong)UIView * contentView;
@property (nonatomic,strong)UILabel * value1lb;
@property (nonatomic,strong)UILabel * value2lb;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)float totalPrice;
@property (nonatomic,assign)float Preferentialprice;
@property (nonatomic,assign)id<vouchersTzsDgDelegate>delegate;
-(void)didshow;
-(void)didhidden;
@end
@protocol vouchersTzsDgDelegate <NSObject>
-(void)didBuyWithDictionary:(NSDictionary *)dict;
@end
