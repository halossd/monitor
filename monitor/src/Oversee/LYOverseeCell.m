//
//  LYOverseeCell.m
//  leyu
//
//  Created by zing1ng on 08/08/2017.
//  Copyright © 2017 zing1ng. All rights reserved.
//

#import "LYOverseeCell.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import "LYTradeInfo.h"
#import "Helper.h"
#import "UIView+YY.h"

#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define C7 [UIColor colorWithRed:194/255.f green:192/255.f blue:198/255.f alpha:1]
#define C2 [UIColor colorWithRed:83/255.f green:88/255.f blue:95/255.f alpha:1]

@interface LYOverseeCell()

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
@property (nonatomic, strong) UILabel *tFloatProfitRateLabel;
@property (nonatomic, strong) UILabel *vFloatProfitRateLabel;
@property (nonatomic, strong) UIView  *tradeInfoWrap;
@property (nonatomic, strong) UIView  *bottomLine;

@end

@implementation LYOverseeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _tPlatformLabel = [[UILabel alloc] init];
        _tPlatformLabel.textColor = C2;
        _tPlatformLabel.font = [UIFont boldSystemFontOfSize:18];
        _tPlatformLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_tPlatformLabel];
        
        _vPlatformLabel = [[UILabel alloc] init];
        _vPlatformLabel.textColor = C2;
        _vPrepaymentsLabel.textAlignment = NSTextAlignmentRight;
        _vPlatformLabel.font = [UIFont boldSystemFontOfSize:18];
        [_vPlatformLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vPlatformLabel];
        
        _tIpLabel = [[UILabel alloc] init];
        _tIpLabel.textColor = C2;
        _tIpLabel.text = @"客户:";
        _tIpLabel.font = [UIFont boldSystemFontOfSize:14];
        [_tIpLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tIpLabel];
        
        _vIpLabel = [[UILabel alloc] init];
        _vIpLabel.textColor = C2;
        _vIpLabel.textAlignment = NSTextAlignmentRight;
        _vIpLabel.font = [UIFont boldSystemFontOfSize:14];
        [_vIpLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vIpLabel];
        
        _tBalanceLabel = [[UILabel alloc] init];
        _tBalanceLabel.textColor = C2;
        _tBalanceLabel.text = @"余额:";
        _tBalanceLabel.font = [UIFont boldSystemFontOfSize:14];
        [_tBalanceLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tBalanceLabel];
        
        _vBalanceLabel = [[UILabel alloc] init];
        _vBalanceLabel.textColor = C2;
        _vBalanceLabel.textAlignment = NSTextAlignmentRight;
        _vBalanceLabel.font = [UIFont boldSystemFontOfSize:14];
        [_vBalanceLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vBalanceLabel];
        
        _tNetWorthLabel = [[UILabel alloc] init];
        _tNetWorthLabel.textColor = C2;
        _tNetWorthLabel.text = @"净值:";
        _tNetWorthLabel.font = [UIFont boldSystemFontOfSize:14];
        [_tNetWorthLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tNetWorthLabel];
        
        _vNetWorthLabel = [[UILabel alloc] init];
        _vNetWorthLabel.textColor = C2;
        _vNetWorthLabel.textAlignment = NSTextAlignmentRight;
        _vNetWorthLabel.font = [UIFont boldSystemFontOfSize:14];
        [_vNetWorthLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vNetWorthLabel];

        _tPrepaymentsLabel = [[UILabel alloc] init];
        _tPrepaymentsLabel.textColor = C2;
        _tPrepaymentsLabel.text = @"预付款:";
        _tPrepaymentsLabel.font = [UIFont boldSystemFontOfSize:14];
        [_tPrepaymentsLabel setSingleLineAutoResizeWithMaxWidth:200.f];
        [self.contentView addSubview:_tPrepaymentsLabel];
        
        _vPrepaymentsLabel = [[UILabel alloc] init];
        _vPrepaymentsLabel.textColor = C2;
        _vPrepaymentsLabel.textAlignment = NSTextAlignmentRight;
        _vPrepaymentsLabel.font = [UIFont boldSystemFontOfSize:14];
        [_vPrepaymentsLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vPrepaymentsLabel];

        _tAvailablePrepaidLabel = [[UILabel alloc] init];
        _tAvailablePrepaidLabel.textColor = C2;
        _tAvailablePrepaidLabel.text = @"可用预付款:";
        _tAvailablePrepaidLabel.font = [UIFont boldSystemFontOfSize:14];
        [_tAvailablePrepaidLabel setSingleLineAutoResizeWithMaxWidth:150.f];
        [self.contentView addSubview:_tAvailablePrepaidLabel];
        
        _vAvailablePrepaidLabel = [[UILabel alloc] init];
        _vAvailablePrepaidLabel.textColor = C2;
        _vAvailablePrepaidLabel.textAlignment = NSTextAlignmentRight;
        _vAvailablePrepaidLabel.font = [UIFont boldSystemFontOfSize:14];
        [_vAvailablePrepaidLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vAvailablePrepaidLabel];

        _tFloatProfitRateLabel = [[UILabel alloc] init];
        _tFloatProfitRateLabel.textColor = C2;
        _tFloatProfitRateLabel.text = @"浮动盈亏比:";
        _tFloatProfitRateLabel.font = [UIFont boldSystemFontOfSize:14];
        [_tFloatProfitRateLabel setSingleLineAutoResizeWithMaxWidth:150.f];
        [self.contentView addSubview:_tFloatProfitRateLabel];
        
        _vFloatProfitRateLabel = [[UILabel alloc] init];
        _vFloatProfitRateLabel.textColor = C2;
        _vFloatProfitRateLabel.textAlignment = NSTextAlignmentRight;
        _vFloatProfitRateLabel.font = [UIFont boldSystemFontOfSize:14];
        [_vFloatProfitRateLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self.contentView addSubview:_vFloatProfitRateLabel];

        _tradeInfoWrap = [[UIView alloc] init];
        _tradeInfoWrap.backgroundColor = [UIColor whiteColor];
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
    self.vPlatformLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 8)
    .heightIs(25);
 
    self.tPlatformLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 8)
    .rightSpaceToView(self.vPlatformLabel, 8)
    .heightIs(25);
    
    self.tIpLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.tPlatformLabel, 5)
    .heightIs(13);
    
    self.vIpLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topEqualToView(self.tIpLabel)
    .heightIs(13);
    
    self.tBalanceLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.tIpLabel, 5)
    .heightIs(13);
    
    self.vBalanceLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topEqualToView(self.tBalanceLabel)
    .heightIs(13);
    
    self.tNetWorthLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.tBalanceLabel, 5)
    .heightIs(13);
    
    self.vNetWorthLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topEqualToView(self.tNetWorthLabel)
    .heightIs(13);
    
    self.tPrepaymentsLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.tNetWorthLabel, 5)
    .heightIs(13);
    
    self.vPrepaymentsLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topEqualToView(self.tPrepaymentsLabel)
    .heightIs(13);
    
    self.tAvailablePrepaidLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.tPrepaymentsLabel, 5)
    .heightIs(13);
    
    self.vAvailablePrepaidLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topEqualToView(self.tAvailablePrepaidLabel)
    .heightIs(13);
    
    self.tFloatProfitRateLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.tAvailablePrepaidLabel, 5)
    .heightIs(13);
    
    self.vFloatProfitRateLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .topEqualToView(self.tFloatProfitRateLabel)
    .heightIs(13);

    self.tradeInfoWrap.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.tFloatProfitRateLabel, 5)
    .widthIs(WIN_WIDTH - 30);
    
}

- (void)setInfoModel:(LYTradeInfoModel *)infoModel
{
    _infoModel = infoModel;
    [_tradeInfoWrap removeAllSubviews];
    _infoModel = infoModel;
    _tPlatformLabel.text = infoModel.platform;
    _vPlatformLabel.text = infoModel.vPlatform;
    _vIpLabel.text = infoModel.ipAddress;
    _vBalanceLabel.text = infoModel.balance;
    _vNetWorthLabel.text = infoModel.netWorth;
    _vPrepaymentsLabel.text = infoModel.prePayments;
    _vAvailablePrepaidLabel.text = infoModel.avilablePrepaid;
    _tFloatProfitRateLabel.text = [NSString stringWithFormat:@"%@:", infoModel.tFloatProfit];
    _vFloatProfitRateLabel.text = infoModel.vFloatProfit;
    NSArray *infos = infoModel.tradeDatas;
    if (infos.count == 0) {
        _tradeInfoWrap.sd_layout
        .heightIs(1);
    }else{
        _tradeInfoWrap.sd_layout
        .heightIs(infos.count * 18);
    }
    
    [self setupAutoHeightWithBottomView:self.tradeInfoWrap bottomMargin:5];
    BOOL isRed;
    if ([infoModel.vPlatform compare:@"2000.00%" options:NSNumericSearch] == NSOrderedAscending) {
        _tPlatformLabel.textColor = [UIColor redColor];
        _vPlatformLabel.textColor = [UIColor redColor];
        _tIpLabel.textColor = [UIColor redColor];
        _vIpLabel.textColor = [UIColor redColor];
        _tBalanceLabel.textColor = [UIColor redColor];
        _vBalanceLabel.textColor = [UIColor redColor];
        _tNetWorthLabel.textColor = [UIColor redColor];
        _vNetWorthLabel.textColor = [UIColor redColor];
        _tPrepaymentsLabel.textColor = [UIColor redColor];
        _vPrepaymentsLabel.textColor = [UIColor redColor];
        _tAvailablePrepaidLabel.textColor = [UIColor redColor];
        _vAvailablePrepaidLabel.textColor = [UIColor redColor];
        isRed = true;
    }else{
        _tPlatformLabel.textColor = C2;
        _vPlatformLabel.textColor = C2;
        _tIpLabel.textColor = C2;
        _vIpLabel.textColor = C2;
        _tBalanceLabel.textColor = C2;
        _vBalanceLabel.textColor = C2;
        _tNetWorthLabel.textColor = C2;
        _vNetWorthLabel.textColor = C2;
        _tPrepaymentsLabel.textColor = C2;
        _vPrepaymentsLabel.textColor = C2;
        _tAvailablePrepaidLabel.textColor = C2;
        _vAvailablePrepaidLabel.textColor = C2;
        isRed = false;
 
    }

    [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LYTradeInfo *view = [[LYTradeInfo alloc] initWithFrame:CGRectMake(0, 18 * idx, WIN_WIDTH - 30, 13) data:obj redColor:isRed];
        [_tradeInfoWrap addSubview:view];
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
