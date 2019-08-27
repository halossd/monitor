//
//  OverseeCell.m
//  monitor
//
//  Created by cc on 2019/8/8.
//  Copyright © 2019 cc. All rights reserved.
//

#import "OverseeCell.h"
#import "Helper.h"
#import "UIView+YY.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "LYTradeInfo.h"

#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define C7 [UIColor colorWithRed:110/255.f green:110/255.f blue:110/255.f alpha:1]
#define C2 UIColor.whiteColor
#define kBlue [UIColor colorWithRed:44/255.f green:118/255.f blue:244/255.f alpha:1]
#define kRed [UIColor colorWithRed:255/255.f green:55/255.f blue:55/255.f alpha:1]

@interface OverseeCell ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *tPlatformLabel;
@property (nonatomic, strong) UILabel *vPlatformLabel;
@property (nonatomic, strong) UILabel *tIpLabel;
@property (nonatomic, strong) UILabel *vIpLabel;
@property (nonatomic, strong) UILabel *tBalanceLabel;
@property (nonatomic, strong) UILabel *vBalanceLabel;
@property (nonatomic, strong) UILabel *tNetWorthLabel;
@property (nonatomic, strong) UILabel *vNetWorthLabel;
@property (nonatomic, strong) UILabel *tPrepaymentsLabel;
@property (nonatomic, strong) UILabel *vPrepaymentsLabel;
@property (nonatomic, strong) UILabel *tAvailablePrepaidLabel;
@property (nonatomic, strong) UILabel *vAvailablePrepaidLabel;
@property (nonatomic, strong) UILabel *tMarginRateLabel;
@property (nonatomic, strong) UILabel *vMarginRateLabel;
@property (nonatomic, strong) UILabel *tFloatProfitRateLabel;
@property (nonatomic, strong) UILabel *vFloatProfitRateLabel;
@property (nonatomic, strong) UIView  *tradeInfoWrap;
@property (nonatomic, strong) UIView  *bottomLine;
@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat bodyHeight;

@end

@implementation OverseeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIFont *hederFont;
        UIFont *bodyFont;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _w = WIN_WIDTH - 30;
            _bodyHeight = 15;
            bodyFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            hederFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        }else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            _w = 375 - 30;
            _bodyHeight = 20;
            bodyFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
            hederFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        }
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 10;
        
        self.backgroundColor = [UIColor colorWithRed:22/255.f green:22/255.f blue:22/255.f alpha:1];
        
        _topLabel = [[UILabel alloc] init];
        _topLabel.textColor = UIColor.whiteColor;
        _topLabel.font = hederFont;
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_topLabel];
        
        _tPlatformLabel = [[UILabel alloc] init];
        _tPlatformLabel.textColor = C2;
        _tPlatformLabel.font = bodyFont;
        _tPlatformLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_tPlatformLabel];
        
        _vPlatformLabel = [[UILabel alloc] init];
        _vPlatformLabel.textColor = C2;
        _vPlatformLabel.textAlignment = NSTextAlignmentRight;
        _vPlatformLabel.font = bodyFont;
        [_vPlatformLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vPlatformLabel];
        
        _tIpLabel = [[UILabel alloc] init];
        _tIpLabel.textColor = C2;
        _tIpLabel.text = @"地址:";
        _tIpLabel.font = bodyFont;
        [_tIpLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tIpLabel];
        
        _vIpLabel = [[UILabel alloc] init];
        _vIpLabel.textColor = C2;
        _vIpLabel.textAlignment = NSTextAlignmentRight;
        _vIpLabel.font = bodyFont;
        [_vIpLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vIpLabel];
        
        _tBalanceLabel = [[UILabel alloc] init];
        _tBalanceLabel.textColor = C2;
        _tBalanceLabel.text = @"余额:";
        _tBalanceLabel.font = bodyFont;
        [_tBalanceLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tBalanceLabel];
        
        _vBalanceLabel = [[UILabel alloc] init];
        _vBalanceLabel.textColor = C2;
        _vBalanceLabel.textAlignment = NSTextAlignmentRight;
        _vBalanceLabel.font = bodyFont;
        [_vBalanceLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vBalanceLabel];
        
        _tNetWorthLabel = [[UILabel alloc] init];
        _tNetWorthLabel.textColor = C2;
        _tNetWorthLabel.text = @"净值:";
        _tNetWorthLabel.font = bodyFont;
        [_tNetWorthLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tNetWorthLabel];
        
        _vNetWorthLabel = [[UILabel alloc] init];
        _vNetWorthLabel.textColor = C2;
        _vNetWorthLabel.textAlignment = NSTextAlignmentRight;
        _vNetWorthLabel.font = bodyFont;
        [_vNetWorthLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vNetWorthLabel];
        
        _tPrepaymentsLabel = [[UILabel alloc] init];
        _tPrepaymentsLabel.textColor = C2;
        _tPrepaymentsLabel.text = @"预付款:";
        _tPrepaymentsLabel.font = bodyFont;
        [_tPrepaymentsLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tPrepaymentsLabel];
        
        _vPrepaymentsLabel = [[UILabel alloc] init];
        _vPrepaymentsLabel.textColor = C2;
        _vPrepaymentsLabel.textAlignment = NSTextAlignmentRight;
        _vPrepaymentsLabel.font = bodyFont;
        [_vPrepaymentsLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vPrepaymentsLabel];
        
        _tAvailablePrepaidLabel = [[UILabel alloc] init];
        _tAvailablePrepaidLabel.textColor = C2;
        _tAvailablePrepaidLabel.text = @"可用预付款:";
        _tAvailablePrepaidLabel.font = bodyFont;
        [_tAvailablePrepaidLabel setSingleLineAutoResizeWithMaxWidth:150.f];
        [self.contentView addSubview:_tAvailablePrepaidLabel];
        
        _vAvailablePrepaidLabel = [[UILabel alloc] init];
        _vAvailablePrepaidLabel.textColor = C2;
        _vAvailablePrepaidLabel.textAlignment = NSTextAlignmentRight;
        _vAvailablePrepaidLabel.font = bodyFont;
        [_vAvailablePrepaidLabel setSingleLineAutoResizeWithMaxWidth:150];
        [self.contentView addSubview:_vAvailablePrepaidLabel];
        
        _tMarginRateLabel = [[UILabel alloc] init];
        _tMarginRateLabel.textColor = C2;
        _tMarginRateLabel.text = @"预付款比例:";
        _tMarginRateLabel.font = bodyFont;
        [_tMarginRateLabel setSingleLineAutoResizeWithMaxWidth:100.f];
        [self.contentView addSubview:_tMarginRateLabel];
        
        _vMarginRateLabel = [[UILabel alloc] init];
        _vMarginRateLabel.textColor = C2;
        _vMarginRateLabel.textAlignment = NSTextAlignmentRight;
        _vMarginRateLabel.font = bodyFont;
        [_vMarginRateLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vMarginRateLabel];
        
        _tFloatProfitRateLabel = [[UILabel alloc] init];
        _tFloatProfitRateLabel.textColor = C2;
        _tFloatProfitRateLabel.text = @"浮动盈亏比:";
        _tFloatProfitRateLabel.font = bodyFont;
        [_tFloatProfitRateLabel setSingleLineAutoResizeWithMaxWidth:150.f];
        [self.contentView addSubview:_tFloatProfitRateLabel];
        
        _vFloatProfitRateLabel = [[UILabel alloc] init];
        _vFloatProfitRateLabel.textColor = C2;
        _vFloatProfitRateLabel.textAlignment = NSTextAlignmentRight;
        _vFloatProfitRateLabel.font = bodyFont;
        [_vFloatProfitRateLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vFloatProfitRateLabel];
        
        _tradeInfoWrap = [[UIView alloc] init];
        [self.contentView addSubview:_tradeInfoWrap];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = C7;
        [self.contentView addSubview:_bottomLine];
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    CGFloat left = 15;
    CGFloat top = 8;
    
    self.topLabel.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .heightIs(40);
    
    self.vPlatformLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topSpaceToView(self.topLabel, top)
    .heightIs(_bodyHeight);
    
    self.tPlatformLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topEqualToView(self.vPlatformLabel)
    .rightSpaceToView(self.vPlatformLabel, top)
    .heightIs(_bodyHeight);
    
    self.tIpLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.tPlatformLabel, top)
    .heightIs(_bodyHeight);
    
    self.vIpLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topEqualToView(self.tIpLabel)
    .heightIs(_bodyHeight);
    
    self.tBalanceLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.tIpLabel, top)
    .heightIs(_bodyHeight);
    
    self.vBalanceLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topEqualToView(self.tBalanceLabel)
    .heightIs(_bodyHeight);
    
    self.tNetWorthLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.tBalanceLabel, top)
    .heightIs(_bodyHeight);
    
    self.vNetWorthLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topEqualToView(self.tNetWorthLabel)
    .heightIs(_bodyHeight);
    
    self.tPrepaymentsLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.tNetWorthLabel, top)
    .heightIs(_bodyHeight);
    
    self.vPrepaymentsLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topEqualToView(self.tPrepaymentsLabel)
    .heightIs(_bodyHeight);
    
    self.tAvailablePrepaidLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.tPrepaymentsLabel, top)
    .heightIs(_bodyHeight);
    
    self.vAvailablePrepaidLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topEqualToView(self.tAvailablePrepaidLabel)
    .heightIs(_bodyHeight);
    
    self.tMarginRateLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.tAvailablePrepaidLabel, top)
    .heightIs(_bodyHeight);
    
    self.vMarginRateLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topEqualToView(self.tMarginRateLabel)
    .heightIs(_bodyHeight);
    
    self.tFloatProfitRateLabel.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.tMarginRateLabel, top)
    .heightIs(_bodyHeight);
    
    self.vFloatProfitRateLabel.sd_layout
    .rightSpaceToView(self.contentView, left)
    .topEqualToView(self.tFloatProfitRateLabel)
    .heightIs(_bodyHeight);
    
    self.bottomLine.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.tFloatProfitRateLabel, 8)
    .heightIs(0.5);
    
    self.tradeInfoWrap.sd_layout
    .leftSpaceToView(self.contentView, left)
    .topSpaceToView(self.bottomLine, 12)
    .widthIs(_w);
    
}

- (void)setData:(TradeInfoModel *)data
{
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_topLabel.bounds
//                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _topLabel.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _topLabel.layer.mask = maskLayer;
    
    [_tradeInfoWrap removeAllSubviews];
    double profit = data.equity.doubleValue - data.balance.doubleValue;
    _topLabel.text = [NSString stringWithFormat:@"%.2f", profit];
    _topLabel.backgroundColor = profit >= 0 ? kBlue : kRed;
    _tPlatformLabel.text = data.company;
    _vPlatformLabel.text = data.account;
    _vIpLabel.text = data.host;
    _vBalanceLabel.text = data.balance;
    _vNetWorthLabel.text = data.equity;
    _vPrepaymentsLabel.text = data.margin;
    _vAvailablePrepaidLabel.text = data.freeMargin;
    _vMarginRateLabel.text = data.marginLevel;
    _vFloatProfitRateLabel.text = data.profitRatio;
    NSArray *infos = data.orders;
    if (infos.count == 0) {
        _tradeInfoWrap.sd_layout
        .heightIs(1);
    }else{
        _tradeInfoWrap.sd_layout
        .heightIs(infos.count * 21);
    }
    
    [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LYTradeInfo *view = [[LYTradeInfo alloc] initWithFrame:CGRectMake(0, 21 * idx, self.w, 13) data:obj redColor:NO];
        [self.tradeInfoWrap addSubview:view];
    }];
}

@end
