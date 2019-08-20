//
//  LYTradeInfoModel.h
//  leyu
//
//  Created by zing1ng on 08/08/2017.
//  Copyright © 2017 zing1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTradeInfoModel : NSObject

@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *vPlatform;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *netWorth;
@property (nonatomic, copy) NSString *prePayments;
@property (nonatomic, copy) NSString *avilablePrepaid;
@property (nonatomic, copy) NSString *tFloatProfit;
@property (nonatomic, copy) NSString *vFloatProfit;
@property (nonatomic, copy) NSMutableArray  *tradeDatas;

@end
