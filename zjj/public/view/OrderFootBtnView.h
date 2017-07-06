//
//  OrderFootBtnView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol orderFootBtnViewDelegate;
@interface OrderFootBtnView : UIView
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *diClickFirst;
@property (weak, nonatomic) IBOutlet UIButton *didClickSecond;
@property (nonatomic,assign)id<orderFootBtnViewDelegate>delegate;
-(void)ChangeViewWithStatus:(NSInteger)type;
- (IBAction)didCickFirst:(id)sender;
- (IBAction)didClickSecond:(id)sender;




@end
@protocol orderFootBtnViewDelegate <NSObject>

-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view;
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view;

@end
