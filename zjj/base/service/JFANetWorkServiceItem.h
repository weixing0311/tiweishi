//
//  JFANetWorkServiceItem.h
//  Pods
//
//  Created by stefan on 15/8/27.
//
//

#import <Foundation/Foundation.h>

@interface JFANetWorkServiceItem : NSObject

@property(nonatomic,copy)NSString* url;

@property(nonatomic,copy)NSString* method;

@property(nonatomic,strong)NSMutableDictionary* parameters;

-(instancetype)init;

@end
