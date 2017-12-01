//
//  MyVouchersCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MyVouchersCell.h"

@implementation MyVouchersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(NSString*)getlimitWithArr:(NSArray *)arr
{
    NSString * limitStr = @"";
    if (!arr&&arr.count<1) {
        limitStr = @"(无限制)";
        return limitStr;
    }
    if (arr.count>0) {
        for (int i =0; i<arr.count; i++) {
            NSDictionary * dic = [arr objectAtIndex:i];
            limitStr = [NSString stringWithFormat:@"%@%@%@",limitStr,i==0?@"":@",",[dic safeObjectForKey:@"productName"]];
        }
        limitStr = [NSString stringWithFormat:@"(仅限%@使用)",limitStr];
    }
    return limitStr;
}
- (NSString *)formatFloat:(float)f
{
    int fi=(int)f;
    if(f==fi)
        return [NSString stringWithFormat:@"%d",fi];
    else
        return [NSString stringWithFormat:@"%.1f",f];
    
}

-(void)setDidUserHidden:(BOOL)hidden
{
    self.didUseBtn.hidden = hidden;
    self.limitGoodslb.hidden = hidden;
    self.limit2Goodslb.hidden = !hidden;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickUse:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didUserVoucherWithCell:)]) {
        [self.delegate didUserVoucherWithCell:self];
    }
}
@end
