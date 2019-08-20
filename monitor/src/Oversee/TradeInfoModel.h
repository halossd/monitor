//
//  TradeInfoModel.h
//  monitor
//
//  Created by cc on 2019/8/7.
//  Copyright © 2019 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradeInfoModel : NSObject

@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *equity;
@property (nonatomic, copy) NSString *freeMargin;
@property (nonatomic, copy) NSString *marginLevel;
@property (nonatomic, copy) NSString *margin;
@property (nonatomic, copy) NSString *profitRatio;
@property (nonatomic) NSMutableArray *orders;

- (void)convert:(NSDictionary*)dataSource;

@end

NS_ASSUME_NONNULL_END
