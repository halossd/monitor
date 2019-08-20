//
//  LYTradeInfo.m
//  leyu
//
//  Created by zing1ng on 08/08/2017.
//  Copyright © 2017 zing1ng. All rights reserved.
//

#import "LYTradeInfo.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>

#define kBlue [UIColor colorWithRed:44/255.f green:118/255.f blue:244/255.f alpha:1]
#define kRed [UIColor colorWithRed:255/255.f green:55/255.f blue:55/255.f alpha:1]

@interface LYTradeInfo()

@property (nonatomic, strong) UILabel *tTrade;
@property (nonatomic, strong) UILabel *vTrade;

@end

@implementation LYTradeInfo

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data redColor:(BOOL)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _tTrade = [[UILabel alloc] init];
        _tTrade.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _tTrade.textColor = UIColor.whiteColor;
        [_tTrade setSingleLineAutoResizeWithMaxWidth:230];
        [self addSubview:_tTrade];
        
        _vTrade = [[UILabel alloc] init];
        _vTrade.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _vTrade.textAlignment = NSTextAlignmentRight;
        [_vTrade setSingleLineAutoResizeWithMaxWidth:200];
        [self addSubview:_vTrade];
        
        _tTrade.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(13);
        
        _vTrade.sd_layout
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(13);
        
        NSString *str1 = [NSString stringWithFormat:@"%@,",data[@"symbol"]];
        NSString *str2 = [NSString stringWithFormat:@" %@ %@", data[@"type"], data[@"lots"]];
        NSString *str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str3];
        NSRange range = [str3 rangeOfString:str2];
        UIColor *c = kRed;
        if ([data[@"type"] isEqualToString:@"BUY"]) {
            c = kBlue;
        }
        [attr addAttribute:NSForegroundColorAttributeName value:c range:range];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium] range:range];
        _tTrade.attributedText = attr;
        _vTrade.text = data[@"profit"];
     
        if ([data[@"profit"] compare:@"0" options:NSNumericSearch] == NSOrderedAscending) {
            _vTrade.textColor = kRed;
        } else {
            _vTrade.textColor = kBlue;
        }
    }
    
    return self;
}

@end
