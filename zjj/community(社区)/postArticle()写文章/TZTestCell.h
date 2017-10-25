//
//  TZTestCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZTestCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;
@end
