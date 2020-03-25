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

@property (nonatomic, assign) char  *transId;
@property (nonatomic, strong) NSArray *changeArray;

@end

@implementation LWTansactionTool

static LWTansactionTool *instance = nil;
+ (LWTansactionTool *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWTansactionTool alloc]init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_boardcast_trans object:nil];
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


- (void)startTransactionWithAmount:(CGFloat)amount address:(NSString *)address note:(NSString *)note andTotalModel:(LWHomeWalletModel *)model andChangeAddress:(nonnull NSString *)changeAddress{
    
//    self.transAmount = amount;
//    self.transAddress = address;
    
    self.model = model;
    self.transAmount = amount * 1e8;
    self.note = note;
    self.transAddress = address;
    
//    [self requestTransactionToServer:nil];
//    return;
    
    
    char *transId = create_transaction();
    NSArray *changeArray = [self manageChange:self.transAmount];
    for (LWutxoModel *utxo in changeArray) {
        char *add_input = add_transaction_input(transId,[LWAddressTool stringToChar:utxo.txid], utxo.vout, address_to_script([LWAddressTool stringToChar:utxo.address]), utxo.value);
    }
    
    char *add_output = add_transaction_output(transId, address_to_script([LWAddressTool stringToChar:self.transAddress]), self.transAmount);
    if (![[LWAddressTool charToString:add_output] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        return;
    }
    
    char *add_transaction_change_char = add_transaction_change(transId, address_to_script([LWAddressTool stringToChar:changeAddress]));
    if (![[LWAddressTool charToString:add_transaction_change_char] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        return;
    }
    char *fee = get_transaction_fee(transId);
    self.fee = [LWAddressTool charToString:fee];
    
    if (self.fee.floatValue + self.transAmount > self.model.canuseBitCount) {
        destroy_transaction(transId);
        
        transId = create_transaction();
        
        NSArray *changeArray = [self manageChange:self.transAmount];
        for (LWutxoModel *utxo in changeArray) {
            char *add_input = add_transaction_input(transId,[LWAddressTool stringToChar:utxo.txid], utxo.vout, address_to_script([LWAddressTool stringToChar:utxo.address]), utxo.value);
        }
        
        char *add_transaction_change_char = add_transaction_change(transId, address_to_script([LWAddressTool stringToChar:changeAddress]));
        if (![[LWAddressTool charToString:add_transaction_change_char] isEqualToString:@"true"]) {
            [WMHUDUntil showMessageToWindow:@"transaction fail"];
            return;
        }
        char *feeTemp = get_transaction_fee(transId);
        self.fee = [LWAddressTool charToString:feeTemp];
    }
    
    self.transId = transId;
    self.changeArray = changeArray;
}

- (void)transStart{
    [SVProgressHUD show];

    char *transId = self.transId;
    NSArray *changeArray = self.changeArray;
//    char *add_change = add_transaction_change(transId,address_to_script([LWAddressTool stringToChar:[self.model.deposit objectForKey:@"address"]]));
//    NSLog(@"add_transaction_change(%s , %s)",transId,address_to_script([LWAddressTool stringToChar:[self.model.deposit objectForKey:@"address"]]));


    
        char *get_sighash = get_transaction_sighash(transId);
        NSLog(@"get_transaction_sighash(%s)",transId);
    
        NSArray *sighHashArray = [LWAddressTool charToObject:get_sighash];

        __block dispatch_semaphore_t semaphore;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            for (NSInteger i = 0; i<sighHashArray.count; i++) {
                semaphore = dispatch_semaphore_create(0);
                LWutxoModel *utxo = [changeArray objectAtIndex:i];
                NSString *sign_hash = sighHashArray[i];

                LWSignTool *signTool = [[LWSignTool alloc] init];
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
            destroy_transaction(transId);

        });
}

- (void)requestTransactionToServer:(NSDictionary *)transactionToJson{
    NSData *trans_data = [transactionToJson mp_messagePack];
    NSString *trans_str = [trans_data dataToHexString];
    
    NSDictionary *multipyparams = @{@"rawtx":trans_str,@"wid":@(self.model.walletId),@"value":@(self.transAmount),@"note":self.note,@"biz_data":self.transAddress};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBroadcastTrans),@"wallet.broadcast",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
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
        if (utxoModel.status == 1) {
            if (utxoModel.value > transAmount) {
                [chageUtxoArray addObj:utxoModel];
                break;
            }else{
                transAmount = transAmount - utxoModel.value;
                [chageUtxoArray addObj:utxoModel];
            }
        }
    }
    return chageUtxoArray;
}

//手续费和差值比较
- (void)checkFeeAndAmountWithTotalAmount{
    
}



- (void)boardCast:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
     if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSLog(@"broadcastNotificationSuccess");
         [SVProgressHUD dismiss];
        if (self.transactionBlock) {
            self.transactionBlock(YES);
        }
    }else{
        NSLog(@"%@",notiDic);
        [SVProgressHUD dismiss];
        [WMHUDUntil showMessageToWindow:@"trans error"];
    }
}

@end
