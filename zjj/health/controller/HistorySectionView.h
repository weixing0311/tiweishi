//
//  HistorySectionView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol historyHeaderDelegate;

@interface HistorySectionView : UIView
@property (nonatomic,assign) id<historyHeaderDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;
@property (weak, nonatomic) IBOutlet UILabel *tzlLb;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
- (IBAction)didShowDetailInfo:(id)sender;
@end
@protocol historyHeaderDelegate <NSObject>
-(void)didShowDetailInfoWithIndex:(int)index;
@end
