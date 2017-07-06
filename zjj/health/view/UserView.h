//
//  UserView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol userViewDelegate;
@interface UserView : UIView
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
- (IBAction)didUserInfo:(id)sender;
- (IBAction)didClickMenu:(id)sender;
@property (nonatomic,assign)id<userViewDelegate>delegate;

@end
@protocol userViewDelegate <NSObject>

-(void)showUserList;

@end
