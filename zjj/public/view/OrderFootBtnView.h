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
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (nonatomic,assign)id<orderFootBtnViewDelegate>myDelegate;
-(void)ChangeViewWithStatus:(NSInteger)type;
- (IBAction)didCickFirst:(id)sender;
- (IBAction)didClickSecond:(id)sender;




@end
@protocol orderFootBtnViewDelegate <NSObject>

-(void)didClickFirstBtnWithView:(OrderFootBtnView*)view;
-(void)didClickSecondBtnWithView:(OrderFootBtnView*)view;

@end
