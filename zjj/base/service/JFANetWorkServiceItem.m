//
//  JFANetWorkServiceItem.m
//  Pods
//
//  Created by stefan on 15/8/27.
//
//

#import "JFANetWorkServiceItem.h"

@implementation JFANetWorkServiceItem

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.parameters=[[NSMutableDictionary alloc] initWithCapacity:0];
        self.method=@"POST";
    }
    return self;
}

@end
