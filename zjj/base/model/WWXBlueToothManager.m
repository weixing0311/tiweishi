//
//  WWXBlueToothManager.m
//  BlueToothTest
//
//  Created by iOSdeveloper on 2017/7/7.
//  Copyright © 2017年 -iOS. All rights reserved.
//

#import "WWXBlueToothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "TimeModel.h"
#import "HealthModel.h"
#import "YMSocketUtils.h"



#define VSVALEUUID          @"f433bd80-75b8-11e2-97d9-0002a5d5c51b"
#define BODYMINIUUID        @"0000bca0-0000-1000-8000-00805f9b34fb"
#define CHARACTERISTICSUUID @"1a2ea400-75b9-11e2-be05-0002a5d5c51b"
#define GETWRITHHEIGHTUUID  @"29f11080-75b9-11e2-8bf6-0002a5d5c51b"

@interface WWXBlueToothManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic ,strong) CBCentralManager   *   manager;
@property (nonatomic ,strong) NSMutableArray     *   peripherals;
@property (nonatomic ,strong) CBCharacteristic   *   mOldScaleConfigCharacteristic;
@property (nonatomic ,assign) int                    age;
@property (nonatomic ,assign) int                    height;
@property (nonatomic ,assign) int                    sex;


//typedef void (^BlueToothSuccessBlock)(NSDictionary * dic);
//typedef void (^BlueToothFailureBlock)(NSError      * error,NSString * errMsg);
//typedef void (^BlueToothStatusBlock )(NSString     * statusString);
////请求成功回调block
//@property (nonatomic ,copy) BlueToothSuccessBlock    successBlock;
//
////请求失败回调block
//@property (nonatomic ,copy) BlueToothFailureBlock    faileBlock;
//
//@property (nonatomic ,copy) BlueToothStatusBlock     statusBlock;


@end
static WWXBlueToothManager * manager;
@implementation WWXBlueToothManager
{
    NSTimer * _timer;
    int timerNumber;
}
+(WWXBlueToothManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WWXBlueToothManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.peripherals = [NSMutableArray array];

    }
    return self;
}

-(void)startScanWithStatus:(BlueToothStatusBlock)status
                   success:(BlueToothSuccessBlock)success
                     faile:(BlueToothFailureBlock)faile;
{
    [self stop];
    
    self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];

    [self setTimeOut];
    self.age = [SubUserItem shareInstance].age;
    self.height = [SubUserItem shareInstance].height;
    self.sex = [SubUserItem shareInstance].sex;
    
    self.statusBlock = status;
    self.successBlock  = success;
    self.faileBlock = faile;
    
    if (self.manager.state ==CBCentralManagerStatePoweredOn) {
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    }
    
}
-(void)setTimeOut
{
    timerNumber = 20;

    _timer = [NSTimer timerWithTimeInterval:timerNumber target:self selector:@selector(timerstop) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

}
-(void)timerstop
{
    self.faileBlock(nil, @"连接超时");
}
-(void)stop
{
    [self.manager stopScan];
    if (self.peripherals&& self.peripherals.count>0) {
        [self.manager cancelPeripheralConnection:self.peripherals[0]];
        self.manager.delegate = nil;
        self.manager =nil;

    }
    
    [self.peripherals removeAllObjects];
    self.mOldScaleConfigCharacteristic = nil;
}

-(NSData *)getWriteInfo

{
    self.sex =[SubUserItem shareInstance].sex;
    
    self.age =[[TimeModel shareInstance] ageWithDateOfBirth:[SubUserItem shareInstance].birthday];
    self.height =[SubUserItem shareInstance].height;
    
    [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"写入数据id:%@;sex:%d;age:%d;height:%d",[UserModel shareInstance].userId,self.sex,self.age,self.height]];

    DLog(@"写入数据id:%@;sex:%d;age:%d;height:%d",[UserModel shareInstance].userId,self.sex-1,self.age,self.height);
    

    
//    Byte byte1[1];
//    byte1[0] = 0x10;
//    
//    Byte byte2[1];
//    byte2[0] =(Byte)0xff & [[UserModel shareInstance].userId intValue];
//    
//    Byte byte3[1];
//    byte3[0] =(Byte)0xff & [[UserModel shareInstance].userId intValue];
//
//    Byte byte4[1];
//    byte4[0] =(Byte)0xff & [[UserModel shareInstance].userId intValue];
//
//    Byte byte5[1];
//    byte5[0] =(Byte)0xff & [[UserModel shareInstance].userId intValue];
//
//    NSData * data1 = [NSData dataWithBytes:byte1 length:1];
//    NSData * data2 = [NSData dataWithBytes:byte2 length:1];
//    NSData * data3 = [NSData dataWithBytes:byte3 length:1];
//    NSData * data4 = [NSData dataWithBytes:byte4 length:1];
//    NSData * data5 = [NSData dataWithBytes:byte5 length:1];
//
//    NSMutableData * upData = [NSMutableData new];
//    [upData appendData:data1];
//    [upData appendData:data2];
//    [upData appendData:data3];
//    [upData appendData:data4];
//    [upData appendData:data5];
//    return upData;
    
    Byte bytes[5];
    bytes[0] =(Byte)0xff & 16;
    bytes[1] =(Byte)0xff & [[UserModel shareInstance].userId intValue]>>8;
    if (self.sex ==1) {
        bytes[2] =0x00;
  
    }else{
        bytes[2] =(Byte)0xff & 1;

    }
    bytes[3] =(Byte)0xff & self.age;
    bytes[4] =(Byte)0xff & self.height;
//    bytes[0] = 0x10;
//    bytes[1] = (0xff00 & [[UserModel shareInstance].userId intValue]) >> 8;
//    bytes[2] = (0xff0000 & self.sex) >> 16;
//    bytes[3] = (0xff000000 & self.age) >> 24;
//    bytes[4] = (0xff00000000 & self.height) >> 32;

    
    NSData * data = [[NSData alloc]initWithBytes:bytes length:5];
    return data;
}
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            DLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            DLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            self.faileBlock(nil,@"此设备不支持蓝牙");

            DLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            self.faileBlock(nil,@"未授权");

            DLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            self.faileBlock(nil,@"蓝牙已关闭，请打开后重新请求");

            DLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            DLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            
            
            
            
            [self.manager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
    //    这个方法得在这里面调用 要不然不起作用
    
}

//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    DLog(@"当扫描到设备:%@",peripheral.name);
    if ([peripheral.name hasPrefix:@"VScale"]||[peripheral.name hasPrefix:@"BodyMini"]){
        self.statusBlock(@"设备连接中。。。");

        [self.peripherals addObject:peripheral];
        //连接设备
        [self.manager connectPeripheral:peripheral options:nil];
    }
    
}


//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [_timer invalidate];
    DLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    self.statusBlock(@"设备已连接。。。");
    [self setTimeOut];
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
}
//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
    [_timer invalidate];
    self.faileBlock(error, @"体脂称连接失败");
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [_timer invalidate];
    self.faileBlock(error,@"体脂称断开了连接");
    DLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    
    
}

//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    //  DLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {self.faileBlock(error, @"扫描Services失败");
        DLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        [_timer invalidate];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        //        DLog(@"%@",service.UUID);
        
        if ([peripheral.name hasPrefix:@"VScale"] ) {
            DLog(@"扫描到servces %@",service.UUID.UUIDString);

            if ([self isEqualWithString:service.UUID.UUIDString string:VSVALEUUID]==YES) {
                [_timer invalidate];
                [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"扫描到servces %@",service.UUID.UUIDString]];

                [peripheral discoverCharacteristics:nil forService:service];
                
            }
        }else if([peripheral.name hasPrefix:@"bodymini"]){
            DLog(@"%@",service.UUID);
            DLog(@"扫描到servces %@",service.UUID.UUIDString);
            
            if ([self isEqualWithString:service.UUID.UUIDString string:BODYMINIUUID]==YES) {
                [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"扫描到servces %@",service.UUID.UUIDString]];


                [_timer invalidate];
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
        
        //扫描每个service的Characteristics，扫描到后会进入方法： -(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
    }
    
}
//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    DLog(@"扫描到Characteristics");
    if (error)
    {
        self.faileBlock(error, @"扫描characteristics-error ");
        DLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
//    for (CBCharacteristic *characteristic in service.characteristics)
//    {
//        DLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
//    }
//    
    
    
    
    //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        {
            if ([self isEqualWithString:characteristic.UUID.UUIDString string:CHARACTERISTICSUUID]==YES) {
                DLog(@"匹配成功service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
                [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"匹配成功service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID]];


                //添加通知
                [self notifyCharacteristic:peripheral characteristic:characteristic];
                //读取信息
                
                [peripheral readValueForCharacteristic:characteristic];
                
            }else if ([self isEqualWithString:characteristic.UUID.UUIDString string:@"29f11080-75b9-11e2-8bf6-0002a5d5c51b"])
            {
                [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"存储mOldScaleConfigCharacteristic"]];

                self.mOldScaleConfigCharacteristic = characteristic;
            }
        }
    }
    
    //搜索Characteristic的Descriptors，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
    
}

//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
//        self.faileBlock(error, @"读取失败");
    }
    
    NSData * data = characteristic.value;
    
    //将接收到的十六进制数据 转成 十六进制字符串
    Byte *byte    = (Byte *)[data bytes];
    
    // 取出其中用用的两位
    //    for(int i=0;i<[data length];i++)
    
    if (data.length > 4 && byte[2] == 0 && byte[3] == 0)// 测脂肪
    {
        DLog(@"测体重");
        if (data.length > 5)
        {
            int h = byte[4] & 0xff;
            int l = byte[5] & 0xff;
            float  weight = (float) ((h * 256 + l) / 10.0);
            
            [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"获得体重"]];


            //这个体重第一次返回数据的时候weight == 0，而后面的几次反馈就会有数据
            if (weight == 0)
            {
                return;
            }
            
            
            DLog(@"%@",[NSString  stringWithFormat:@"获取到体重%f",weight]);
            
            self.statusBlock(@"开始云计算，请勿下秤。。");
            [[HealthModel shareInstance]setLogInUpLoadString:[NSString stringWithFormat:@"开始写入数据"]];
            NSData * data = [self getWriteInfo];
            
            [self writeCharacteristic:peripheral characteristic:self.mOldScaleConfigCharacteristic value:data];
        }
        else
        {
            self.faileBlock(nil, @"测量出现异常，请下秤重测");
            DLog(@"测量出现异常，请下秤重测");
        }
    } else
    {
        NSData * data = characteristic.value;
        
        //    //将接收到的十六进制数据 转成 十六进制字符串
        if (data.length<1 ) {
            DLog(@"失败");
//            self.faileBlock(nil, @"测量出现异常，请下秤重测");
            
            return;
        }
        
        Byte *byte    = (Byte *)[data bytes];
        
        //        for (int i = 0; i < data.length; i++) {
        
        
        float weight = (float) ((byte[4] * 256 + byte[5]) / 10.0);
        
        if (byte[6] == 255 || byte[7] == 255) {
//            self.faileBlock(nil, @"数据出错");
            self.faileBlock(nil, @"测量出现异常，请下秤重测");

            return;
        }
        
        NSString * mFat = [NSString stringWithFormat:@"%.2f",(byte[6] * 256 + byte[7]) / 10.0];
        NSString * setmWater = [NSString stringWithFormat:@"%.2f",(byte[8] * 256 + byte[9]) / 10.0];
        NSString * mBone = [NSString stringWithFormat:@"%.2f",(byte[10] * 256 + byte[11]) / 10.0];
        NSString * mMuscle = [NSString stringWithFormat:@"%.2f",(byte[12] * 256 + byte[13]) / 10.0];
        NSString * mVisceralFat = [NSString stringWithFormat:@"%hhu",byte[14]];
        NSString * mCalorie = [NSString stringWithFormat:@"%d",byte[15] * 256 + byte[16]];
        NSString * mBmi = [NSString stringWithFormat:@"%.1f",weight * 10000 /self.height/self.height];
        NSString * weightStr = [NSString stringWithFormat:@"%.1f",weight];
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:mFat         forKey:@"mFat"];
        [param setObject:setmWater    forKey:@"mWater"];
        [param setObject:mBone        forKey:@"mBone"];
        [param setObject:mMuscle      forKey:@"mMuscle"];
        [param setObject:mVisceralFat forKey:@"mVisceralFat"];
        [param setObject:mCalorie     forKey:@"mCalorie"];
        [param setObject:mBmi         forKey:@"mBmi"];
        [param setObject:weightStr    forKey:@"mWeight"];

        self.successBlock(param);
        DLog(@"%@-%@-%@-%@-%@-%@",mFat,setmWater,mBone,mMuscle,mVisceralFat,mCalorie);
        [self stop];
        
    }
    DLog(@"读取------  characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    
}

//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //打印出Characteristic和他的Descriptors
    DLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        DLog(@"Descriptor uuid:%@",d.UUID);
    }
    
}
//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    DLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
}

//写数据
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    
    //打印出 characteristic 的权限，可以看到有很多种，这是一个NS_OPTIONS，就是可以同时用于好几个值，常见的有read，write，notify，indicate，知知道这几个基本就够用了，前连个是读写权限，后两个都是通知，两种不同的通知方式。
    /*
     typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
     CBCharacteristicPropertyBroadcast												= 0x01,
     CBCharacteristicPropertyRead													= 0x02,
     CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
     CBCharacteristicPropertyWrite													= 0x08,
     CBCharacteristicPropertyNotify													= 0x10,
     CBCharacteristicPropertyIndicate												= 0x20,
     CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
     CBCharacteristicPropertyExtendedProperties										= 0x80,
     CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
     CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
     };
     
     */
    DLog(@"%lu", (unsigned long)characteristic.properties);
    
    
    //只有 characteristic.properties 有write的权限才可以写
        if(characteristic.properties & CBCharacteristicPropertyWrite){
    /*
     最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
     */
    [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }else{
            DLog(@"该字段不可写！");
            self.faileBlock(nil, @"写入失败，写入信息有误");
        }
    
    
}
//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}



-(BOOL)isEqualWithString:(NSString*)str1 string:(NSString *)str2
{
    
    NSComparisonResult  result = [str1 compare:str2 options:NSCaseInsensitiveSearch|NSNumericSearch];
    if (result ==NSOrderedSame) {
        return YES;
    }else{
        return NO;
    }
    
}
//写入数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        self.faileBlock(error, @"写入失败");
        DLog(@"=======%@",error.userInfo);
    }else{
        DLog(@"发送数据成功");
    }
    
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    [peripheral readValueForCharacteristic:characteristic];
}



@end
