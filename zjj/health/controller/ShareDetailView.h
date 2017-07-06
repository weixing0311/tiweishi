//
//  ShareDataDetailView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareDetailView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet    UILabel     * nameLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * generateTimeLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * testDateLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * weightStatusLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * scaleResultStatusLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * weightLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * trendLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * bodyAgeLabel;
@property (weak, nonatomic) IBOutlet    UILabel     * bmrLabel;
@property (weak, nonatomic) IBOutlet    UIImageView     * headImageView;
@property (weak, nonatomic) IBOutlet    UIImageView     * weightBgImageView;
@property (weak, nonatomic) IBOutlet    UIImageView     * trendArrowImageView;
@property (weak, nonatomic) IBOutlet    UIImageView     * qrCodeImageView;
@property (weak, nonatomic) IBOutlet    UITableView     * tableView;





-(void)setInfo;
@end
