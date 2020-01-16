//
//  MOCollectionViewLayout.h
//  monitor
//
//  Created by cc on 2019/9/9.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MOCollectionViewLayoutDelegate <NSObject>

@required
- (CGSize)itemSizeForIndexPath:(NSIndexPath* _Nonnull)indexPath;

@optional
- (NSUInteger)columnCountForLayout;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MOCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MOCollectionViewLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
