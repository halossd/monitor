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

#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define NOTIFICATION_WEBSOCKET_CONNECT @"NOTIFICATION_WEBSOCKET_CONNECT"
#define CURRENT_HOST @"current_host"

@interface ViewController ()<JFRWebSocketDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<TradeInfoModel *> *tbDatas;
@property(nonatomic, strong) JFRWebSocket *socket;

@property (nonatomic, copy) NSString *host;

//按账户分组
@property (nonatomic, strong) NSMutableArray *ticksArray;
@property (nonatomic, strong) NSMutableArray *accountsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"交易风控";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveCache)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_setting"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(setHosturl)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.whiteColor;
    
    _host = @"192.168.1.223:8089";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColor.blackColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
        [self clearCacheData];
        [self.socket disconnect];
        self.host = url;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calHeightWith:_tbDatas[indexPath.row]];
}

- (CGSize)calHeightWith:(TradeInfoModel *)info {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGFloat height = 168 + 25 + 10 + 50;
        height += info.orders.count * 18;
        return CGSizeMake(WIN_WIDTH, height);
    }else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGFloat height = 208 + 33 + 10 + 50;
        height += info.orders.count * 18;
        return CGSizeMake(375, height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIEdgeInsetsMake(10, 0, 0, 0);;
    } else {
        return UIEdgeInsetsMake(20, 20, 0, 0);
    }
}

#pragma mark - WebsocketDelegate
- (void)websocketDidConnect:(JFRWebSocket*)socket {
    NSLog(@"websocket is connected");
}

- (void)websocketDidDisconnect:(JFRWebSocket*)socket error:(NSError*)error {
    NSLog(@"websocket is disconnected: %@", [error localizedDescription]);
    [self.socket connect];
}

- (void)websocket:(JFRWebSocket*)socket didReceiveMessage:(NSString*)string {
    if ([string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]){
        return;
    }
    NSLog(@"Received string: %@", string);
    
    NSDictionary *dic = [Helper dictionaryWithJsonString:string];
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadItemsAtIndexPaths:@[idp]];
//                        OverseeCell *cell = [self.collectionView cellForItemAtIndexPath:idp];
//                        cell.data = d;
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
