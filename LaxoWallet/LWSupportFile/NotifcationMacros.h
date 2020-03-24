//
//  NotifcationMacros.h
//  CQMServicePlatform
//
//  Created by walkerman on 2017/7/19.
//  Copyright © 2017年 yanbo. All rights reserved.
//

#ifndef NotifcationMacros_h
#define NotifcationMacros_h

#pragma mark - notification
#define kUserAccountLogOut          @"userAccountLogOut"
#define KUserAccountLogIn           @"userAccountLogIn"
#define kUserAccountChangeMobile    @"userAccountChangeMobile"
#define kLanguageChange_nsnotification  @"kLanguageChange_nsnotification"
#define kCurrencyChange_nsnotification  @"kCurrencyChange_nsnotification"

#define kWebScoket_personalWalletData      @"kWebScoket_personalWalletData"
#define kWebScoket_multipyWalletData       @"kWebScoket_multipyWalletData"

#define kWebScoket_createSingleAddress      @"kWebScoket_createSingleAddress"
#define kWebScoket_createSingleAddress_change      @"kWebScoket_createSingleAddress_change"

#define kWebScoket_createMultiPartyWallet   @"kWebScoket_createMultiParty"
#define kWebScoket_queryTransaction         @"kWebScoket_queryTransaction"
#define kWebScoket_getMessageListInfo       @"kWebScoket_getMessageInfo"
#define kWebScoket_joinWallet               @"kWebScoket_joinWallet"
#define kWebScoket_messageDetail            @"kWebScoket_messageDetail"

#define kWebScoket_messageListInfo          @"kWebScoket_messageListInfo"
#define kWebScoket_messageParties           @"kWebScoket_messageParties"
#define kWebScoket_userIsOnLine             @"kWebScoket_userIsOnLine"
#define kWebScoket_getTheKey                @"kWebScoket_getTheKey"
#define kWebScoket_boardcast                @"kWebScoket_boardcast"
#define kWebScoket_pollBroadcast            @"kWebScoket_pollBroadcast"

#define kWebScoket_Multipy_refrshWalletDetail              @"kWebScoket_Multipy_refrshWalletDetail"


#define kWebScoket_MultipyBroadcast_sig     @"kWebScoket_MultipySignBoardcast"
#define kWebScoket_MultipyBroadcast_address @"kWebScoket_MultipyAddressBroadcast"
#define kWebScoket_MultipyPollBroadcast_sig @"kWebScoket_MultipySignPollBroadcast"
#define kWebScoket_MultipyPollBroadcast_address       @"kWebScoket_MultipyAddressPollBroadcast"

#define kWebScoket_confirmAddress           @"kWebScoket_confirmAddress"
#define kWebScoket_requestPartySign         @"kWebScoket_requestPartySign"
#define kWebScoket_getkeyshare              @"kWebScoket_getsharedkey"
#define kWebScoket_boardcast_trans          @"kWebScoket_boardcast_trans"
#define kWebScoket_multipyAddress           @"kWebScoket_multipyAddress"
#define kWebScoket_multipyUnSignTrans       @"kWebScoket_multipyUnSignTrans"
#define kWebScoket_multipySubmitSig         @"kWebScoket_multipySubmitSig"

#define kWebScoket_scanLogin                @"kWebScoket_scanLogin"

#define kWebScoket_multipy_JoinWallet         @"kWebScoket_multipy_JoinWallet"
#define kWebScoket_multipy_sign               @"kWebScoket_multipy_sign"
#define kWebScoket_multipy_rejectSign         @"kWebScoket_multipy_rejectSign"
#define kWebScoket_multipy_cancelTrans        @"kWebScoket_multipy_cancelTrans"

#define kWebScoket_walletReName               @"kWebScoket_walletReName"
#define kWebScoket_CreatePersonalWallet       @"kWebScoket_CreatePersonalWallet"

#define kWebScoket_paymail_update       @"kWebScoket_paymail_update"
#define kWebScoket_paymail_queryByWid       @"kWebScoket_paymail_queryByWid"
#define kWebScoket_paymail_setMain       @"kWebScoket_paymail_setMain"
#define kWebScoket_paymail_query      @"kWebScoket_paymail_query"
#define kWebScoket_paymail_add       @"kWebScoket_paymail_add"




#pragma mark - Userdefault
#define kAppConstantFirstInstall    @"kAppConstantFirstInstall"

#define kHomeMaterialData           @"kHome_Material_Data"
#define kSmallLoanCreditMaterial    @"kSmallLoanCreditMaterial"
#define kRefreshUserInfo            @"kRefreshUserInfo"
#define kPopVerifyIndetification    @"kPopVerifyIndetification"
#define kCancelOrderNotification    @"kCancelOrderNotification"
#define kSmallLoanTipsUserDefault   @"kSmallLoanTipsNotification"
#define kAppStatueUserDefault       @"kAppStatueUserDefault"
#define kAppLastUserPhone           @"kAppLastUserPhone"
#define kAppContactMobile           @"kAppcustomerContactMobile"
#define kAppUnReadMessage           @"kAppUnReadMessage"

#define kRevocerSuccessKey_userdefault    @"kAppRevocerSuccessKey_userdefault"
#define kAppPubkeyManager_userdefault     @"NSUserDefaultPubkeyManagerssss"
#define kAppTouchIdStart_userdefault      @"kAppTouchIdStart_userdefault"
///当前币价格
#define kAppTokenPrice_userdefault        @"kAppTokenPrice_userdefault"

#define kAppCurrentLanguage_userdefault   @"kAppCurrentLanguage_userdefault"
#define kAppCurrentCurrency_userdefault   @"kAppCurrentCurrency_userdefault"
#define kAppCreateMulitpyAddress_userdefault   @"kAppCreateMulitpyAddress_userdefault"

#define kPersonalWallet_userdefault        @"kPersonalWallet_userdefault"
#define kMultipyWallet_userdefault        @"kMultipyWallet_userdefault"


#endif /* NotifcationMacros_h */
