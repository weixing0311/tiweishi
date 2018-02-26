//
//  AddressListCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/18.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressListCell;
@protocol AddressListCellDelegate <NSObject>
-(void)didClickEditWithCell:(AddressListCell*)cell;
-(void)didClickDeleteWithCell:(AddressListCell*)cell;
-(void)didClickChangeDefaultWithCell:(AddressListCell*)cell;
@end
@interface AddressListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
- (IBAction)didDelete:(id)sender;
- (IBAction)didEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
- (IBAction)isDefault:(id)sender;
@property (nonatomic,assign)id<AddressListCellDelegate>delegate;
@end
