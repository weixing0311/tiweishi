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
    // Do any additional setup after loading the view from its nib.
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] placeholderImage:getImage(@"head_default")];
    self.headImageView.layer.borderWidth= 2;
    self.headImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;

    
    
    int  countIntegral = [[self.infoDict objectForKey:@"countIntegral"]intValue];
    int  CurrentInegral = 0;
    NSString * currentLevel;
    NSArray * arr = [self.infoDict objectForKey:@"integeralGrade"];
    for (int i =0; i<arr.count; i++) {
        if (i==0) {
            NSDictionary * dic = [arr objectAtIndex:i];
            int  integral = [[dic objectForKey:@"integral"]intValue];
            if (countIntegral<integral) {
                CurrentInegral = integral-countIntegral;
                currentLevel = [dic objectForKey:@"gradeName"];
            }
        }
        else if (i==arr.count-1)
        {
            NSDictionary * dic = [arr objectAtIndex:i];
            int  integral = [[dic objectForKey:@"integral"]intValue];
            if (countIntegral>=integral) {
                CurrentInegral = 0;
                currentLevel = [dic objectForKey:@"gradeName"];

            }

        }
        else{
            NSDictionary * dic1 = [arr objectAtIndex:i];
            int  integral1 = [[dic1 objectForKey:@"integral"]intValue];
            NSDictionary * dic2 = [arr objectAtIndex:i-1];
            int  integral2 = [[dic2 objectForKey:@"integral"]intValue];

            
            if (countIntegral<integral1&&countIntegral>integral2) {
                CurrentInegral = integral1-countIntegral;
                currentLevel = [dic1 objectForKey:@"gradeName"];

            }
            

        }
        
    }
    
    if (CurrentInegral ==0) {
        self.titleLabel.text =[NSString stringWithFormat:@"%@",@"您已达到最高级"];
    }else{
        self.titleLabel.text =[NSString stringWithFormat:@"还差%d积分升级到%@", CurrentInegral,currentLevel];
    }
    
    
    
    
//    float width = countIntegral/[[[arr lastObject]objectForKey:@"integral"]intValue]*(JFA_SCREEN_WIDTH-100);
    float width = 100;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 5)];
    view.backgroundColor = [UIColor whiteColor];
    [self.bgTiaolb addSubview:view];

    
    
    
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
