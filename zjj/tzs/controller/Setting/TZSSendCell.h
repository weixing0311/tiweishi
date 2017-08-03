//
//  TZSSendCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/28.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TZSSendCellDelegate;
@interface TZSSendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
- (IBAction)didAdd:(id)sender;
- (IBAction)didRed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;//限制Label
@property (weak, nonatomic) IBOutlet UIView *tsView;
@property (nonatomic,assign)id<TZSSendCellDelegate>delegate;
@end
@protocol TZSSendCellDelegate <NSObject>

-(void)didAddWithCell:(TZSSendCell*)cell;
-(void)didRedWithCell:(TZSSendCell*)cell;

@end
