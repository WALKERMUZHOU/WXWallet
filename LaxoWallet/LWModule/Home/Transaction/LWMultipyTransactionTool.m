//
//  LWMultipyTransactionTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/13.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyTransactionTool.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"
#import "LWMultipySignTool.h"
#import "NSData+HexString.h"

@interface LWMultipyTransactionTool ()

@property (nonatomic, assign) NSInteger transAmount;
@property (nonatomic, strong) NSString  *transAddress;
@property (nonatomic, strong) NSString  *note;
@property (nonatomic, strong) LWHomeWalletModel  *model;
@property (nonatomic, strong) LWTransactionModel  *transModel;

@property (nonatomic, assign) char  *transId;
@property (nonatomic, strong) NSArray *changeArray;

@end


@implementation LWMultipyTransactionTool


static LWMultipyTransactionTool *instance = nil;
+ (LWMultipyTransactionTool *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWMultipyTransactionTool alloc]init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCast:) name:kWebScoket_boardcast_trans object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardCastUnSignTrans:) name:kWebScoket_multipyUnSignTrans object:nil];

    }
    return self;
}

- (void)startTransactionWithTranscationModek:(LWTransactionModel *)transModel andTotalModel:(LWHomeWalletModel *)model{
    self.model = model;
    self.transModel = transModel;
    
    [self startTransactionWithAmount:transModel.transAmount.floatValue address:transModel.address note:transModel.note andTotalModel:model andChangeAddress:transModel.changeAddress];
}

- (void)startTransactionWithAmount:(CGFloat)amount address:(NSString *)address note:(NSString *)note andTotalModel:(LWHomeWalletModel *)model andChangeAddress:(nonnull NSString *)changeAddress{
        
    self.model = model;
    self.transAmount = amount * 1e8;
    self.note = note;
    self.transAddress = address;
    
    char *transId = create_transaction();
    NSArray *changeArray = [self manageChange:self.transAmount];
    for (LWutxoModel *utxo in changeArray) {
        char *add_input = add_transaction_input(transId,[LWAddressTool stringToChar:utxo.txid], utxo.vout, address_to_script([LWAddressTool stringToChar:utxo.address]), utxo.value);
        NSLog(@"add_transaction_input(%s \n, %@\n,%ld \n, %s \n,%ld \n)",transId,utxo.txid,(long)utxo.vout,address_to_script([LWAddressTool stringToChar:utxo.address]),(long)utxo.value);
    }
    
    char *address_script =  address_to_script([LWAddressTool stringToChar:self.transAddress]);
    if (!address_script) {
        destroy_transaction(transId);
        [WMHUDUntil showMessageToWindow:@"Wrong Address"];
        return;
    }
    
    char *add_change = add_transaction_change(transId,address_to_script([LWAddressTool stringToChar:changeAddress]));
    NSLog(@"add_transaction_change(%s , %s)",transId,address_to_script([LWAddressTool stringToChar:[self.model.deposit objectForKey:@"address"]]));
    
    
    char *add_output = add_transaction_output(transId, address_to_script([LWAddressTool stringToChar:self.transAddress]), self.transAmount);
    NSLog(@"add_transaction_output(%s , %s , %ld )",transId,address_to_script([LWAddressTool stringToChar:self.transAddress]),(long)self.transAmount);

    if (![[LWAddressTool charToString:add_output] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        return;
    }


    if (![[LWAddressTool charToString:add_change] isEqualToString:@"true"]) {
        [WMHUDUntil showMessageToWindow:@"transaction fail"];
        return;
    }
    
    char *get_sighash = get_transaction_sighash(transId);
    NSLog(@"get_transaction_sighash(%s)",transId);

    self.transId = transId;
    self.changeArray = changeArray;
    
    char *fee = get_transaction_fee(transId);
    self.fee = [LWAddressTool charToString:fee];
        
    NSArray *sighHashArray = [LWAddressTool charToObject:get_sighash];

    NSMutableArray *transaction_sig_array = [NSMutableArray array];
    
}

- (void)transStart{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *transaction_to_json_char = transaction_to_json(self.transId);
        [self broadcastUnSignTranscationToServer:[LWAddressTool charToObject:transaction_to_json_char]];
        NSLog(@"%s",transaction_to_json_char);
    });
}

- (void)broadcastUnSignTranscationToServer:(NSDictionary *)transaction{

    NSData *trans_data = [transaction mp_messagePack];
    NSString *trans_str = [trans_data dataToHexString];
    
    NSString *biz_data = self.transModel.address;
    if (self.transModel.payMail && self.transModel.payMail.length >0) {
        biz_data = [NSString stringWithFormat:@"%@(%@)",self.transModel.payMail,self.transModel.address];
    }
    
    NSDictionary *multipyparams = @{@"rawtx":trans_str,@"wid":@(self.model.walletId),@"value":@(self.transAmount),@"note":self.note,@"biz_data":biz_data};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBroadcastUnSignTrans),WS_Home_multipyUnSignTrans,[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
    [SVProgressHUD dismiss];
}


//- (void)requestTransactionToServer:(NSDictionary *)transactionToJson{
//
//    NSData *trans_data = [transactionToJson mp_messagePack];
//    NSString *trans_str = [trans_data dataToHexString];
//    
//    NSDictionary *multipyparams = @{@"rawtx":trans_str,@"wid":@(self.model.walletId),@"value":@(self.transAmount),@"note":self.note};
//    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryBroadcastTrans),@"wallet.broadcast",[multipyparams jsonStringEncoded]];
//    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];
//    [SVProgressHUD dismiss];
//
//}

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

- (void)boardCast:(NSNotification *)notification{
    NSDictionary *notiDic = notification.object;
    NSLog(@"broadcastNotificationSuccess");
    if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
//        if (self.transactionBlock) {
//            self.transactionBlock(YES);
//        }
        
    }
}

- (void)boardCastUnSignTrans:(NSNotification *)notification{
        NSDictionary *notiDic = notification.object;
        NSLog(@"broadcastNotificationSuccess");
        if ([[notiDic objectForKey:@"success"] integerValue] == 1) {
            if (self.block) {
                self.block([notiDic objectForKey:@"data"]);
            }
    //        if (self.transactionBlock) {
    //            self.transactionBlock(YES);
    //        }
            /**
             
             {
                 data =     {
                     approve = 0;
                     createtime = 1584071497000;
                     fee = 0;
                     id = 7c34ffca2a9ee8fee76f424975e389b7;
                     note = "";
                     raw = 85a776657273696f6e01a468617368d94033643462306239336565373035393464633262623862633730646637613464366561356138663162333033653864636463616435313664313739303936396333a6696e707574739185a6736372697074da01fc66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666a66f757470757482a6736372697074d9323736613931343639383965346362643261303135643832316534373336366264616631343230646433656135363838386163a87361746f73686973ce0490a855ab6f7574707574496e64657800ae73657175656e63654e756d626572ceffffffffa87072657654784964d94064366139653437663361653064643766366232623833663135626239663137613064643364663033353361636465313563323632656663396166346230386265a96e4c6f636b54696d6500a76f7574707574739282a6736372697074d9323736613931343638303965303133643337363063656432626164643538636637356166333538613536353662303338386163a87361746f73686973ce01312d0082a6736372697074d9323736613931343639383965346362643261303135643832316534373336366264616631343230646433656135363838386163a87361746f73686973ce035f7a99;
                     reject = 0;
                     status = 1;
                     txid = 3d4b0b93ee70594dc2bb8bc70df7a4d6ea5a8f1b303e8dcdcad516d1790969c3;
                     type = 2;
                     uid = 1005;
                     value = 20000000;
                     wid = 16;
                 };
                 success = 1;
             }
             
             */
            
        }else{
            [WMHUDUntil showMessageToWindow:[NSString stringWithFormat: @"error:%@",[notiDic objectForKey:@"success"]]];
        }
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

@end
