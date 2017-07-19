//
//  DecailTitleCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "DecailTitleCell.h"

@implementation DecailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didAdd:(id)sender {
    int count  = [self.countLabel.text intValue];
    if (count ==self.restrictionNum) {
        return;
    }
    count++;
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
     [self countChange];
}

- (IBAction)didRed:(id)sender {
    
    int count  = [self.countLabel.text intValue];
    if (count ==1) {
        return;
    }
    count--;
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
    [self countChange];
}

-(void)countChange
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeCount:)]) {
        [self.delegate changeCount:[self.countLabel.text intValue]];
    }
}


@end
