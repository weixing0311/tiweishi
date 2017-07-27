//
//  UserModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserModel.h"
#import "ACSimpleKeychain.h"
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
-(void)setMainUserInfoWithDic:(NSDictionary *)dict
{
    self.headUrl     = [dict safeObjectForKey:@"headimgurl"];
    self.nickName    = [dict safeObjectForKey:@"nickName"];
    self.birthday    = [dict safeObjectForKey:@"birthday"];
    self.heigth      = [[dict safeObjectForKey:@"heigth"]floatValue];
    self.gender      = [[dict safeObjectForKey:@"sex"]intValue];
    self.healthId    = [dict safeObjectForKey:@"id"];
    self.subId       = [dict safeObjectForKey:@"id"];
    self.age         = [[TimeModel shareInstance] ageWithDateOfBirth:[dict safeObjectForKey:@"birthday"]];
    [self writeToDoc];
    [[SubUserItem shareInstance]setInfoWithMainUser];

}



-(void)setInfoWithDic:(NSDictionary *)dict
{
    self.userId      = [dict safeObjectForKey:@"userId"];
    self.username    = [dict safeObjectForKey:@"userName"];
    self.phoneNum    = [dict safeObjectForKey:@"phone"];
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
    self.subId   = [dict safeObjectForKey:@"id"];

    [_child removeAllObjects];
    _child=[NSMutableArray arrayWithArray:[dict safeObjectForKey:@"child"]];
    
    [[SubUserItem shareInstance]setInfoWithMainUser];
    self.age = [[TimeModel shareInstance] ageWithDateOfBirth:[dict safeObjectForKey:@"birthday"]];
    [self writeToDoc];

}

-(void)writeToDoc
{
    // NSDocumentDirectory 要查找的文件
    // NSUserDomainMask 代表从用户文件夹下找
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
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
    if (!self.subId) {
        self.subId   = [dict safeObjectForKey:@"id"];
    }else{
        self.subId   = [dict safeObjectForKey:@"subId"];
    }

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
    /*
     
     cardUrl = "http://image.fitgeneral.com/images/code/1500036814067886074.jpg";
     grade = 1;
     gradeName = "\U666e\U901a\U4f53\U8102\U5e08";
     headimgurl = "http://image.fitgeneral.com/images/head/1500084127193733096.png";
     inviteUrl = "http://test.fitgeneral.com/api/user/scanCode.do?recid=5256";
     isAttest = "\U5df2\U8ba4\U8bc1";
     nickName = "\U661f\U661f";
     phone = 15510106271;
     tradePassword = "";
     userBalance = 0;
     userName = "\U9b4f\U661f";
     userType = 2;
     */
    self.gradeName      = [dict safeObjectForKey:@"gradeName"];
    self.headUrl        = [dict safeObjectForKey:@"headimgurl"];
    self.isAttest       = [dict safeObjectForKey:@"isAttest"];
    self.nickName       = [dict safeObjectForKey:@"nickName"];
    self.phoneNum       = [dict safeObjectForKey:@"phone"];
    self.tradePassword  = [dict safeObjectForKey:@"tradePassword"];
    self.username       = [dict safeObjectForKey:@"userName"];
    self.userType       = [dict safeObjectForKey:@"userType"];
    self.balance        = [[dict safeObjectForKey:@"balance"]floatValue];
    self.qrcodeImageUrl = [dict safeObjectForKey:@"cardUrl"];
    self.linkerUrl      = [dict safeObjectForKey:@"inviteUrl"];
    self.age            =[[TimeModel shareInstance] ageWithDateOfBirth:[dict safeObjectForKey:@"birthday"]];
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

    }else
    {
        imageStr =@"jin";

    }
    return [UIImage imageNamed:imageStr];
}

-(void)setHeadImageUrl:(NSString *)imageUrl
{
    self.headUrl = imageUrl;
    
    [self writeToDoc];
}
-(void)setHealthidWithId:(NSString *)healthId
{
    self.subId = healthId;
    [self writeToDoc];
}

//未完成
-(void)childUserChange
{
//    self.child
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
    
    [[BaseSservice sharedManager]post1:@"app/isForce/judgeVersion.do" paramters:nil success:^(NSDictionary *dic) {
        
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


@end
