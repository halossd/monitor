//
//  ViewController.m
//  monitor
//
//  Created by cc on 2019/8/5.
//  Copyright © 2019 cc. All rights reserved.
//

#import "ViewController.h"
#import "OverseeCell.h"
#import "TradeInfoModel.h"
#import "JFRWebSocket.h"
#import "JFRSecurity.h"
#import "Helper.h"
#import "MOCollectionViewLayout.h"

#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define NOTIFICATION_WEBSOCKET_CONNECT @"NOTIFICATION_WEBSOCKET_CONNECT"
#define CURRENT_HOST @"current_host"

@interface ViewController ()<JFRWebSocketDelegate, MOCollectionViewLayoutDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<TradeInfoModel *> *tbDatas;
@property(nonatomic, strong) JFRWebSocket *socket;
@property (nonatomic, copy) NSString *host;

//按账户分组
@property (nonatomic, strong) NSMutableArray *ticksArray;
@property (nonatomic, strong) NSMutableArray *accountsArray;

@property (nonatomic, strong) UILabel *stautsLabel;
@property (nonatomic, strong) UIView *topLeftView;
@property (nonatomic) __block BOOL canProcess;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationItem.title = @"交易风控";
    _canProcess = true;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveCache)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initSocket)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
//    _topLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    _stautsLabel = [[UILabel alloc] init];
    _stautsLabel.textColor = UIColor.whiteColor;
    _stautsLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _stautsLabel.text = @"交易风控";
    self.navigationItem.titleView = _stautsLabel;
    [_stautsLabel sizeToFit];
//    [_topLeftView addSubview:_stautsLabel];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_topLeftView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_setting"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(setHosturl)];
    
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.whiteColor;
    
    
    _host = [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_HOST];
    
    MOCollectionViewLayout *layout = [[MOCollectionViewLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT) collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColor.blackColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.directionalLockEnabled = YES;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[OverseeCell class] forCellWithReuseIdentifier:@"cell"];
    
    _tbDatas = [[NSMutableArray alloc] init];
    _ticksArray = [[NSMutableArray alloc] init];
    _accountsArray = [[NSMutableArray alloc] init];
    
    if ([Helper readCacheFile:@"status"] != nil) {
        NSArray *arr = [Helper readCacheFile:@"status"];
        self.accountsArray = [NSMutableArray arrayWithArray:arr];
    }
    
    if ([Helper readCacheFile:@"ticks"] != nil) {
        NSArray *arr = [Helper readCacheFile:@"ticks"];
        self.ticksArray = [NSMutableArray arrayWithArray:arr];
        if ([arr count] > 0 ) {
            for (NSDictionary *dic in arr) {
                TradeInfoModel *tr = [TradeInfoModel new];
                [tr convert:dic];
                [_tbDatas addObject:tr];
                [_collectionView reloadData];
            }
        }
    }
    
    [self initSocket];
}

- (void)setHosturl
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入地址" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = self.host ? self.host : @"请输入地址";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = alert.textFields.firstObject.text;
        NSString *placeHoldder = alert.textFields.firstObject.placeholder;
        if (![url containsString:@":"]) {
            url = [NSString stringWithFormat:@"%@:8089", url];
        }
        
        url = [url stringByReplacingOccurrencesOfString:@"：" withString:@":"];
        
        [self clearCacheData];
        [self.socket disconnect];
        
        if ([url isEqualToString:@""]) {
            self.host = placeHoldder;
        } else {
            self.host = url;
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:self.host forKey:CURRENT_HOST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self initSocket];

    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)alertMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)initSocket
{
    self.socket = [[JFRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@/echo", _host]] protocols:nil];
    self.socket.delegate = self;
    [self.socket connect];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_tbDatas count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OverseeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.data = _tbDatas[indexPath.row];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self calHeightWith:_tbDatas[indexPath.row]];
//}

- (NSUInteger)columnCountForLayout
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        UIInterfaceOrientation status=[UIApplication sharedApplication].statusBarOrientation;
        if (status == UIInterfaceOrientationPortrait || status == UIInterfaceOrientationPortraitUpsideDown) {
            return 1;
        } else {
            return 2;
        }
    } else {
        return 3;
    }
    return 1;
}

- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath
{
    return [self calHeightWith:_tbDatas[indexPath.row]];
}

- (CGSize)calHeightWith:(TradeInfoModel *)info {
    UIInterfaceOrientation status=[UIApplication sharedApplication].statusBarOrientation;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGFloat height = 153 - 28 - 6 + 25 + 8 + 40;
        height += info.orders.count * 17;
        CGFloat width = 0;
        if (status == UIInterfaceOrientationPortrait || status == UIInterfaceOrientationPortraitUpsideDown) {
            width = WIN_WIDTH;
        } else {
            width = 375;
        }
        
        return CGSizeMake(width, height);
    }else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGFloat height = 188 - 28 - 6 + 33 + 8 + 40;
        height += info.orders.count * 21;
        CGFloat w = 0;
        if (status == UIInterfaceOrientationPortrait || status == UIInterfaceOrientationPortraitUpsideDown) {
            w = (WIN_WIDTH - 10) / 2;
        } else {
            w = (WIN_WIDTH - 20) / 3;
        }
        return CGSizeMake(w, height);
    }
    return CGSizeZero;
}

#pragma mark - WebsocketDelegate
- (void)websocketDidConnect:(JFRWebSocket*)socket {
    NSLog(@"websocket is connected");
//    _stautsLabel.text = @"已连接";
    _stautsLabel.textColor = UIColor.whiteColor;
}

- (void)websocketDidDisconnect:(JFRWebSocket*)socket error:(NSError*)error {
    NSLog(@"websocket is disconnected: %@", [error localizedDescription]);
//    [self.socket connect];
//    _stautsLabel.text = @"已断开";
    _stautsLabel.textColor = UIColor.grayColor;
}

- (void)websocket:(JFRWebSocket*)socket didReceiveMessage:(NSString*)string {
    _stautsLabel.textColor = UIColor.whiteColor;
    if ([string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]){
        return;
    }
//    NSLog(@"Received string: %@", string);
    
    NSArray  *strs = [string componentsSeparatedByString:@"}\n{"];
    
    if (!_canProcess) {
        return;
    }
    
    if (strs.count == 1) {
        [self processResponsString:string];
    } else {
        for (int i=0; i < strs.count; i++) {
            NSString *str = strs[i];
            if (i == 0) {
                str = [NSString stringWithFormat:@"%@}", str];
            } else if (i == strs.count-1) {
                str = [NSString stringWithFormat:@"{%@", str];
            } else {
                str = [NSString stringWithFormat:@"{%@}", str];
            }
            [self processResponsString:str];
        }

    }

    
}

- (void)processResponsString:(NSString *)result
{
    NSDictionary *dic = [Helper dictionaryWithJsonString:result];
    if(dic == nil) {
        return;
    }
    TradeInfoModel *d = [TradeInfoModel new];
    [d convert:dic];
    NSString *account = d.account;
    
    if (_tbDatas && _tbDatas.count > 0) {
        [_tbDatas enumerateObjectsUsingBlock:^(TradeInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.accountsArray indexOfObject:account] != NSNotFound) {
                if ([account isEqualToString: obj.account]) {
                    [self.tbDatas replaceObjectAtIndex:idx withObject:d];
                    [self.ticksArray replaceObjectAtIndex:idx withObject:dic];
                    NSIndexPath *idp = [NSIndexPath indexPathForRow:idx inSection:0];
                    _canProcess = false;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.canProcess = true;
                    });
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadItemsAtIndexPaths:@[idp]];
                    });
                }
            } else {
                [self.tbDatas addObject:d];
                [self.accountsArray addObject:d.account];
                [self.ticksArray addObject:dic];
                [self.collectionView reloadData];
            }
        }];
    } else {
        [_tbDatas addObject:d];
        if ([_accountsArray indexOfObject:d.account] == NSNotFound) {
            [_accountsArray addObject:d.account];
            [_ticksArray addObject:dic];
        }
        [_collectionView reloadData];
    }
}

- (void)clearCacheData
{
    [_accountsArray removeAllObjects];
    [_ticksArray removeAllObjects];
    [_tbDatas removeAllObjects];
    [_collectionView reloadData];
    [Helper removeCacheFile:@"ticks"];
    [Helper removeCacheFile:@"status"];
}

- (void)saveCache
{
    if (_tbDatas == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [Helper createCacheFile:@"status" withData:self.accountsArray];
        [Helper createCacheFile:@"ticks" withData:self.ticksArray];
        NSLog(@"%@", self.ticksArray);
    });
    
}

@end
