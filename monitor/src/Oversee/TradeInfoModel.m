//
//  TradeInfoModel.m
//  monitor
//
//  Created by cc on 2019/8/7.
//  Copyright © 2019 cc. All rights reserved.
//

#import "TradeInfoModel.h"
#import <objc/runtime.h>

@implementation TradeInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _orders = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)convert:(NSDictionary *)dataSource
{
    for (NSString *key in [dataSource allKeys]) {
        if ([[self propertyKeys] containsObject:key]) {
            id propertyValue = [dataSource valueForKey:key];
            if (![propertyValue isKindOfClass:[NSNull class]]
                && propertyValue != nil) {
                [self setValue:propertyValue
                        forKey:key];
            }
        }
    }
}

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *propertys = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [propertys addObject:propertyName];
    }
    free(properties);
    return propertys;
}

@end
