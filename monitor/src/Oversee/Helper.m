//
//  Helper.m
//  leyu
//
//  Created by zing1ng on 10/05/2017.
//  Copyright © 2017 zing1ng. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (void) createCacheFile: (NSString *)name withData: (id)data{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist" , name]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:filename]) {
            [fileManager removeItemAtPath:filename error:nil];
        }
        
        NSError *error;
        [[Helper DataTOjsonString:data] writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"导出失败:%@",error);
        }else{
            NSLog(@"导出成功");
        }
    });
}

+ (id)readCacheFile: (NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist" , name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filename];
    if (![fileManager fileExistsAtPath:filename]) {
        return nil;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSError *error;
    if (error != nil) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return json;
}

+ (void)removeCacheFile:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist" , name]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filename]) {
        [fileManager removeItemAtPath:filename error:nil];
    }
}

+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@ ",err);
        return nil;
    }
    return dic;
}

@end
