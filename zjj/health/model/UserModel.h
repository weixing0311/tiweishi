//
//  UserModel.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/15.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
+(UserModel *)shareInstance;
/**
 * 标识用户唯一属性
 */
@property (nonatomic,copy  ) NSString * userId;
/**
 * 判断用户性质 //1消费者 2体脂师
 */
@property (nonatomic,copy  ) NSString * userType;

/**
 *年龄
 */
@property (nonatomic,assign) int        age;

/**
 *生日
 */
@property (nonatomic,copy  ) NSString * birthday;
/**
 * 认证后的真实姓名
 */
@property (nonatomic,copy  ) NSString * username;

/**
 *头像url
 */
@property (nonatomic,copy  ) NSString * headUrl;//头像url

/**
 *  性别
 */
@property (nonatomic,assign) int        gender;// 性别

/**
 *手机号
 */
@property (nonatomic,copy  ) NSString * phoneNum;//手机号
/**
 *手机号
 */
@property (nonatomic,copy  ) NSString * mphoneNum;//加密手机号
/**
 * 昵称
 */
@property (nonatomic,copy  ) NSString * nickName;//昵称

/**
 * 业务积分
 */
@property (nonatomic,copy  ) NSString * tourismIntegral;
/**
 *    需要显示用户的ID
 */
@property (nonatomic,assign)int showId;


@property (nonatomic,assign) int   userDays;

/**
 *  子用户id
 */
@property (nonatomic,copy) NSString * subId;

/**
 * 验证接口唯一属性
 */
@property (nonatomic,copy  ) NSString * token;


/**
 *  子用户数组
 */
@property (nonatomic,strong) NSMutableArray  * child;//子用户
/**
 * 身高
 */
@property (nonatomic,assign) float   heigth;//身高

/**
 *  体脂师等级名称
 */
@property (nonatomic,copy  ) NSString * gradeName;//体脂师名称

/**
 *   体脂师等级 1 铜牌体脂师 2银牌。。 3 金牌。
 */
@property (nonatomic,copy  ) NSString * grade;//体脂师等级

/**
 *   体脂师等级 图片
 */
@property (nonatomic,copy  ) NSString * gradeImg;//

/**
 *  是否实名认证
 */
@property (nonatomic,copy  ) NSString * isAttest;//是否认证


/**
 *   获取健康数据唯一id
 */
@property (nonatomic,copy  ) NSString * healthId;


/**
 * 判断是否设置了交易密码
 */
@property (nonatomic,copy)NSString * tradePassword;

/**
 *   个人资产
 */
@property (nonatomic,assign)NSString * balance;


/**
 * 二维码
 */
@property (nonatomic,copy  )NSString * qrcodeImageUrl;

/**
 * 二维码
 */
@property (nonatomic,copy  )NSData * qrcodeImageData;


/**
 * 分享链接
 */
@property (nonatomic,copy  )NSString * linkerUrl;

/**
 *上级人员信息
 */
@property (nonatomic,strong)NSDictionary * superiorDict;

@property (nonatomic,copy  )NSString * isHaveCard;

/**
 *减肥前图片
 */
@property (nonatomic,copy)NSString * fatBeforeImageUrl;
/**
 *减肥后图片
 */
@property (nonatomic,copy)NSString * fatAfterImageUrl;
/**
 *简介
 */
@property (nonatomic,copy)NSString * jjStr;

/**
 *是否有交易密码
 */
@property (nonatomic,copy)NSString * isTradePassword;
/**
 *是否有上级
 */
@property (nonatomic,copy)NSString * isNeedParent;
/**
 *是否有登录密码
 */
@property (nonatomic,copy)NSString * isPassword;
/**
 *   获取修改个人信息Dict
 */
-(NSMutableDictionary *)getChangeUserInfoDict;


/**
 *  从本地获取个人信息
 */
-(void)readToDoc;

/**
 *  保存个人信息
 */
-(void)setInfoWithDic:(NSDictionary *)dict;//放置信息

/**
 *  获取版本号
 */
-(NSString *)getVersion;//获取版本号

/**
 *  删除所有个人信息
 */
-(void)removeAllObject;

/**
 * 获取体脂师等级image
 */
-(UIImage *)getLevelImage;

/**
 *  重置头像
 *  更新本地个人信息
 */
-(void)setHeadImageUrl:(NSString *)imageUrl;

///判断tabbar
@property (nonatomic,copy)NSString * tabbarStyle;


/**
 * 判断个人信息是否为空
 */
-(BOOL)isHaveUserInfo;//是否有个人信息

/**
 * 是否实名认证
 */
-(NSString*)attest;//是否认证


/**
 *  修改个人信息调用
 *  更新本地个人信息
 */
-(void)setMainUserInfoWithDic:(NSDictionary *)dict;


/**
 *  切换子账号时调用
 *  更新本地个人信息
 */
-(void)setHealthidWithId:(NSString *)healthId;

/**
 *  修改 添加子用户调用
 *  更新本地个人信息
 */
-(void)setChildArrWithDict:(NSDictionary*)dict;

/**
 *  删除子用户调用
 *  更新本地个人信息
 */
-(void)removeChildDict:(NSDictionary *)dict;

/**
 * 认证成功后调用
 */
-(void)didAttestSuccessWithDict:(NSDictionary *)dict;

/**
 *  体脂师 settingViewController
 *  app/user/getUserInfo.do
 *  更新本地个人信息
 */
-(void)setTzsInfoWithDict:(NSDictionary *)dict;

/**
 * 切换用户保存subid
 */
-(void)childUserChange;

#define mark ----广告
/**
 *广告
 */
@property (nonatomic,strong)NSMutableDictionary * advertisingDict;


#pragma mark --是否有推荐人 是否可以认证成为体脂师

@property (nonatomic,copy  )NSString * parentId;//
@property (nonatomic,copy  )NSString * partnerId;//

#define mark  ---版本更新
/**
 *是否需要更新
 */
@property (nonatomic,assign)BOOL isUpdate;//
/**
 * 更新alert的Message
 */
@property (nonatomic,copy  )NSString * updateMessage;//
/**
 * 忽略更新版本号
 */
@property (nonatomic,assign)int   ignoreVerSion;//

/**
 * 更新版本号
 */
@property (nonatomic,assign)int   upDataVersion;//

/**
 *  是否需要强更  1否2是
 */
@property (nonatomic,assign)int isForce;//

/**
 *  查看更新
 */
-(void)getUpdateInfo;

-(void)showSuccessWithStatus:(NSString *)status;
-(void)showErrorWithStatus:(NSString *)status;
-(void)showInfoWithStatus:(NSString *)status;
-(void)dismiss;

/**
 *获取个人信息
 */
-(void)getbalance;



/**
 *手机号加密
 */
-(NSString*)changeTelephone:(NSString*)teleStr;

///获取通知广告
-(void)getNotiadvertising;
/**
 *验证昵称的可行性
 */

-(BOOL)valiNickName:(NSString * )nickName;

///上传完成任务接口
-(void)didCompleteTheTaskWithId:(NSString *)taskId;



///判断是否显示签到弹窗----YES--显示 --NO 不显示
-(BOOL)getSignInNotifacationStatus;

///修改签到弹窗状态
-(void)changeUserDefaultWithSignInType:(int)type;
/**
 *获取url 中的参数 以字典方式返回
 */
- (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;
@end
