//
//  ArticleDetailViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import "CommunityModel.h"
@protocol ArticleDetailDelegate;
@interface ArticleDetailViewController : JFABaseTableViewController
@property (nonatomic,strong)CommunityModel * infoModel;
@property (nonatomic,assign)id<ArticleDetailDelegate>delegate;
@end
@protocol ArticleDetailDelegate <NSObject>
-(void)refreshCommentWithModel:(CommunityModel *)model;
@end
