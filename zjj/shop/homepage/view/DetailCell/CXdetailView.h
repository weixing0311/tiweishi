//
//  CXdetailView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXdetailView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
-(void)showCuxiaoTabViewWithArray:(NSArray *)arr;

-(void)hiddenCuXiaoTabView;
@end
