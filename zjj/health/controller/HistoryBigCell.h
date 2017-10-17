//
//  HistoryBigCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/13.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol historySectionCellDelegate;
@interface HistoryBigCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) id<historySectionCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;
@property (weak, nonatomic) IBOutlet UILabel *tzlLb;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
- (IBAction)didShowDetailInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *listTableview;
-(void)setInfoWithDict:(NSDictionary *)dict;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;



@end
@protocol historySectionCellDelegate <NSObject>
-(void)showCellTabWithCell:(HistoryBigCell*)cell;
-(void)didChooseWithCell:(HistoryBigCell *)cell;
@end

