//
//  DecailTitleCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol decailTitleCellDelegate;
@interface DecailTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cxtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,assign)int restrictionNum;

- (IBAction)didAdd:(id)sender;
- (IBAction)didRed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasingLabel;
@property (nonatomic,assign)id<decailTitleCellDelegate>delegate;
@end
@protocol decailTitleCellDelegate <NSObject>

-(void)changeCount:(int)count;

@end
