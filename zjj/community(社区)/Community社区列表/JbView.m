//
//  JbView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JbView.h"

@implementation JbView
{
    NSArray *  infoArr;
    UIView * whiteView;
    NSDictionary * chooseDict;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(1, 1, 1, 0.6);
        infoArr = [NSArray array];
        chooseDict = [NSDictionary dictionary];
        whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 220)];
        whiteView.center = CGPointMake(JFA_SCREEN_WIDTH/2, JFA_SCREEN_HEIGHT/2-80);
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        [self buildTitleView];
        [self getJbInfo];
    }
    return self;
}
-(void)getJbInfo
{
    [[BaseSservice sharedManager]post1:@"app/reportArticle/getReportType.do" HiddenProgress:YES paramters:nil success:^(NSDictionary *dic) {
        NSArray * arr = [[dic safeObjectForKey:@"data"]objectForKey:@"array"];
        [self buildViewsWithArr:arr];
    } failure:^(NSError *error) {
        
    }];
}

-(void)buildTitleView
{
    UILabel * titlelb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    titlelb.font = [UIFont systemFontOfSize:15];
    titlelb.text = @"举报原因";
    [whiteView addSubview:titlelb];
    
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH-40, 0, 40, 40)];
    [closeBtn setImage:getImage(@"close_") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hiddenMe) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    
    
}

-(void)buildViewsWithArr:(NSArray *)arr
{
    infoArr  = arr;
    for (int i =0; i<arr.count; i++) {
        
        NSDictionary * dic = [arr objectAtIndex:i];
        NSString * title = [dic safeObjectForKey:@"reportName"];
        UIView * view = [self buildCellWithTitle:title index:i];
        view.frame  = CGRectMake(JFA_SCREEN_WIDTH/2*(i%2),50+ i/2*30, JFA_SCREEN_WIDTH/2, 20);
        [whiteView addSubview:view];
    }
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4-30, 180, 60, 30)];
    [cancelBtn addTarget:self action:@selector(hiddenMe) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [whiteView addSubview:cancelBtn];
   
    UIButton * setUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/4*3-30, 180, 60, 30)];
    [setUpBtn addTarget:self action:@selector(didJb) forControlEvents:UIControlEventTouchUpInside];
    [setUpBtn setTitle:@"举报" forState:UIControlStateNormal];
    [setUpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [whiteView addSubview:setUpBtn];

}

-(UIView *)buildCellWithTitle:(NSString *)title index:(NSInteger)index
{
    UIView * cellView =[[UIView alloc]init];
    UIButton * button = [UIButton new];
    [button addTarget:self action:@selector(chooseJbInfo:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index+1;
    [button setImage:getImage(@"checked-false") forState:UIControlStateNormal];
    [button setImage:getImage(@"checked-true") forState:UIControlStateSelected];
    [cellView addSubview:button];

    
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.textColor = HEXCOLOR(0x666666);
    titleLabel.font = [UIFont systemFontOfSize:13];
    [cellView addSubview:titleLabel];
    
    
    button.sd_layout
    .leftSpaceToView(cellView, 20)
    .topSpaceToView(cellView, 0)
    .bottomSpaceToView(cellView, 0)
    .widthIs(20);
    
    titleLabel.sd_layout
    .leftSpaceToView(button, 10)
    .topSpaceToView(cellView, 0)
    .bottomSpaceToView(cellView, 0)
    .rightSpaceToView(cellView, 5);
    
    [self setupAutoHeightWithBottomView:titleLabel bottomMargin:0];

    return cellView;
}
-(void)chooseJbInfo:(UIButton *)sender
{
    for ( int i =0; i<infoArr.count; i++) {
            UIButton * button = (UIButton *)[self viewWithTag:i+1];
            if (button.tag ==sender.tag) {
                button.selected =YES;
                
                chooseDict = infoArr[i];
            }else{
                button.selected =NO;
            }
    }
}
-(void)hiddenMe
{
    self.hidden = YES;
    [self removeFromSuperview];
    
}
-(void)didJb
{
    if (!chooseDict||[chooseDict allKeys].count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择举报内容"];
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.articleId forKey:@"articleId"];
    [params safeSetObject:[chooseDict safeObjectForKey:@"reportName"] forKey:@"reportContent"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [[BaseSservice sharedManager]post1:@"app/reportArticle/updateIsreported.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"您已成功举报"];
        [self hiddenMe];
    } failure:^(NSError *error) {
        
    }];

}
//- (IBAction)didClickChoose:(UIButton *)sender {
//    for (int i = 1; i<9; i++) {
//        UIButton * button = (UIButton *)[self viewWithTag:i];
//        if (button.tag ==sender.tag) {
//            button.selected =YES;
//        }else{
//            button.selected =NO;
//        }
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
