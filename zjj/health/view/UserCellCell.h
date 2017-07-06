//
//  UserCellCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol userCellDelegate;
@interface UserCellCell : UITableViewCell
@property (nonatomic,assign)id<userCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
- (IBAction)didClickDelete:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
@protocol userCellDelegate <NSObject>

-(void)deleteSubUserWithCell:(UserCellCell*)cell;

@end
