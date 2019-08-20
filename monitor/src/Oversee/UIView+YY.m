//
//  UIView+YY.m
//  monitor
//
//  Created by cc on 2019/8/7.
//  Copyright © 2019 cc. All rights reserved.
//

#import "UIView+YY.h"

@implementation UIView (YY)

- (void)removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

@end
