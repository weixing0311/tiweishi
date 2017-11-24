//
//  HealthDetailsItem.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthDetailsItem.h"
#import "HealthModel.h"
static HealthDetailsItem *item;
@implementation HealthDetailsItem
+(HealthDetailsItem *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        item = [[HealthDetailsItem alloc]init];
    });
    return item;
}
-(void)getInfoWithDict:(NSDictionary *)dict
{
    
    self . DataId                = [[dict safeObjectForKey:@"DataId"]intValue];
    self . userId                = [[dict safeObjectForKey:@"userId"]intValue];
    self . subUserId             = [[dict safeObjectForKey:@"subUserId"]intValue];
    self . createTime            = [ dict safeObjectForKey:@"createTime"];
    self . score                 = [[dict safeObjectForKey:@"score"]floatValue];
    
    self . lastWeight            = [[dict safeObjectForKey:@"lastWeight"]floatValue];
    
    
    
    self . weight                = [[dict safeObjectForKey:@"weight"]floatValue];
    self . weightLevel           = [[dict safeObjectForKey:@"weightLevel"]intValue];
    self . bmi                   = [[dict safeObjectForKey:@"bmi"]floatValue];
    self . bmiLevel              = [[dict safeObjectForKey:@"bmiLevel"]intValue];
    self . mVisceralFat          = [[dict safeObjectForKey:@"mVisceralFat"]intValue];
    self . visceralFatPercentage = [[dict safeObjectForKey:@"visceralFatPercentage"]floatValue];
    
    
    self . visceralFatPercentageLevel = [[dict safeObjectForKey:@"visceralFatPercentageLevel"]floatValue];
    self . bmr                   = [[dict safeObjectForKey:@"bmr"]floatValue];
    self . bmrMin                = [[dict safeObjectForKey:@"bmrMin"]floatValue];
    self . bmrMax                = [[dict safeObjectForKey:@"bmrMax"]floatValue];
    self.bmrLevel                = [[dict safeObjectForKey:@"bmrLevel"]intValue];
    self . bodyAge               = [[dict safeObjectForKey:@"bodyAge"]floatValue];
    self . bodyLevel             = [[dict safeObjectForKey:@"bodyLevel"]intValue];
    
    
    
    self . mFat                  = [[dict safeObjectForKey:@"mFat"]floatValue];
    self . fatWeight             = [[dict safeObjectForKey:@"fatWeight"]floatValue];
    self . fatWeightMax          = [[dict safeObjectForKey:@"fatWeightMax"]floatValue];
    self . fatWeightMin          = [[dict safeObjectForKey:@"fatWeightMin"]floatValue];
    self . fatWeightLevel        = [[dict safeObjectForKey:@"fatWeightLevel"]intValue];
    
    
    self . mWater                = [[dict safeObjectForKey:@"mWater"]floatValue];
    self . waterWeight           = [[dict safeObjectForKey:@"waterWeight"]floatValue];
    self . waterWeightMax        = [[dict safeObjectForKey:@"waterWeightMax"]floatValue];
    self . waterWeightMin        = [[dict safeObjectForKey:@"waterWeightMin"]floatValue];
    self . waterLevel            = [[dict safeObjectForKey:@"waterLevel"]intValue];
 
    
    self . proteinWeight         = [[dict safeObjectForKey:@"proteinWeight"]floatValue];
    self . proteinWeightMax      = [[dict safeObjectForKey:@"proteinWeightMax"]floatValue];
    self . proteinWeightMin      = [[dict safeObjectForKey:@"proteinWeightMin"]floatValue];
    self . proteinLevel          = [[dict safeObjectForKey:@"proteinLevel"]intValue];
  
    
    self . mBone                 = [[dict safeObjectForKey:@"mBone"]floatValue];
    self . boneWeight            = [[dict safeObjectForKey:@"boneWeight"]floatValue];
    self . boneWeightMax         = [[dict safeObjectForKey:@"boneWeightMax"]floatValue];
    self . boneWeightMin         = [[dict safeObjectForKey:@"boneWeightMin"]floatValue];
    self . boneLevel             = [[dict safeObjectForKey:@"boneLevel"]intValue];
 
    
    self . mMuscle               = [[dict safeObjectForKey:@"mMuscle"]floatValue];
    self . muscleWeight          = [[dict safeObjectForKey:@"muscleWeight"]floatValue];
    self . muscleWeightMax       = [[dict safeObjectForKey:@"muscleWeightMax"]floatValue];
    self . muscleWeightMin       = [[dict safeObjectForKey:@"muscleWeightMin"]floatValue];
    self . muscleLevel           = [[dict safeObjectForKey:@"muscleLevel"]intValue];
    

    self . mCalorie              = [[dict safeObjectForKey:@"mCalorie"]intValue];
    self . fatPercentage         = [[dict safeObjectForKey:@"fatPercentage"]floatValue]*100;
    self . fatPercentageMax      = [[dict safeObjectForKey:@"fatPercentageMax"]floatValue]*100;
    self . fatPercentageMin      = [[dict safeObjectForKey:@"fatPercentageMin"]floatValue]*100;
    self . fatPercentageLevel    = [[dict safeObjectForKey:@"fatPercentageLevel"]intValue];
    

    
    self . boneMuscleLevel       = [[dict safeObjectForKey:@"boneMuscleLevel"]intValue];
    self . boneMuscleWeight      = [[dict safeObjectForKey:@"boneMuscleWeight"]floatValue];
    self . boneMuscleWeightMax   = [[dict safeObjectForKey:@"boneMuscleWeightMax"]floatValue];
    self . boneMuscleWeightMin   = [[dict safeObjectForKey:@"boneMuscleWeightMin"]floatValue];
    self . boneLevel             = [[dict safeObjectForKey:@"boneLevel"]intValue];
    
    self . standardWeight          = [[dict safeObjectForKey:@"standardWeight"]floatValue];
    self . weightControl           = [[dict safeObjectForKey:@"weightControl"]floatValue];
    self . lbm                     = [[dict safeObjectForKey:@"lbm"]floatValue];
    self . fatControl              = [[dict safeObjectForKey:@"fatControl"]floatValue];

    
    self . normal                = [[dict safeObjectForKey:@"normal"]intValue];
    self . warn                  = [[dict safeObjectForKey:@"warn"]intValue];
    self . serious               = [[dict safeObjectForKey:@"serious"]intValue];
    
    self . height                  = [[dict safeObjectForKey:@"height"]intValue];
    self . age                     = [[dict safeObjectForKey:@"age"]intValue];

    self . ranking                 = [[dict safeObjectForKey:@"ranking"]intValue];
    self . percent                 = [[dict safeObjectForKey:@"percent"]floatValue];
    self . myScore                 = [[dict safeObjectForKey:@"score"]floatValue];
    
}


-(NSMutableDictionary *)setSliderInfoWithRow:(NSInteger)row btnTag:(NSInteger)btnTag
{
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    
    if (btnTag ==4&&row ==1) {
        [dic setObject:@"markbg2" forKey:@"markBg"];
    }else{
        [dic setObject:@"markBg" forKey:@"markBg"];
        
    }
    float x =0.0f;
    
    
    switch (row) {
        case 0:
            switch (btnTag) {
                case 1:
                    [dic safeSetObject:[NSString stringWithFormat:@"18.5"] forKey:@"lowText"] ;
                    [dic safeSetObject:[NSString stringWithFormat:@"24.0"] forKey:@"HeightText"];;
                    x = [self getLocationWithMax:24.0
                                             Min:18.5
                                            info:[HealthDetailsItem instance].bmi ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_BMI] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_BMI] forKey:@"color"];
                    
                    break;
                case 2:
                    
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1f%%",[HealthDetailsItem instance].fatPercentageMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1f%%",[HealthDetailsItem instance].fatPercentageMin] forKey:@"lowText"];
                    x = [self getLocationWithMax:[HealthDetailsItem instance].fatPercentageMax
                                             Min:[HealthDetailsItem instance].fatPercentageMin
                                            info:[HealthDetailsItem instance].fatPercentage ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_FATPERCENT] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_FATPERCENT] forKey:@"color"];
                    break;
                case 3:
                    
                    
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatWeightMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].fatWeightMin] forKey:@"lowText"];
                    x = [self getLocationWithMax:[HealthDetailsItem instance].fatWeightMax
                                             Min:[HealthDetailsItem instance].fatWeightMin
                                            info:[HealthDetailsItem instance].fatWeight ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_FAT] forKey:@"info"];
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_FAT] forKey:@"color"];

                    break;
                case 4:

                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].waterWeightMax] forKey:@"HeightText"];

                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].waterWeightMin] forKey:@"lowText"];;
                    x = [self getLocationWithMax:[HealthDetailsItem instance].waterWeightMax
                                             Min:[HealthDetailsItem instance].waterWeightMin
                                            info:[HealthDetailsItem instance].waterWeight ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_WATER] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_WATER] forKey:@"color"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (btnTag) {
                case 1:
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].proteinWeightMin] forKey:@"lowText"];
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].proteinWeightMax] forKey:@"HeightText"]; ;
                    
                    x = [self getLocationWithMax:[HealthDetailsItem instance].proteinWeightMax
                                             Min:[HealthDetailsItem instance].proteinWeightMin
                                            info:[HealthDetailsItem instance].proteinWeight ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_PROTEIN] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_PROTEIN] forKey:@"color"];
                    break;
                case 2:
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].muscleWeightMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].muscleWeightMin] forKey:@"lowText"];
                    
                    x = [self getLocationWithMax:[HealthDetailsItem instance].muscleWeightMax
                                             Min:[HealthDetailsItem instance].muscleWeightMin
                                            info:[HealthDetailsItem instance].muscleWeight ];
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_MUSCLE] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_MUSCLE] forKey:@"color"];
                    break;
                case 3:
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].boneMuscleWeightMax] forKey:@"HeightText"];;
                    [dic safeSetObject:[NSString stringWithFormat:@"%.1fkg",[HealthDetailsItem instance].boneMuscleWeightMin] forKey:@"lowText"]; ;
                    
                    x = [self getLocationWithMax:[HealthDetailsItem instance].boneMuscleWeightMax
                                             Min:[HealthDetailsItem instance].boneMuscleWeightMin
                                            info:[HealthDetailsItem instance].boneMuscleWeight ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_BONEMUSCLE] forKey:@"info"];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_BONEMUSCLE] forKey:@"color"];
                    break;
                case 4:
                    [dic safeSetObject:[NSString stringWithFormat:@"14.0"] forKey:@"HeightText"]; ;
                    [dic safeSetObject:[NSString stringWithFormat:@"10.0"] forKey:@"lowText"];
                    
                    
                    x = [self getLocationWithMax:14.0 Min:10.0  info:[HealthDetailsItem instance].visceralFatPercentage ];
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getStatus:IS_MODEL_VISCERALFAT] forKey:@"info"];
                    
                    
                    
                    
                    [dic safeSetObject:[[HealthModel shareInstance]getHealthDetailColorWithStatus:IS_MODEL_VISCERALFAT] forKey:@"color"];
                    break;
                    
                default:
                    break;
            }
            
            break;
        default:
            break;
    }
    
    [dic setObject:@(x) forKey:@"x"];
    return dic;
    
}

-(float)getLocationWithMax:(float)maxdd Min:(float)mindd info:(float)locinfo
{
    
    DLog(@"%.1f---%.1f",maxdd,locinfo);
    float width = JFA_SCREEN_WIDTH-26;
    
    float onedd = width/3/(maxdd-mindd);
    
    /*
     width =300;
     onedd = 25;
     100-100/4*1
     =100*3/4 =75
     
     */
    
    if (locinfo<mindd) {
        
        if (width/3-onedd*(mindd-locinfo)<0) {
            return 13;
        }else{
         return  13+width/3-onedd*(mindd-locinfo);
        }
        
        
    }else if (locinfo>=mindd&&locinfo <maxdd)
    {
        return 13+width/3+(locinfo-mindd)*onedd;
    }else{
        if ((locinfo-maxdd)*onedd>width/3) {
            return width;
        }else{
            return 13+width/3*2+(locinfo-maxdd)*onedd;
        }
    }
    
    
    
}

-(UIColor *)getHealthDetailColorWithStatus:(mytype)myType
{
    switch (myType) {
        case IS_MODEL_BMI:
            if ([HealthDetailsItem instance].bmi<18.5) {
                
            }
            else if (([HealthDetailsItem instance].bmi>=18.5&&([HealthDetailsItem instance].bmi<24)))
            {
                
            }else
            {
                
            }
            break;
        case IS_MODEL_FATPERCENT:
            break;
        case IS_MODEL_FAT:
            break;
        case IS_MODEL_WATER:
            break;
        case IS_MODEL_PROTEIN:
            
            
            break;
        case IS_MODEL_MUSCLE:
            
            
            break;
        case IS_MODEL_BONEMUSCLE:
            break;
            
            
        case IS_MODEL_VISCERALFAT:
            break;
            
        default:
            break;
    }
    return nil;
}

-(NSString *)getinstructionsWithType:(NSInteger)index
{
    switch (index) {
        case 1:
            return @"体脂率是指人体内脂肪重量在人体总体重中所占的比例，又称体脂百分数，它反映人体内脂肪含量的多少。";

            break;
        case 2:
            return   @"脂肪量是指身体成分中，脂肪组织所占的重量。测量脂肪量比单纯的只测量体重更能反映我们身体的脂肪水平。";
            
            break;
        case 3:
            return @"内脏脂肪是人体脂肪中的一种。它与皮下脂肪（也就是我们平时所了解的身体上可以摸得到的“肥肉”） 不同，它围绕着人的脏器，主要存在于腹腔内。一定量的内脏脂肪其实是人体必需的，因为内脏脂肪围绕着人的脏器，对人的内脏起着支撑、稳定和保护的作用。";

            
            break;

        case 4:
            return @"肌肉，主要由肌肉组织构成。 肌肉细胞的形状细长，呈纤维状，故肌肉细胞通常称为肌纤维。中医理论中，肌肉指身体肌肉组织和皮下脂肪组织的总称。";

            
            break;

        case 5:
            return @"蛋白质是组成人体一切细胞、组织的重要成分。机体所有重要的组成部分都需要有蛋白质的参与，蛋白质是生命的物质基础，是构成细胞的基本有机物，是生命活动的主要承担者。没有蛋白质就没有生命。";

            
            break;

        case 6:
            return @"骨量是指是单位体积内，骨组织和骨基质含量。骨量是用来代表骨骼的健康情况。不同年龄时间段人体骨量是不同的，增加骨量不仅要补钙，还要补充胶原蛋白。";

            
            break;

        case 7:
            return @"BMI是Body Mass Index 的缩写，BMI中文是“体质指数”的意思，是以您的身高体重计算出来的。BMI是世界公认的一种评定肥胖程度的分级方法，主要用于统计，当需要比较及分析一个人的体重对于不同高度的人所带来的健康影响时，BMI值是一个中立而可靠的指标，是国际上常用的衡量人体胖瘦程度以及是否健康的一个标准。";

            
            break;

        case 8:
            return @"骨骼肌是肌肉的一种。属于横纹肌，横纹肌还包括心肌与内脏横纹肌，其中骨骼肌主要分布于四肢，人体共有600多块骨骼肌，约占全身重量的40%。";
            
            break;

        case 9:
            return @"水分是指组成身体的各项物质所包含的水分。";

            break;

        default:
            break;
    }
    return nil;
}

-(NSString *)getHealthDetailShuoMingWithStatus:(NSInteger)myType item:(HealthDetailsItem*)item
{
    
    //    SubProjectItem * subItem = [[SubProjectItem alloc]init];
    switch (myType) {
        case 1:
            //    fatPercentage level  1正常2低3高
            
            switch (item.fatPercentageLevel) {
                case 1:
                    return @"您身体的体脂率处于标准状态，建议您继续保持，不要刻意减脂与增重，要注重均衡发展，在锻炼时要注意补充身体所需要的营养。";
                    break;
                case 2:
                    return @"您身体的体脂率偏低，当前身体状况比较健康，但是可能会引起身体某些功能的失调，体脂率过低对人体也是无益处的，如果您不是专业运动员或喜欢健身的话，还是建议您进行适当的增肌，增加自身体脂率。";
                    break;
                case 3:
                    return @"您目前的体脂率处于偏高的状态，建议您在饮食时减少油脂与糖类的摄入，并且每天进行半小时的有氧运动以促进脂肪的消耗。";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case 2:
            //    fatweightlevel  1正常2低3高
            switch (item.fatWeightLevel) {
                case 1:
                    return @"您身体的脂肪量处于标准状态，表示您的身体状况处于比较好的阶段，但是还是要未雨绸缪奥，在饮食上不要太放肆奥，多锻炼总是没有坏处的。";
                    break;
                case 2:
                    return @"您的脂肪量比较低，这代表着您身体比较健康，肥胖人群可能会患的各种疾病都与你没有关系，继续保持奥~";
                    break;
                case 3:
                    return @"您目前身体的脂肪量偏高，建议您少吃高油脂类的食物，多吃蔬菜水果，每天进行半小时的有氧运动会使您的身体状况更好。";
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:
            //            内脂  1正常2超标3高
            
            switch (item.visceralFatPercentageLevel) {
                case 1:
                    return @"您目前的内脏脂肪属于标准状态，建议您继续保持当前的饮食习惯与运动习惯，不要因为现在的状态比较好就心生懈怠奥，内脏脂肪过低或过高都会对身体造成很大的危害呢！";
                    break;
                case 2:
                    return @"您目前的内脏脂肪偏高，内脏脂肪过高容易引起各种心血管疾病，建议您多做运动，游泳、慢跑、快步走都是降低内脏脂肪的好方法。";
                    break;
                case 3:
                    return @"您目前的内脏脂肪偏高，内脏脂肪过高容易引起各种心血管疾病，建议您多做运动，游泳、慢跑、快步走都是降低内脏脂肪的好方法。";
                    break;
                default:
                    break;
            }
            
            break;
            
        case 4:
            switch (item.muscleLevel) {
                case 1:
                    return @"您身体内所含的肌肉量处于标准状态，肌肉是身体消耗能量的主力军，充足的肌肉量能让您更快的消耗热量，以健康的方式减掉多余的脂肪。";
                    break;
                case 2:
                    return @"您身体内所含的肌肉量较低，肌肉量过低会引发基础代谢降低，热量消耗随之降低，摄入的过多热量就会在身体内转化成脂肪，形成肥胖，建议您每天进行适当的锻炼，增加肌肉量。";
                    break;
                    
                    
                default:
                    break;
            }
            
            
            break;
            
            
            
        case 5:
            //    蛋白质(P)/骨骼肌(boneMuscle)/骨量(boneWeight)/水分(waterWieghtLevel)/肌肉(Muscle)  1正常 else低
            
            switch (item.proteinLevel) {
                case 1:
                    return @"您身体内所含的蛋白质处于标准状态，这代表您身体的各方面机能都属于良好状态，保持住当前的饮食习惯与睡眠时间奥。";
                    break;
                case 2:
                    return @"您身体所含的蛋白质较低，如果人体所含蛋白质过低的话会引发免疫力低下，脱发、记忆力衰弱、肌肉无力、容易疲惫等，建议您多吃鸡蛋白、牛奶和豆类制品，这些都富含优秀的蛋白质营养，且脂肪含量较低奥。";
                    break;
                default:
                    break;
            }
            
            
            
            break;
            
        case 6:
            
            switch (item.boneLevel) {
                case 1:
                    return @"您目前的骨量属于标准状态，这代表您身体内的钙含量比较标准，骨质疏松之类的疾病会远离您的身体";
                    break;
                case 2:
                    return @"您目前的骨量较低，这可能会引发经常性抽筋，而且骨量过低会比较容易骨折，一建议您多吃含钙量高的食物，二建议您多补充胶原蛋白，多吃猪皮，鱼类，鸡爪等食物，三是多锻炼促进骨骼重铸。";
                    break;
                    
                default:
                    break;
            }
            
            
            break;
        case 7:
            //    bmi  1低  2正常3高4高
            
            switch (item.bmiLevel) {
                case 1:
                    return @"您目前BMI值过低，属于偏瘦人群，建议您多补充营养并进行适当的锻炼，进行适当的力量训练可以使身体更加健康。";
                    break;
                case 2:
                    return @"您目前的BMI值处于正常状态，属于标准身材，建议您保持目前的饮食习惯与作息时间，可以根据自己的状况进行适当的微调，以便更好的保持状况。";
                    break;
                case 3:
                    return @"您目前的BMI值处于过高的状态，建议您控制饮食，少吃高脂肪食物与含糖量高的食物，少喝酒，多吃蔬菜水果类食物，建议您每天锻炼半小时，促进脂肪的燃烧。";
                    break;
                case 4:
                    return @"您目前的BMI值处于过高的状态，建议您控制饮食，少吃高脂肪食物与含糖量高的食物，少喝酒，多吃蔬菜水果类食物，建议您每天锻炼半小时，促进脂肪的燃烧。";
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 8:
            switch (item.boneMuscleLevel) {
                case 1:
                    return @"您目前的骨骼肌处于标准状态，这代表您的身体状况比较好，骨骼肌可以保护身体在剧烈运动时承受更大的压力，而且可以帮助人体树形，帮助您获得更好的身材"  ;
                    break;
                case 2:
                    return @"您目前身体内的骨骼肌偏低，会造成身体脆弱，经不起打击，容易骨折，细菌容易感染上身，会容易引发骨质疏松症等病状，建议您平时多加锻炼。";
                    break;
//                case 3:
//                    return @"您身体内的骨骼肌含量较高，这代表您的身体素质较好，比常人拥有更强的力量，更好的体型，而且骨骼肌比较高会给您带来更强的抵抗力，继续加油奥！";
//                    break;
                default:
                    break;
            }
            break;
            
            
        case 9:
            
            switch (item.waterLevel) {
                case 1:
                    return @"您身体的水分含量处于标准状态，请保持这种状态，这代表您的身体循环系统比较正常，身体比较健康。";
                    break;
                case 2:
                    return @"您身体内的水分含量较低，建议您多补充水分，一般而言，成年人每一千克体重需饮水40毫升，您可以根据自身的体重来补充自身每天所需要的水分。";
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return nil;
}


@end
