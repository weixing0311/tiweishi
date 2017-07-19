//
//  TZSDGCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDGCell.h"
#import "HDCell.h"
@implementation TZSDGCell
{
    int count ;
    NSMutableArray * hdArr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    count = 0;

    // Initialization code
    

    hdArr= [NSMutableArray array];
    
}
-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tb setTableFooterView:view];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didAdd:(id)sender {
    
    count = [self.countLabel.text intValue];
    count++;
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addCountWithCell:)]) {
        [self.delegate addCountWithCell:self];
    }
}

- (IBAction)didRed:(id)sender {
    count = [self.countLabel.text intValue];
    count--;
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(redCountWithCell:)]) {
        [self.delegate redCountWithCell:self];
    }

}

- (IBAction)didbuy:(id)sender {
}
- (IBAction)didShowCuXDetailView:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showCXDetailWithCell:)]) {
        [self.delegate showCXDetailWithCell:self];
    }
}
@end
