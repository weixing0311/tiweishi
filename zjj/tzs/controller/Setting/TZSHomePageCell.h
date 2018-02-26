//
//  TZSHomePageCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/1/22.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZSHomePageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
