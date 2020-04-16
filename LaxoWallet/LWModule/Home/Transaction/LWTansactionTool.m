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
@property (nonatomic, strong) LWTransactionModel *transModel;

@property (nonatomic, assign) BOOL isAllTransaction;
@end

@implementation LWTansactionTool
static NSInteger const minChangeAmount = 546;//最小找零546聪

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

- (void)startTransactionWithTransactionModel:(LWTransactionModel *)transModel andTotalModel:(LWHomeWalletModel *)homeModel{
    self.transModel = transModel;
    self.model = homeModel;
    self.transAmount = [LWNumberTool formatFloadString:transModel.transAmount] * 1e8;
    self.note = transModel.note;
    self.transAddress = transModel.address;
    
    [self startTransactionWithAmount:transModel.transAmount.floatValue address:transModel.address note:transModel.note andTotalModel:homeModel andChangeAddress:transModel.changeAddress];
    
}


- (void)startTransactionWithAmount:(CGFloat)amount address:(NSString *)address note:(NSString *)note andTotalModel:(LWHomeWalletModel *)model andChangeAddress:(nonnull NSString *)changeAddress{
    
//    self.transAmount = amount;
//    self.transAddress = address;
    
//    self.model = model;
//    self.transAmount = amount * 1e8;
//    self.note = note;
//    self.transAddress = address;
    
//    [self requestTransactionToServer:nil];
//    return;
    
    
    char *transId = create_transaction();
    NSArray *changeArray = [self manageChange:self.transAmount];
    
    char *address_script = address_to_script([LWAddressTool stringToChar:self.transAddress]);
    NSString *address_script_str = [LWAddressTool charToString:address_script];
    if (!address_script_str || address_script_str.length == 0) {
        destroy_transaction(transId);
        [WMHUDUntil showMessageToWindow:@"Wrong Address"];
        return;
    }
    
    for (LWutxoModel *utxo in changeArray) {
        char *add_input = add_transaction_input(transId,[LWAddressTool stringToChar:utxo.txid], utxo.vout, address_to_script([LWAddressTool stringToChar:utxo.address]), utxo.value);
    }
    
    char *add_output = add_transaction_output(transId, address_to_script([LWAddressTool stringToChar:self.transAddress]), self.transAmount);
    if (![[LWAddressTool charToString:add_output] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        destroy_transaction(transId);
        return;
    }
    
    char *add_transaction_change_char = add_transaction_change(transId, address_to_script([LWAddressTool stringToChar:changeAddress]));
    if (![[LWAddressTool charToString:add_transaction_change_char] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        destroy_transaction(transId);
        return;
    }
    char *fee = get_transaction_fee(transId);
    self.fee = [LWAddressTool charToString:fee];
    self.isAllTransaction = NO;
    int feeInt = abs(self.fee.intValue);
    if (self.fee.integerValue < 0 || feeInt + self.transAmount > self.model.canuseBitCountInterger) {
        destroy_transaction(transId);
        self.isAllTransaction = YES;
        
        transId = create_transaction();
        
        NSArray *changeArray = [self manageChange:self.transAmount];
        for (LWutxoModel *utxo in changeArray) {
            char *add_input = add_transaction_input(transId,[LWAddressTool stringToChar:utxo.txid], utxo.vout, address_to_script([LWAddressTool stringToChar:utxo.address]), utxo.value);
        }
        
        char *add_transaction_change_char = add_transaction_change(transId, address_to_script([LWAddressTool stringToChar:self.transAddress]));
        if (![[LWAddressTool charToString:add_transaction_change_char] isEqualToString:@"true"]) {
            [WMHUDUntil showMessageToWindow:@"transaction fail"];
            return;
        }
        char *feeTemp = get_transaction_fee(transId);
        self.fee = [LWAddressTool charToString:feeTemp];
    }
    
    self.transId = transId;
    self.changeArray = changeArray;
    
    if (self.isAllTransaction) {
        self.transAmount = self.model.canuseBitCountInterger - self.fee.integerValue;
        self.transModel.transAmount = [LWNumberTool formatSSSFloat:self.transAmount/1e8];
    }
    self.transModel.fee = self.fee;
}

- (void)setNoteMessage:(NSString *)note{
    self.transModel.note = note;
    self.note = note;
}

- (void)transStart{
    [SVProgressHUD show];

    char *transId = self.transId;
    NSArray *changeArray = self.changeArray;

    char *get_sighash = get_transaction_sighash(transId);
    NSLog(@"get_transaction_sighash(%s)",transId);

    NSArray *sighHashArray = [LWAddressTool charToObject:get_sighash];

    __block dispatch_semaphore_t semaphore;
    dispatch_queue_t queue = dispatch_queue_create("transStartQueue", 0);
    dispatch_async(queue, ^{
        
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
                if([[LWAddressTool charToString:add_transaction_sig_char] isEqualToString:@"false"]){
                    [SVProgressHUD dismiss];
                    if (self.transactionBlock) {
                        self.transactionBlock(NO);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [WMHUDUntil showMessageToWindow:@"sig error"];
                    });
                    dispatch_semaphore_signal(semaphore);
                    return ;
                }

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
    
    if (!trans_str || trans_str.length == 0) {
        trans_str = @"";
    }
    
    NSString *biz_data = self.transModel.address;
    if (self.transModel.payMail && self.transModel.payMail.length>0) {
        biz_data = [NSString stringWithFormat:@"%@(%@)",self.transModel.payMail,self.transModel.address];
    }
    
    NSDictionary *multipyparams = @{@"rawtx":trans_str,@"wid":@(self.model.walletId),@"value":@(self.transAmount),@"note":self.note,@"biz_data":biz_data};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBroadcastTrans),@"wallet.broadcast",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    /*
    transactionToJson => msgpack => msgpackdata
    msgpackdata => tohexStr 转成16进制
    broadcast(ctx,params)
 */
}


- (NSArray *)manageChange:(NSInteger)transAmount{
    transAmount = transAmount + minChangeAmount;//
    //零钱排序
    NSArray *utxo = self.model.utxo;
    NSMutableArray *chageUtxoArray = [NSMutableArray array];
    for (NSInteger i = 0; i<utxo.count; i++) {
        LWutxoModel *utxoModel = utxo[i];
        if (utxoModel.status == 1) {
            if (utxoModel.value > transAmount) {
                [chageUtxoArray addObj:utxoModel];
                if ([self enoughFee:chageUtxoArray]) {
                    break;
                }else{
                   if( i == utxo.count -1) break;
                }
            }else{
                transAmount = transAmount - utxoModel.value;
                [chageUtxoArray addObj:utxoModel];
            }
        }
    }
    return chageUtxoArray;
}

- (BOOL)enoughFee:(NSArray *)changeTempArray{
    char * transId = create_transaction();
      
    NSArray *changeArray = changeTempArray;
    NSInteger changeAmount = 0;
    for (LWutxoModel *utxo in changeArray) {
        char *add_input = add_transaction_input(transId,[LWAddressTool stringToChar:utxo.txid], utxo.vout, address_to_script([LWAddressTool stringToChar:utxo.address]), utxo.value);
        changeAmount += utxo.value;
    }
      
    char *add_transaction_change_char = add_transaction_change(transId, address_to_script([LWAddressTool stringToChar:self.transAddress]));
    char *feeTemp = get_transaction_fee(transId);
    
    if (changeAmount > self.transAmount + [LWAddressTool charToString:feeTemp].integerValue + minChangeAmount) {
        destroy_transaction(transId);
        return YES;
    }else{
        destroy_transaction(transId);
        return NO;
    }
}

#pragma mark - boardCast
- (void)boardCast:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
     if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
        NSLog(@"broadcastNotificationSuccess");
         [SVProgressHUD dismiss];
        if (self.transactionBlock) {
            self.transactionBlock(self.transModel);
        }
    }else{
        NSLog(@"%@",notiDic);
        [SVProgressHUD dismiss];
        if (self.transactionBlock) {
            self.transactionBlock(NO);
        }
        [WMHUDUntil showMessageToWindow:@"trans error"];
    }
}

@end
