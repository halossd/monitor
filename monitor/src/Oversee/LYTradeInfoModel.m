//
//  LYTradeInfoModel.m
//  leyu
//
//  Created by zing1ng on 08/08/2017.
//  Copyright © 2017 zing1ng. All rights reserved.
//

#import "LYTradeInfoModel.h"

@implementation LYTradeInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tradeDatas = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
