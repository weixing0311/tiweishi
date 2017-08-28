//
//  FcBigImgViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/8/25.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface FcBigImgViewController : JFABaseTableViewController
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic,strong)NSMutableArray * images;
@property (nonatomic,assign)int page;
@end
