//
//  UserListCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/22.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserListCellGZDelegate;
@interface UserListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nicknamelb;
@property (weak, nonatomic) IBOutlet UIImageView *headerimageView;
@property (weak, nonatomic) IBOutlet UIButton *gzbtn;
@property (weak, nonatomic) IBOutlet UILabel *secondLb;

- (IBAction)didClickGz:(id)sender;
@property (nonatomic,assign)id<UserListCellGZDelegate>delegate;
@end

@protocol UserListCellGZDelegate<NSObject>
-(void)didClickGzBtnWithCell:(UserListCell*)cell;
@end
