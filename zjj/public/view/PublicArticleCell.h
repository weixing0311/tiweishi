//
//  PublicArticleCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadedImageModel.h"
@interface PublicArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleIb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *plbtn;
@property (weak, nonatomic) IBOutlet UIButton *zanbtn;
-(void)setInfoWithDict:(LoadedImageModel *)item;
@end
