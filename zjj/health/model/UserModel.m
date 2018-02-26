//
//  UserModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserModel.h"
#import "TimeModel.h"
#import "AppDelegate.h"
static UserModel *model;
@implementation UserModel

+(UserModel *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[UserModel alloc]init];
    });
    return model;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.child = [NSMutableArray array];
    }
    return self;
}
-(NSMutableArray *)child
{
    if (!_child) {
        self.child = [NSMutableArray array];
    }
    return _child;
}



-(void)setInfoWithDic:(NSDictionary *)dict
{
    self.userId      = [dict safeObjectForKey:@"userId"];
    self.username    = [dict safeObjectForKey:@"userName"];
    self.phoneNum    = [dict safeObjectForKey:@"phone"];
    self.mphoneNum   = [self changeTelephone:[dict safeObjectForKey:@"phone"]];
    self.headUrl     = [dict safeObjectForKey:@"headimgurl"];
    self.nickName    = [dict safeObjectForKey:@"nickName"];
    self.gender      = [[dict safeObjectForKey:@"sex"]intValue];
    self.heigth      = [[dict safeObjectForKey:@"heigth"]floatValue];
    self.birthday    = [dict safeObjectForKey:@"birthday"];
    self.token       = [dict safeObjectForKey:@"token"];
    self.age         = [[TimeModel shareInstance] ageWithDateOfBirth:[dict safeObjectForKey:@"birthday"]];
    self.userType    = [dict safeObjectForKey:@"userType"];
    self.grade       = [dict safeObjectForKey:@"grade"];
    self.gradeName   = [dict safeObjectForKey:@"gradeName"];
    self.isAttest    = [dict safeObjectForKey:@"isAttest"];
    self.healthId    = [dict safeObjectForKey:@"id"];
    self.subId       = [dict safeObjectForKey:@"id"];
    
    self.isPassword = [dict safeObjectForKey:@"isPassword"];
    self.isNeedParent = [dict safeObjectForKey:@"isNeedParent"];
    self.isTradePassword = [dict safeObjectForKey:@"isTradePassword"];

    
    
    [_child removeAllObjects];
    _child=[NSMutableArray arrayWithArray:[dict safeObjectForKey:@"child"]];
    
    self.age = [[TimeModel shareInstance] ageWithDateOfBirth:[dict safeObjectForKey:@"birthday"]];
    
    self.qrcodeImageUrl = [dict safeObjectForKey:@"cardUrl"];
    self.qrcodeImageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:self.qrcodeImageUrl]];

    [self writeToDoc];

}

-(void)writeToDoc
{
    // NSDocumentDirectory 要查找的文件
    // NSUserDomainMask 代表从用户文件夹下找
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    
    if ([self.isPassword isEqualToString:@"1"]||[self.isTradePassword isEqualToString:@"1"]||[self.isNeedParent isEqualToString:@"1"]||![self.isAttest isEqualToString:@"已认证"]) {
        return;
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict safeSetObject: self.mphoneNum  forKey:@"mphoneNum"];
    [dict safeSetObject: self.userId     forKey:@"userId"];
    [dict safeSetObject: self.username   forKey:@"userName"];
    [dict safeSetObject: self.phoneNum   forKey:@"phone"];
    [dict safeSetObject: self.headUrl    forKey:@"headimgurl"];
    [dict safeSetObject: self.nickName   forKey:@"nickName"];
    [dict safeSetObject: @(self.gender)  forKey:@"sex"];
    [dict safeSetObject: @(self.heigth)  forKey:@"heigth"];
    [dict safeSetObject: self.birthday   forKey:@"birthday"];
    [dict safeSetObject: self.token      forKey:@"token"];
    [dict safeSetObject: self.child      forKey:@"child"];
    [dict safeSetObject: self.userType   forKey:@"userType"];
    [dict safeSetObject: self.grade      forKey:@"grade"];
    [dict safeSetObject: self.gradeName  forKey:@"gradeName"];
    [dict safeSetObject: self.isAttest   forKey:@"isAttest"];
    [dict safeSetObject: self.healthId   forKey:@"id"];
    [dict safeSetObject: self.subId      forKey:@"subId"];
    [dict safeSetObject: @(self.age )        forKey:@"age"];
    [dict safeSetObject:self.qrcodeImageData forKey:@"qrcodeImageData"];
    [dict safeSetObject:self.qrcodeImageUrl forKey:@"qrcodeImageUrl"];
    [dict safeSetObject:self.isPassword forKey:@"isPassword"];
    [dict safeSetObject:self.isNeedParent forKey:@"isNeedParent"];
    [dict safeSetObject:self.isTradePassword forKey:@"isTradePassword"];


    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"UserInfo.plist"];
    [dict writeToFile:filePath atomically:YES];
    
}
-(void)readToDoc
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *filePath = [path stringByAppendingPathComponent:@"UserInfo.plist"];
    // 解档
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    self.userId      = [dict safeObjectForKey:@"userId"];
    self.username    = [dict safeObjectForKey:@"userName"];
    self.phoneNum    = [dict safeObjectForKey:@"phone"];
    self.mphoneNum   = [self changeTelephone:[dict safeObjectForKey:@"phone"]];
    self.headUrl     = [dict safeObjectForKey:@"headimgurl"];
    self.nickName    = [dict safeObjectForKey:@"nickName"];
    self.gender      = [[dict safeObjectForKey:@"sex"]intValue];
    self.heigth      = [[dict safeObjectForKey:@"heigth"]floatValue];
    self.birthday    = [dict safeObjectForKey:@"birthday"];
    self.token       = [dict safeObjectForKey:@"token"];
    self.child       = [dict safeObjectForKey:@"child"];
    self.userType    = [dict safeObjectForKey:@"userType"];
    self.grade       = [dict safeObjectForKey:@"grade"];
    self.gradeName   = [dict safeObjectForKey:@"gradeName"];
    self.isAttest    = [dict safeObjectForKey:@"isAttest"];
    self.healthId    = [dict safeObjectForKey:@"id"];
    self.age         = [[dict safeObjectForKey:@"age"]intValue];
    self.subId       = [dict safeObjectForKey:@"subId"];
    if (!self.subId) {
        self.subId   = [dict safeObjectForKey:@"id"];
    }
    self.qrcodeImageData = [dict safeObjectForKey:@"qrcodeImageData"];
    self.qrcodeImageUrl = [dict safeObjectForKey:@"qrcodeImageUrl"];
    self.isPassword = [dict safeObjectForKey:@"isPassword"];
    self.isNeedParent = [dict safeObjectForKey:@"isNeedParent"];
    self.isTradePassword = [dict safeObjectForKey:@"isTradePassword"];

    
}
-(BOOL)isHaveUserInfo
{
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [localPath  stringByAppendingPathComponent:@"UserInfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    else {
        return NO;
    }

}

-(void)removeAllObject
{
    self.userId = @"";
    self.username = @"";
    self.phoneNum = @"";
    self.headUrl = @"";
    self.nickName = @"";
    self.gender =YES;
    self.heigth = 0;
    self.birthday = @"";
    self.token = @"";
    self.mphoneNum =@"";
    self.isNeedParent = @"";
    self.isPassword = @"";
    self.isTradePassword = @"";
    [self.child removeAllObjects];
    self.userId = @"";
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [localPath  stringByAppendingPathComponent:@"UserInfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"文件abc.doc存在");
        NSError * error;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            DLog(@"删除本地文件error-%@",error);
        }
    }
    else {
        NSLog(@"文件abc.doc不存在");
    }}

-(void)setChildArrWithDict:(NSDictionary*)dict
{
    if (!self.child||self.child.count<1) {
        [self.child addObject:dict];
    }else{
        for (int i=0;i<self.child.count;i++) {
            NSDictionary * dic = [self.child objectAtIndex:i];
            if ([[dic objectForKey:@"id"]intValue]==[[dict objectForKey:@"id"]intValue]) {
                [self.child removeObject:dic];
            }
        }

        [self.child addObject:dict];
    }
    [self writeToDoc];
}
-(void)removeChildDict:(NSDictionary *)dict
{
    if (self.child.count<1||!self.child) {
        return;
    }
    
    [self.child removeObject:dict];
//    for (int i=0;i<self.child.count;i++) {
//        NSDictionary * dic = [self.child objectAtIndex:i];
//        if ([[dic objectForKey:@"id"]intValue]==[[dic objectForKey:@"id"]intValue]) {
//            DLog(@"dictId-%@  dicId%@",[dict objectForKey:@"id"],[dict objectForKey:@"id"]);
//            [self.child removeObject:dic];
//            [self writeToDoc];
//            return;
//        }
//    }
    [self writeToDoc];
}
-(NSMutableDictionary *)getChangeUserInfoDict
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:self.userId forKey:@"userId"];
    [param safeSetObject:self.nickName forKey:@"nickName"];
    [param safeSetObject:@(self.gender) forKey:@"sex"];
    [param safeSetObject:@(self.heigth) forKey:@"heigth"];
    [param safeSetObject:self.birthday forKey:@"birthday"];
    
    return param;
    
}

-(void)didAttestSuccessWithDict:(NSDictionary *)dict
{
    /*
     grade = 1;
     gradeName = "\U666e\U901a\U4f53\U8102\U5e08";
     isAttest = "\U5df2\U8ba4\U8bc1";
     userType = 2;
     */
    self.grade = [dict safeObjectForKey:@"grade"];
    self.gradeName = [dict safeObjectForKey:@"gradeName"];
    self.isAttest = [dict safeObjectForKey:@"isAttest"];
    self.userType = [NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"userType"]];
    [self writeToDoc];
}


-(void)setTzsInfoWithDict:(NSDictionary *)dict
{
    self.gradeName      = [dict safeObjectForKey:@"gradeName"];
    self.headUrl        = [dict safeObjectForKey:@"headimgurl"];
    self.isAttest       = [dict safeObjectForKey:@"isAttest"];
    self.nickName       = [dict safeObjectForKey:@"nickName"];
    self.phoneNum       = [dict safeObjectForKey:@"phone"];
    self.mphoneNum      = [self changeTelephone:[dict safeObjectForKey:@"phone"]];
    self.tradePassword  = [dict safeObjectForKey:@"tradePassword"];
    self.username       = [dict safeObjectForKey:@"userName"];
    self.userType       = [dict safeObjectForKey:@"userType"];
    self.balance        = [dict safeObjectForKey:@"userBalance"];
    self.linkerUrl      = [dict safeObjectForKey:@"inviteUrl"];
    self.qrcodeImageUrl = [dict safeObjectForKey:@"cardUrl"];
    self.parentId       = [dict safeObjectForKey:@"parentId"];
    self.partnerId      = [dict safeObjectForKey:@"partnerId"];
    self.grade          = [dict safeObjectForKey:@"grade"];
    self.gradeImg       = [dict safeObjectForKey:@"gradeImg"];
    self.isHaveCard     = [dict safeObjectForKey:@"isHaveCard"];
    self.tourismIntegral =[dict safeObjectForKey:@"tourismIntegral"];
    self.qrcodeImageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:self.qrcodeImageUrl]];
    self.superiorDict  = [dict safeObjectForKey:@"parent"];
    [self writeToDoc];
}




-(NSString*)attest
{
    NSString * title;
    if ([self.isAttest isEqualToString:@""]) {
        title = @"认证";
    }else{
        title = @"未认证";
    }
    return title;
}
-(NSString *)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
//    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return app_Version;
    
    //手机序列号
//    NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
//    NSLog(@"手机序列号: %@",identifierNumber);
//    //手机别名： 用户定义的名称
//    NSString* userPhoneName = [[UIDevice currentDevice] name];
//    NSLog(@"手机别名: %@", userPhoneName);
//    //设备名称
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    NSLog(@"设备名称: %@",deviceName );
//    //手机系统版本
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    NSLog(@"手机系统版本: %@", phoneVersion);
//    //手机型号
//    NSString* phoneModel = [[UIDevice currentDevice] model];
//    NSLog(@"手机型号: %@",phoneModel );
//    //地方型号  （国际化区域名称）
//    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
//    NSLog(@"国际化区域名称: %@",localPhoneModel );
//    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    // 当前应用名称
//    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSLog(@"当前应用名称：%@",appCurName);
//    // 当前应用软件版本  比如：1.0.1
//    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
//    // 当前应用版本号码   int类型
//    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
//    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
}

-(UIImage *)getLevelImage
{
    
    NSString * imageStr;
    if ([self.grade isEqualToString:@"1"]) {
        imageStr = @"putong";
    }else if ([self.grade isEqualToString:@"2"]){
        imageStr=@"tong";

    }else if ([self.grade isEqualToString:@"3"]){
        imageStr =@"yin";

    }else if ([self.grade isEqualToString:@"4"])
    {
        imageStr =@"jin";

    }else{
        imageStr =@"";
    }
    return [UIImage imageNamed:imageStr];
}

-(void)setHeadImageUrl:(NSString *)imageUrl
{
    self.headUrl = imageUrl;
    [self writeToDoc];
}

//未完成
-(void)childUserChange
{
//
    [self writeToDoc];
}


-(void)showSuccessWithStatus:(NSString *)status
{
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:status];
}
-(void)showErrorWithStatus:(NSString *)status
{
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:status];
}
-(void)showInfoWithStatus:(NSString *)status
{
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showInfoWithStatus:status];
}
-(void)dismiss
{
    [SVProgressHUD dismiss];
}



-(void)removeAllInfo
{
    
}

-(void)getUpdateInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int  bundleVersion =[[infoDictionary objectForKey:@"CFBundleVersion"]intValue];
    
    [[BaseSservice sharedManager]post1:@"app/isForce/judgeVersion.do" HiddenProgress:NO paramters:nil success:^(NSDictionary *dic) {
        
        DLog(@"dic --%@",dic);
        NSDictionary * dataDic = [dic safeObjectForKey:@"data"];
       self.updateMessage =[dataDic safeObjectForKey:@"message" ];
        self.upDataVersion = [[dataDic safeObjectForKey:@"version"]intValue];
        self.isForce = [[dataDic safeObjectForKey:@"isForce"]intValue];
        if (self.upDataVersion <= bundleVersion||self.upDataVersion ==self.ignoreVerSion) {
            self.isUpdate =NO;
        }else
        {
            self.isUpdate =YES;
        }
        
        [self showUpdataAlert];
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
}
-(void)showUpdataAlert
{
    [(AppDelegate*)[UIApplication sharedApplication].delegate showUpdateAlertViewWithMessage];
}


/**
 *手机号加密
 */
-(NSString*)changeTelephone:(NSString*)teleStr{
    if (!teleStr||teleStr.length<11) {
        return @"";
    }
    if (teleStr.length!=11) {
        return teleStr;
    }
//    NSString *string=[teleStr stringByReplacingOccurrencesOfString:[teleStr substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    NSString * string = [teleStr stringByReplacingCharactersInRange:NSMakeRange(3, 4)withString:@"****"];
    return string;
    
}
////获取个人信息
-(void)getbalance
{
    [[BaseSservice sharedManager]post1:@"app/user/getUserInfo.do" HiddenProgress:NO paramters:nil success:^(NSDictionary *dic) {
        DLog(@"dic--%@",dic);
        
        [[UserModel shareInstance]setTzsInfoWithDict:[dic safeObjectForKey:@"data"]];
        
    } failure:^(NSError *error) {
        DLog(@"error--%@",error);
    }];
}
///获取通知广告
-(void)getNotiadvertising
{
    
    [[BaseSservice sharedManager]post1:@"app/notify/queryNotifyInfo.do" HiddenProgress:NO paramters:nil success:^(NSDictionary *dic) {
        DLog(@"url--%@  dic--%@",@"app/notify/queryNotifyInfo.do",dic);
        
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        
        self.advertisingDict =[NSMutableDictionary dictionaryWithDictionary:dataDict];
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"error--%@",error);
    }];

}

-(BOOL)valiNickName:(NSString * )nickName
{
    nickName = [nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
//        $("#inputNum").val(val.replace(/[^\a-\z\A-\Z0-9\u4E00-\u9FA5]/g,''));
//    NSString * NICK_NUM = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5][0-9]+";
    NSString * NICK_NUM = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NICK_NUM];
    BOOL isMatch = [pred evaluateWithObject:nickName]; 
    return isMatch;
    
}

-(void)didCompleteTheTaskWithId:(NSString *)taskId
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"taskId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
    } failure:^(NSError *error) {
        
    }];
}

-(void)getIntegralInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryAll.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)changeUserDefaultWithSignInType:(int)type
{
    if (type==1) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:kShowSignAlert]) {
            NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kShowSignAlert];
            
        [dic safeSetObject:@"hidden" forKey:[NSString stringWithFormat:@"%@",[UserModel shareInstance].userId]];
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kShowSignAlert];
        }else{
            NSMutableDictionary * dic =[NSMutableDictionary dictionary];
            [dic safeSetObject:@"hidden" forKey:[NSString stringWithFormat:@"%@",[UserModel shareInstance].userId]];
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kShowSignAlert];
        }
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:kShowSignAlert]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:kShowSignAlert]];
            [dic removeObjectForKey:[NSString stringWithFormat:@"%@",[UserModel shareInstance].userId]];
        }else{
            return;
        }
    }
}
/**
 *获取url 中的参数 以字典方式返回
 */
- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    //    urlStr = @"http://test.fitgeneral.com/mall/notfy.jsp?orderType=3&total_amount=0.01&timestamp=2017-08-14+14:31:26&sign=PvPo75w/XeteSKJ1o+E1EqgPYPlDdUhCONCiARQR92FUJjT2i7gfsmCUCqcYMaeaZqZJQhEHEPm0nAGliUkULkYYKpRCN1A0oZFhzMuLaSXAjc6BcLH6Cy5JwIFVcOMjs2xVMZ5Pm+fVj+GlHqO7w8jrHTF/sxZu3vBB68zj9HbV0Om+t23k39tqK9t6JI7heLSObf1YQ/+MwtBnly+3hx90sKVLw2IaFpKAfEfvVxhvXACur3gF35MysByu8+mDQUdbPZTpH/mvmt2eMYeO1gARh/djxS2ZdJ0brl9HkNQkAsG1NT8e9rtTSklF3wYt9KY8TfLjQY6IadR8iWNolg==&trade_no=2017081421001004940270810861&sign_type=RSA2&auth_app_id=2017050307089464&charset=UTF-8&seller_id=2088621870283133&method=alipay.trade.wap.pay.return&app_id=2017050307089464&out_trade_no=131708141426510531472&version=1.0";
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

-(BOOL)getSignInNotifacationStatus
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kShowSignAlert]) {
//        if (![[[NSUserDefaults standardUserDefaults]objectForKey:kShowSignAlert]isKindOfClass:[NSDictionary class]]) {
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kShowSignAlert];
//            return YES;
//        }
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kShowSignAlert];
        if ([[dic allKeys]containsObject:[UserModel shareInstance].userId]) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}




@end
