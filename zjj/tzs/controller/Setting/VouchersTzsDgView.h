//
//  VouchersTzsDgView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/11/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VouchersTzsDgView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,copy)NSString * productArr;
@property (nonatomic,strong)UIView * contentView;
@property (nonatomic,strong)NSMutableArray * dataArray;
-(void)didshow;
-(void)didhidden;
@end
