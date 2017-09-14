//
//  SuperiorCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "SuperiorCell.h"

@implementation SuperiorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:[[UserModel shareInstance].superiorDict safeObjectForKey:@"headimgurl"]] placeholderImage:getImage(@"headDefault")];
    self.nickNamelb.text =[[UserModel shareInstance].superiorDict safeObjectForKey:@"userName"];
    self.gradeNamelb.text =[[UserModel shareInstance].superiorDict safeObjectForKey:@"gradeName"];
    self.gradeNamelb.adjustsFontSizeToFitWidth = YES;
    self.mblb       .adjustsFontSizeToFitWidth = YES;
    self.mblb.text =[[UserModel shareInstance]changeTelephone:[ [UserModel shareInstance].superiorDict safeObjectForKey:@"phone"] ];
//    phone = 15510106271,
//    nickName = 星星,
//    grade = 3,
//    gradeName = 银牌体脂师,
//    headimgurl = https://zhijj.oss-cn-zhangjiakou.aliyuncs.com/images/head/1503988056559204692.png

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
