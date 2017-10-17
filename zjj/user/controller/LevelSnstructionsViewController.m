//
//  LevelSnstructionsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "LevelSnstructionsViewController.h"

@interface LevelSnstructionsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgTiaolb;
@property (weak, nonatomic) IBOutlet UIView *Lv1View;
@property (weak, nonatomic) IBOutlet UIView *lv2View;
@property (weak, nonatomic) IBOutlet UIView *lv3View;
@property (weak, nonatomic) IBOutlet UIView *lv4View;
@property (weak, nonatomic) IBOutlet UIView *lv5View;
@property (weak, nonatomic) IBOutlet UIView *cbgView;

@end

@implementation LevelSnstructionsViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoDict =[NSDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBWhiteColor];
    // Do any additional setup after loading the view from its nib.
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:getImage(@"head_default")];
    self.headImageView.layer.borderWidth= 2;
    self.headImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;

    [self buildCurr];
    
    int  countIntegral = [[self.infoDict objectForKey:@"countIntegral"]intValue];
    int  CurrentInegral = 0;
    NSString * currentLevel;
    NSArray * arr = [self.infoDict objectForKey:@"integeralGrade"];
    float width = 100;

    
    NSMutableArray * bigArr =[NSMutableArray array];
    NSArray * array = [self.infoDict objectForKey:@"integeralGrade"];
    for (int i =0; i<array.count; i++) {
        NSDictionary * dic = [arr objectAtIndex:i];
        int  integral = [[dic objectForKey:@"integral"]intValue];
        if (countIntegral<integral) {
            [bigArr addObject:dic];
        }
    }
    DLog(@"bigArr--%@",bigArr);
    if (bigArr.count==0) {
        self.titleLabel.text =[NSString stringWithFormat:@"%@",@"您已达到最高级"];
        width = self.bgTiaolb.frame.size.width;

    }else{
        NSDictionary * currDic = [arr objectAtIndex:(arr.count-bigArr.count)];
        
        int jf1 = [[currDic objectForKey:@"integral"]intValue];
        
        CurrentInegral = jf1-countIntegral;
        int  integral = [[currDic objectForKey:@"integral"]intValue];
        
        CurrentInegral =integral-countIntegral;
        currentLevel = [currDic objectForKey:@"gradeName"];
        self.titleLabel.text =[NSString stringWithFormat:@"还差%d积分升级到%@", CurrentInegral,currentLevel];

        width = self.bgTiaolb.frame.size.width/arr.count*(arr.count-1-bigArr.count)+self.bgTiaolb.frame.size.width/8*((1000-CurrentInegral)/1000);

    }
    
    
//    float width = countIntegral/[[[arr lastObject]objectForKey:@"integral"]intValue]*(JFA_SCREEN_WIDTH-100);
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50+width, 5)];
    view.backgroundColor = [UIColor whiteColor];
    [self.bgTiaolb addSubview:view];

    
    
    
}
-(void)buildCurr
{
    NSArray * arr = [_infoDict safeObjectForKey:@"integeralGrade"];
    for (int i =0; i<arr.count; i++) {
        UIView * dianView = [[UIView alloc]initWithFrame:CGRectMake(30+(JFA_SCREEN_WIDTH-50)/arr.count*i-5, 36, 10, 10)];
        dianView.layer.cornerRadius = 5;
        dianView.layer.masksToBounds = YES;
        dianView.backgroundColor = [UIColor whiteColor];
        UILabel * lb =[[UILabel alloc]initWithFrame:CGRectMake(dianView.center.x-15, 57, 30, 15)];
        lb.text = [NSString stringWithFormat:@"%d级",i+1];
        
        [_cbgView addSubview:dianView];
        [_cbgView addSubview:lb];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
