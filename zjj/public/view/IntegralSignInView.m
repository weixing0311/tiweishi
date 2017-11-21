//
//  IntegralSignInView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "IntegralSignInView.h"

@implementation IntegralSignInView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setSignInInfo];
    
    if ([[UserModel shareInstance]getSignInNotifacationStatus]==YES) {
        self.remindBtn.selected = YES;
    }else{
        self.remindBtn.selected = YES;
    }
}

-(void)setSignInInfo
{
    NSMutableDictionary * params  =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryTaskRule.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        NSArray * arr = [[dic objectForKey:@"data"]objectForKey:@"array"];
        for (int i =0; i<arr.count; i++) {
            NSDictionary * dic = arr[i];
            [self getdayLabelWithIndex:i].text =[NSString stringWithFormat:@"第%@天",[dic safeObjectForKey:@"days"]];
            [self getIntegralLabelWithIndex:i].text =[NSString stringWithFormat:@"+%@",[arr[i]objectForKey:@"Integral"]];
            NSString * status = [dic safeObjectForKey:@"status"];
            [self selectedItemWithIndex:i status:status];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)selectedItemWithIndex:(int)index status:(NSString *)status
{
    if ([status isEqualToString:@"1"]) {
        [self getdayLabelWithIndex:index].backgroundColor =HEXCOLOR(0x9b9b9b);
        [self getIntegralLabelWithIndex:index].textColor =HEXCOLOR(0x666666);
    }else{
        [self getdayLabelWithIndex:index].backgroundColor =HEXCOLOR(0xe63a46);
        [self getIntegralLabelWithIndex:index].textColor =HEXCOLOR(0xe63a46);
    }
}



-(UILabel *)getdayLabelWithIndex:(int)index
{
    switch (index) {
        case 0:
            return _day1lb;
            break;
        case 1:
            return _day2lb;
            break;
        case 2:
            return _day3lb;
            break;
        case 3:
            return _day4lb;
            break;
        case 4:
            return _day5lb;
            break;
        case 5:
            return _day6lb;
            break;

        default:
            break;
    }
    return nil;
}
-(UILabel *)getIntegralLabelWithIndex:(int)index
{
    switch (index) {
        case 0:
            return _integral1lb;
            break;
        case 1:
            return _integral2lb;
            break;
        case 2:
            return _integral3lb;
            break;
        case 3:
            return _integral4lb;
            break;
        case 4:
            return _integral5lb;
            break;
        case 5:
            return _integral6lb;
            break;
            
        default:
            break;
    }
    return nil;
}
- (IBAction)didClickClose:(id)sender {
    self.hidden = YES;
    [self removeFromSuperview];
}

- (IBAction)didClickRemind:(id)sender {
    
    if (self.remindBtn.selected ==YES) {
         [[UserModel shareInstance]changeUserDefaultWithSignInType:1];
        self.remindBtn.selected =NO;
    }else{
        self.remindBtn.selected =YES;
        [[UserModel shareInstance]changeUserDefaultWithSignInType:2];
        
    }
}




- (IBAction)didClickSignIn:(id)sender {
    if (self.signInBtn.selected ==YES) {
        return;
    }
    [self didSignIn];
}

-(void)didSignIn
{
    NSMutableDictionary * params  = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"taskId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];

    [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        DLog(@"签到success-dic:%@",dic);
        [[UserModel shareInstance]showSuccessWithStatus:@"签到成功！"];
        self.signInBtn.selected = YES;
        self.signInBtn.backgroundColor = HEXCOLOR(0x9b9b9b);
        self.hidden = YES;
        [self removeFromSuperview];
    } failure:^(NSError *error) {
        DLog(@"签到失败-error:%@",error);
    }];
}
@end
