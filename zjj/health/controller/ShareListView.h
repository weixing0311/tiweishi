//
//  ShareTrendView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * generateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel * date1Label;
@property (weak, nonatomic) IBOutlet UILabel * date2Label;
@property (weak, nonatomic) IBOutlet UILabel * dateCountLabel;
@property (weak, nonatomic) IBOutlet UILabel * fatChangeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel * fatChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel * weightChangeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel * weightChangeLabel;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIImageView * qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView * headImageView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * infoArray;
-(void)setInfoWithArr:(NSMutableArray *) arr;
@end
