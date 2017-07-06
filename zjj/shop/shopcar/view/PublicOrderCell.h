//
//  PublicOrderCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuihuoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tuihuoImage;

@end
