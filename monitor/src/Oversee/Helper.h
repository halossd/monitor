//
//  Helper.h
//  leyu
//
//  Created by zing1ng on 10/05/2017.
//  Copyright © 2017 zing1ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface Helper : NSObject

+ (void)createCacheFile: (NSString *)name withData: (id)data;
+ (id)readCacheFile: (NSString *)name;
+ (void)removeCacheFile:(NSString *)name;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
