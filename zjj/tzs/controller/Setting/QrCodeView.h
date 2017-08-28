//
//  QrCodeView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol qrcodeDelegate;
@interface QrCodeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImage;
@property (nonatomic,assign)id<qrcodeDelegate>delegate;
-(void)setInfoWithDict:(NSDictionary *)dict;
- (IBAction)didCopy:(id)sender;
- (IBAction)didClose:(id)sender;

@end
@protocol qrcodeDelegate <NSObject>

-(void)didShareWithUrl:(NSString * )urlStr;

@end
