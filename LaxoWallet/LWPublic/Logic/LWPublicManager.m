//
//  LWPublicManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPublicManager.h"
#import "CBSecp256k1.h"
#import "NSData+HexString.h"
#import "libthresholdsig.h"
#import "LWAddressTool.h"

@implementation LWPublicManager

+ (LWCurrentLanguage)getCurrentLanguage{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentLanguage_userdefault];
    if (language && [language isEqualToString:@"Chinese"]) {
        return LWCurrentLanguageChinese;
    }
    return LWCurrentLanguageEnglish;
}

+ (LWCurrentCurrency)getCurrentCurrency{
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentCurrencyName_userdefault];
    if (currency && [currency isEqualToString:@"cny"]) {
        return LWCurrentCurrencyCNY;
    }
    return LWCurrentCurrencyUSD;
}

+ (NSString *)getCurrentCurrencyEnglishCode{
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentCurrencyName_userdefault];
    if (currency && currency.length>0) {
        return currency;
    }
    return @"USD";
}


+ (NSString *)getCurrentCurrencyPrice{
    return [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV];
}

+ (NSString *)getCurrentUSDPrice{
    
    NSString *tokenName = @"bsv";
    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppTokenPrice_userdefault];
    for (NSInteger i = 0; i<dataArray.count; i++) {
        NSDictionary *tokenDic = [dataArray objectAtIndex:i];
        if ([[tokenDic objectForKey:@"token"] isEqualToString:tokenName]) {
            return [tokenDic objectForKey:@"usd"];
        }
    }
    return @"";
}

+ (NSString *)getCurrentCurrencyPriceWithAmount:(CGFloat)amount{
    NSString *currentcy = [LWPublicManager getCurrentPriceWithTokenType:TokenTypeBSV];
    
    CGFloat totalAmount = amount * currentcy.floatValue;
    if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
        return [NSString stringWithFormat:@"¥ %.2f",totalAmount];
    }
    
    return [NSString stringWithFormat:@"$ %.2f",totalAmount];
}

+ (void)setCurrentLanguage:(LWCurrentLanguage)languageType{
    NSString *laguage ;
    if (languageType == LWCurrentLanguageChinese) {
        laguage = @"Chinese";
    }else{
        laguage = @"English";
    }
    [[NSUserDefaults standardUserDefaults] setObject:laguage forKey:kAppCurrentLanguage_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setCurrentCurrency:(LWCurrentCurrency)currencyType{
    NSString *laguage ;
    if (currencyType == LWCurrentCurrencyCNY) {
        laguage = @"cny";
    }else{
        laguage = @"usd";
    }
    [[NSUserDefaults standardUserDefaults] setObject:laguage forKey:kAppCurrentCurrencyName_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setCurrentCurrencyEnglishCode:(NSString *)currency{
    [[NSUserDefaults standardUserDefaults] setObject:[currency uppercaseString] forKey:kAppCurrentCurrencyName_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCurrentPriceWithTokenType:(TokenType)tokenType{
    NSString *tokenName;
    switch (tokenType) {
         case TokenTypeBSV:
            tokenName = @"bsv";
             break;
        case TokenTypeBitCoin:
            tokenName = @"bitCoin";
                break;
             
         default:
             break;
     }
    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppTokenPrice_userdefault];
    for (NSInteger i = 0; i<dataArray.count; i++) {
        NSDictionary *tokenDic = [dataArray objectAtIndex:i];
        if ([[tokenDic objectForKey:@"token"] isEqualToString:tokenName]) {
            if ([LWPublicManager getCurrentCurrency] == LWCurrentCurrencyCNY) {
                return [tokenDic objectForKey:@"cny"];
            }else{
                return [tokenDic objectForKey:@"usd"];
            };
        }
    }
    return @"";
}

+ (NSString *)getPubkeyWithPriKey:(NSString *)prikey{
    char *pubkey = get_public_key([LWAddressTool stringToChar:prikey]);
//    NSData *prvData = [NSData hexStringToData:prikey];
//    NSData *publickey = [CBSecp256k1 generatePublicKeyWithPrivateKey:prvData compression:YES];
//    NSLog(@"pubkey:%@\n publickey:%@",[LWAddressTool charToString:pubkey],[publickey hexString]);
    return [LWAddressTool charToString:pubkey];
}

+ (NSString *)getPKWithZhuJiCi{
    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
    NSString *seed = userModel.jiZhuCi;

    if (!seed || seed.length == 0) {//注册时未保存seed
       NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
        seed = [infoDic objectForKey:@"seed"];

        userModel.jiZhuCi = seed;
        [[LWUserManager shareInstance] setUser:userModel];
    }
    
    char *pk = derive_key([LWAddressTool stringToChar:seed], [LWAddressTool stringToChar:@"m/0"]);
    return [LWAddressTool charToString:pk];
}

+ (NSString *)getPubKeyWithZhuJiCi{
    LWUserModel *userModel = [[LWUserManager shareInstance] getUserModel];
    NSString *seed = userModel.jiZhuCi;

    if (!seed || seed.length == 0) {//注册时未保存seed
       NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
        seed = [infoDic objectForKey:@"seed"];
        userModel.jiZhuCi = seed;
        [[LWUserManager shareInstance] setUser:userModel];
    }
    char *pk = derive_key([LWAddressTool stringToChar:seed], [LWAddressTool stringToChar:@"m/0"]);

//    NSData *priData = [NSData hexStringToData:[NSString stringWithFormat:@"%s",pk]];
//    NSData *publicckey = [CBSecp256k1 generatePublicKeyWithPrivateKey:priData compression:YES];
//
    char *pubkey = get_public_key(pk);
 
//    NSLog(@"pubkey:%@\n publickey:%@",[LWAddressTool charToString:pubkey],[publicckey hexString]);
    
    return [LWAddressTool charToString:pubkey];
    
    
}

+ (NSString *)getPKWithZhuJiCiAndPath:(NSString *)path{
    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;
    
    if (!seed || seed.length == 0) {//注册时未保存seed
       NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
        seed = [infoDic objectForKey:@"seed"];
    }
    
    char *pk = derive_key([LWAddressTool stringToChar:seed], [LWAddressTool stringToChar:path]);
    return [LWAddressTool charToString:pk];
}

+ (NSString *)getRecoverJizhuciWithShares:(NSArray *)shares{
    char *combine_shares_char = combine_shares([LWAddressTool objectToChar:shares]);
    return [LWAddressTool charToString:combine_shares_char];
}

+ (NSString *)getSigWithMessage:(NSString *)timeStr{
    NSString *prikey = [LWPublicManager getPKWithZhuJiCi];
    char *get_message_sig_char = get_message_sig([LWAddressTool stringToChar:timeStr], [LWAddressTool stringToChar:prikey]);
    return [LWAddressTool charToString:get_message_sig_char];
}

+ (NSString *)getRecoverQRCodeStr{
    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;
    NSString *secret = [[LWUserManager shareInstance] getUserModel].secret;

    NSString *ecryptResult = [LWEncryptTool encrywithTheKey:[secret md5String] message:seed andHex:0 returnType:1];
    return ecryptResult;
}

+ (NSDictionary *)getInitData{
    char *seed = get_seed();
    char *pk = derive_key(seed, [LWAddressTool stringToChar:@"m/0"]);
    char *secret = sha256(pk);
    char *shares = get_shares(seed, 2, 2);
    char *recover_seed = combine_shares(shares);
    char *publickey = get_public_key(pk);
    char *xpub = get_xpub(seed);
    NSString *shares_str = [LWAddressTool charToString:shares];
    NSArray *sharesArray = [NSJSONSerialization JSONObjectWithData:[shares_str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    
    NSDictionary *initDic = @{@"pk":[LWAddressTool charToString:pk],
    @"publicKey":[LWAddressTool charToString:publickey],
    @"secret":[LWAddressTool charToString:secret],
    @"seed":[LWAddressTool charToString:seed],
                              @"xpub":[LWAddressTool charToString:xpub],
    @"shares":sharesArray
    };
    [[NSUserDefaults standardUserDefaults] setObject:initDic forKey:kAppPubkeyManager_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return initDic;
}

+ (NSString *)getInitDataPK{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    return [infoDic objectForKey:@"pk"];
}

+ (NSString *)getInitDataPubKey{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppPubkeyManager_userdefault];
    return [infoDic objectForKey:@"publicKey"];
}

+ (void)getPersonalWalletData{
    NSDictionary *params = @{@"type":@1};
    NSArray *requestPersonalWalletArray = @[@"req",
                                            @(WSRequestIdWalletQueryPersonalWallet),
                                            @"wallet.query",
                                            [params jsonStringEncoded]];
    NSData *data = [requestPersonalWalletArray mp_messagePack];
    
    [[SocketRocketUtility instance] sendData:data];

}

+ (void)getMultipyWalletData{
    NSDictionary *multipyparams = @{@"type":@2};
    NSArray *requestmultipyWalletArray = @[@"req",@(WSRequestIdWalletQueryMulpityWallet),@"wallet.query",[multipyparams jsonStringEncoded]];
    [[SocketRocketUtility instance] sendData:[requestmultipyWalletArray mp_messagePack]];

}

+ (LWHomeWalletModel *)getPersonalFirstWallet{
     NSString *personalWallet = [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalWallet_userdefault];

    if (!personalWallet || personalWallet.length == 0) {
        return nil;
    }
    
     NSDictionary *personalWalletDic = [NSJSONSerialization JSONObjectWithData:[personalWallet dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
     
     NSArray *personalDataArray = [NSArray modelArrayWithClass:[LWHomeWalletModel class] json:[personalWalletDic objectForKey:@"data"]];
     
     if (personalDataArray.count == 0) {
         return nil;
     }else{
         return personalDataArray[0];
     }
     
}


@end
