//
//  LYOverseeController.m
//  leyu
//
//  Created by zing1ng on 08/08/2017.
//  Copyright © 2017 zing1ng. All rights reserved.
//

#import "LYOverseeController.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "LYOverseeCell.h"
#import "LYTradeInfoModel.h"
#import "JFRWebSocket.h"
#import "JFRSecurity.h"
#import "Helper.h"

#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define NOTIFICATION_WEBSOCKET_CONNECT @"NOTIFICATION_WEBSOCKET_CONNECT"

@interface LYOverseeController ()<JFRWebSocketDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tbDatas;

@property(nonatomic, strong) JFRWebSocket *socket;

//按账户分组
@property (nonatomic, strong) NSMutableArray *ticksArray;
@property (nonatomic, strong) NSMutableArray *accountsArray;

@end

@implementation LYOverseeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"状态";
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"btn_refresh_Dapp"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(clearCacheData) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    
    [self initSocket];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectServer)
                                                 name:NOTIFICATION_WEBSOCKET_CONNECT
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveCache)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
 
    _tbDatas = [[NSMutableArray alloc] init];
    _ticksArray = [[NSMutableArray alloc] init];
    _accountsArray = [[NSMutableArray alloc] init];
    
    if ([Helper readCacheFile:@"status"] != nil) {
        NSMutableArray *arr = [NSMutableArray arrayWithObject:[Helper readCacheFile:@"status"]];
        if (arr[0] && [arr[0] count] > 0) {
            
            _accountsArray = [NSMutableArray arrayWithArray:arr[0]];
            for (NSArray *data in arr[0]) {
                if (data && data.count > 0) {
                    LYTradeInfoModel *model = [self getTradeInfo:data];
                    [_tbDatas addObject:model];
                    [_tableView reloadData];
                }
            }
        }
    }
    
    if ([Helper readCacheFile:@"ticks"] != nil) {
        NSMutableArray *arr = [NSMutableArray arrayWithObject:[Helper readCacheFile:@"ticks"]];
        if (arr[0] && [arr[0] count] > 0) {
            _ticksArray = [NSMutableArray arrayWithArray:arr[0]];
        }
    }
}

- (void)clearCacheData
{
    [_accountsArray removeAllObjects];
    [_ticksArray removeAllObjects];
    [_tbDatas removeAllObjects];
    [_tableView reloadData];
    [Helper removeCacheFile:@"ticks"];
    [Helper removeCacheFile:@"status"];
}

- (void)connectServer
{
    if (self.socket && self.socket.isConnected == false) {
        [self.socket connect];
    }
}

- (void)initSocket
{
    self.socket = [[JFRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://54.248.214.130:8089/echo"] protocols:nil];
    self.socket.delegate = self;
    [self.socket connect];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tbDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"LYOverseeCell";
    
    LYOverseeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LYOverseeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setInfoModel:self.tbDatas[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tbDatas count] <= indexPath.row) {
        return 0;
    }
    return [self.tableView cellHeightForIndexPath:indexPath cellContentViewWidth:WIN_WIDTH tableView:self.tableView];
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)websocketDidConnect:(JFRWebSocket*)socket {
    NSLog(@"websocket is connected");
}

-(void)websocketDidDisconnect:(JFRWebSocket*)socket error:(NSError*)error {
    NSLog(@"websocket is disconnected: %@", [error localizedDescription]);
    [self.socket connect];
}

-(void)websocket:(JFRWebSocket*)socket didReceiveMessage:(NSString*)string {
    if ([string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]){
        return;
    }
    NSLog(@"Received string: %@", string);
    if (string.length > 300) {
        NSLog(@"出问题了: %@", string);
    }
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *dicArray = [str componentsSeparatedByString:@","];
    for (NSString *obj in dicArray) {
        if (obj && ![obj isEqualToString:@""] && ![obj isKindOfClass:[NSNull class]]){
            NSArray *seedArray = [obj componentsSeparatedByString:@":"];
            if (seedArray.count > 1) {
                NSString *key = seedArray[0];
                NSString *value = seedArray[1];
                NSDictionary *dic = @{key: value};
                [dataArray addObject:dic];
            }
        }
    }
    
    NSDictionary *dic = dataArray[0];
    NSString *account = dic.allKeys[0];
 
    if (_tbDatas && _tbDatas.count > 0) {
            [_tbDatas enumerateObjectsUsingBlock:^(LYTradeInfoModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([_ticksArray indexOfObject:account] != NSNotFound) {
                    if ([account isEqualToString:model.platform]) {
                        LYTradeInfoModel * model1 = [self getTradeInfo:dataArray];
                        [_tbDatas replaceObjectAtIndex:idx withObject:model1];
                        [_accountsArray replaceObjectAtIndex:idx withObject:dataArray];
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:idx inSection:0];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LYOverseeCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                            cell.infoModel = model1;
                        });
                    }
                } else {
                    [_ticksArray addObject:account];
                    [_tbDatas addObject:[self getTradeInfo:dataArray]];
                    [_accountsArray addObject:dataArray];
                    [_tableView reloadData];
                }
            }];
    } else {
        [_tbDatas addObject:[self getTradeInfo:dataArray]];
        if ([_ticksArray indexOfObject:account] == NSNotFound) {
            [_accountsArray addObject:dataArray];
            [_ticksArray addObject:account];

        }
        [_tableView reloadData];
    }
}

- (LYTradeInfoModel *)getTradeInfo:(NSArray *)dataArray
{
    LYTradeInfoModel *model = [[LYTradeInfoModel alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *obj = dataArray[i];
        
        if (i == 0) {
            model.platform = obj.allKeys[0];
            model.vPlatform = obj.allValues[0];
            continue;
        }
        if (i == 1){
            model.ipAddress = obj.allValues[0];
            continue;
        }
        if (i == 2) {
            model.balance = obj.allValues[0];
            continue;
        }
        
        if (i == 3) {
            model.netWorth = obj.allValues[0];
            continue;
        }
        
        if (i == 4) {
            model.prePayments = obj.allValues[0];
            continue;
        }
        
        if (i == 5) {
            model.avilablePrepaid = obj.allValues[0];
            continue;
        }
        
        if (i == 6) {
            model.tFloatProfit = obj.allKeys[0];
            model.vFloatProfit = obj.allValues[0];
            continue;
        }
        
        if (i == dataArray.count - 1) {
            NSString *key = obj.allKeys[0];
            NSString *value = obj.allValues[0];
            NSDictionary *dic = @{@"trade_title": key, @"trade_amount": value};
            [model.tradeDatas addObject:dic];
        }
        
        if (i > 6 && i != dataArray.count - 1) {
            NSString *key = obj.allKeys[0];
            NSString *value = obj.allValues[0];
            NSDictionary *dic = @{@"trade_title": key, @"trade_amount": value};
            [model.tradeDatas addObject:dic];
            continue;
        }
        
    }
 
    return model;
}

- (void)updateTableDatas
{
    
}

-(void)websocket:(JFRWebSocket*)socket didReceiveData:(NSData*)data {
    NSLog(@"Received data: %@", data);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveCache];
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.socket disconnect];
    self.socket = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
