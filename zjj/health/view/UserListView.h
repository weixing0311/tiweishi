//
//  UserListView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol userListDelegate;
@interface UserListView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong)UITableView * userTableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)id<userListDelegate>delegate;
-(void)refreshInfo;
@end
@protocol userListDelegate <NSObject>

-(void)changeShowUserWithSubId:(NSString *)subId isAdd:(BOOL)isAdd;

@end
