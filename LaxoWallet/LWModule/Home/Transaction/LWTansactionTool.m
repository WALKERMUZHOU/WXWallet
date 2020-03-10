//
//  LWTansactionTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/10.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWTansactionTool.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"
#import "LWSignTool.h"
#import "NSData+HexString.h"

@interface LWTansactionTool ()

@property (nonatomic, assign) NSInteger transAmount;
@property (nonatomic, strong) NSString  *transAddress;
@property (nonatomic, strong) NSString  *note;
@property (nonatomic, strong) LWHomeWalletModel  *model;

@end

@implementation LWTansactionTool

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_boardcast object:nil];
    }
    return self;
}

/*
 //返回id
 char *trans = create_transaction();

 //我要消耗哪些钱
 char *add_transaction_input(const char *id,
                             const char *txid,
                             uint8_t vout,
                             const char *script,
                             int64_t amount);

//明确知道给哪个地址转多少钱
 char *add_transaction_output(const char *id, const char *script, int64_t amount);
 
 //id 调用对象id
 char *add_transaction_change(const char *id, const char *script);
 */


- (void)startTransactionWithAmount:(CGFloat)amount address:(NSString *)address note:(NSString *)note andTotalModel:(LWHomeWalletModel *)model{
//    self.transAmount = amount;
//    self.transAddress = address;
    [SVProgressHUD show];
    
    self.model = model;
    self.transAmount = 0.01 * 1e8;
    self.note = note;
    self.transAddress = @"1J7mdg5rbQyUHENYdx39WVWK7fsLpEoXZy";
    
//    [self requestTransactionToServer:nil];
//    return;
    
    
    char *transId = create_transaction();
    NSArray *changeArray = [self manageChange:self.transAmount];
    for (LWutxoModel *utxo in changeArray) {
        char *add_input = add_transaction_input(transId,[LWAddressTool stringToChar:utxo.txid], utxo.vout, address_to_script([LWAddressTool stringToChar:utxo.address]), utxo.value);
        NSLog(@"add_transaction_input(%s \n, %@\n,%ld \n, %s \n,%ld \n)",transId,utxo.txid,(long)utxo.vout,address_to_script([LWAddressTool stringToChar:utxo.address]),(long)utxo.value);
    }
    
    
    
    char *add_output = add_transaction_output(transId, address_to_script([LWAddressTool stringToChar:self.transAddress]), self.transAmount);
    NSLog(@"add_transaction_output(%s , %s , %ld )",transId,address_to_script([LWAddressTool stringToChar:self.transAddress]),(long)self.transAmount);

    if (![[LWAddressTool charToString:add_output] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        return;
    }
    
    char *add_change = add_transaction_change(transId,address_to_script([LWAddressTool stringToChar:[self.model.deposit objectForKey:@"address"]]));
    NSLog(@"add_transaction_change(%s , %s)",transId,address_to_script([LWAddressTool stringToChar:[self.model.deposit objectForKey:@"address"]]));

    if (![[LWAddressTool charToString:add_change] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        return;
    }
    
    char *get_sighash = get_transaction_sighash(transId);
    NSLog(@"get_transaction_sighash(%s)",transId);

    NSArray *sighHashArray = [LWAddressTool charToObject:get_sighash];
    
//    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
//    char *pubkey = get_public_key([LWAddressTool stringToChar:userModel.pk]);
//
    NSMutableArray *transaction_sig_array = [NSMutableArray array];
    __block dispatch_semaphore_t semaphore;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NSInteger i = 0; i<sighHashArray.count; i++) {
            semaphore = dispatch_semaphore_create(0);
            LWutxoModel *utxo = [changeArray objectAtIndex:i];
            NSString *sign_hash = sighHashArray[i];

            LWSignTool *signTool = [LWSignTool shareInstance];
            [signTool setWithAddress:utxo.address andHash:sign_hash];
            signTool.signBlock = ^(NSDictionary * _Nonnull sign) {
                NSString *r = [sign objectForKey:@"r"];
                NSString *signStr = [sign objectForKey:@"sign"];
                NSString *pubkey = [sign objectForKey:@"pubkey"];

                char *add_transaction_sig_char = add_transaction_sig(transId, i, [LWAddressTool stringToChar:pubkey], [LWAddressTool stringToChar:r], [LWAddressTool stringToChar:signStr]);

                NSLog(@"add_transaction_sig(%s, %ld , %s , %s , %s)",transId,(long)i,[LWAddressTool stringToChar:pubkey], [LWAddressTool stringToChar:r], [LWAddressTool stringToChar:signStr]);

                dispatch_semaphore_signal(semaphore);
            };
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        char *transaction_to_json_char = transaction_to_json(transId);
        [self requestTransactionToServer:[LWAddressTool charToObject:transaction_to_json_char]];
        NSLog(@"%s",transaction_to_json_char);
    });
    
}

- (void)requestTransactionToServer:(NSDictionary *)transactionToJson{
    
    //NSDictionary *trans_dic = @{@"hash":@"40e6607fd65a6da308487fd473d13fad2d83bd7fabd5be8d732c5d466c4e37c1",@"inputs":@[@{@"output":@{@"satoshis":@(9744735),@"script":@"76a91404a4aed8add944c0ec34de0fa960cdff12db456988ac"},@"outputIndex":@(0),@"prevTxId":@"3f1ba570632e27278cc0a824177589f1a843232ffcb368f4a32f35b338aee8c8",@"script":@"483045022100c861431b67f2511df863f81d3b8cb31dfea02c878de381cc167fd560029b61cb022011c02a0a47fa8a71c67b048c6dd67ae882ffcaacaa55b7bb31b62e399804f19241210294c8dbda492d6d39dd29212a085105870dd25bf128c4c9e5330544d02f5bd58d",@"sequenceNumber":@(4294967295)},@{@"output":@{@"satoshis":@(96784028),@"script":@"76a9142cfa8e4e9cc31c062d83bd72f0bb98974a59fc7c88ac"},@"outputIndex":@(0),@"prevTxId":@"832a42e325ae6d1669874ffce600e44d0393ee42118b8f72356515b65c50eda3",@"script":@"4830450221008c479e5f4a2b05d5b40d2b2b3bb7a65a9ab7c89d4437f68ff163d58ed3e8c8d4022012ffb1fa57b4280562d713a9ddc02b9b8ebbecf5c6aa947d752498b114aa607a4121029afd0e600caf0c9253d0507aa0f58f1a7751d48ffaac4ce9211747bce308bccc",@"sequenceNumber":@(4294967295)}],@"nLockTime":@(0),@"outputs":@[@{@"satoshis":@(20000000),@"script":@"76a914bbc1e42a39d05a4cc61752d6963b7f69d09bb27b88ac"},@{@"satoshis":@(86528427),@"script":@"76a9142cfa8e4e9cc31c062d83bd72f0bb98974a59fc7c88ac"}],@"version":@(1)};
    
    NSData *trans_data = [transactionToJson mp_messagePack];
    NSString *trans_str = [trans_data dataToHexString];
    
    NSDictionary *multipyparams = @{@"rawtx":trans_str,@"wid":@(self.model.walletId),@"value":@(self.transAmount),@"note":self.note};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBoardCast),@"message.set",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    [SVProgressHUD dismiss];
    /*
    transactionToJson => msgpack => msgpackdata
    msgpackdata => tohexStr 转成16进制
    broadcast(ctx,params)
 */
}


- (NSArray *)manageChange:(CGFloat)transAmount{
    //零钱排序
    NSArray *utxo = self.model.utxo;
    NSMutableArray *chageUtxoArray = [NSMutableArray array];
    for (NSInteger i = 0; i<utxo.count; i++) {
        
        LWutxoModel *utxoModel = utxo[i];
        if (utxoModel.value > transAmount) {
            [chageUtxoArray addObj:utxoModel];
            break;
        }else{
            transAmount = transAmount - utxoModel.value;
            [chageUtxoArray addObj:utxoModel];
        }
    }
    return chageUtxoArray;
}

- (void)boardCast:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    NSLog(@"broadcastNotificationSuccess");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        if (self.transactionBlock) {
            self.transactionBlock(YES);
        }
        
    }
}

@end
