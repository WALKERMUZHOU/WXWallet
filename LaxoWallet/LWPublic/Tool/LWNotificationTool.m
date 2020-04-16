//
//  LWNotificationTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/9.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWNotificationTool.h"
#import "LWPersonalWalletDetailViewController.h"
#import "LWMultipyWalletDetailViewController.h"
#import "LWMultipyBeInvitedViewController.h"
#import "LWBaseWebViewController.h"

#import "LWStartViewController.h"
@implementation LWNotificationTool

+ (void)manageNotifictionObject:(NSDictionary *)userinfo{
    NSLog(@"%@",userinfo);
    
    AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *selectVC = appdelete.window.rootViewController;
    if ([selectVC isKindOfClass:[LWStartViewController class]]) {
        NSString *type = [userinfo objectForKey:@"type"];
        if (type && type.length >0) {
            [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:kAppNotification_userdefault];
        }
    }else if ([selectVC isKindOfClass:[UITabBarController class]]){
        NSString *type = [userinfo objectForKey:@"type"];
        if (type && type.length >0) {
           if ([type isEqualToString:@"receive"]) {
               NSInteger walletID = [[userinfo objectForKey:@"walletID"] integerValue];
               if (walletID && walletID >0) {
                   NSInteger walletType = [userinfo ds_integerForKey:@"walletType"];
                   if (walletType == 1) {
                       NSString *personalStr = [[NSUserDefaults standardUserDefaults] objectForKey:kPersonalWallet_userdefault];
                       NSDictionary *personalDic = [NSJSONSerialization JSONObjectWithData:[personalStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                       NSArray *personalArray =[NSArray modelArrayWithClass:[LWHomeWalletModel class] json:[personalDic objectForKey:@"data"]];
                       for (NSInteger i = 0; i<personalArray.count; i++) {
                           LWHomeWalletModel *model = [personalArray objectAtIndex:i];
                           if (model.walletId == walletID) {
                               LWPersonalWalletDetailViewController *multipyWallet = [[LWPersonalWalletDetailViewController alloc] init];
                               multipyWallet.contentModel = model;
                               [LogicHandle pushViewController:multipyWallet];
                               return;
                           }
                       }
                   }else if(walletType == 2){
                       NSString *personalStr = [[NSUserDefaults standardUserDefaults] objectForKey:kMultipyWallet_userdefault];
                       NSDictionary *personalDic = [NSJSONSerialization JSONObjectWithData:[personalStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                       NSArray *personalArray =[NSArray modelArrayWithClass:[LWHomeWalletModel class] json:[personalDic objectForKey:@"data"]];

                       for (NSInteger i = 0; i<personalArray.count; i++) {
                           LWHomeWalletModel *model = [personalArray objectAtIndex:i];
                           if (model.walletId == walletID) {
                               LWMultipyWalletDetailViewController *multipyWallet = [[LWMultipyWalletDetailViewController alloc] init];
                               multipyWallet.contentModel = model;
                               [LogicHandle pushViewController:multipyWallet];
                               return;
                           }
                        }
                   }
               }
           }else if ([type isEqualToString:@"otherCreateMultipyWallet"]){
               NSInteger walletID = [[userinfo objectForKey:@"walletID"] integerValue];
               NSString *personalStr = [[NSUserDefaults standardUserDefaults] objectForKey:kMultipyWallet_userdefault];
               NSDictionary *personalDic = [NSJSONSerialization JSONObjectWithData:[personalStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
               NSArray *personalArray =[NSArray modelArrayWithClass:[LWHomeWalletModel class] json:[personalDic objectForKey:@"data"]];
               for (NSInteger i = 0; i<personalArray.count; i++) {
                    LWHomeWalletModel *model = [personalArray objectAtIndex:i];
                    if (model.walletId == walletID) {
                        LWMultipyBeInvitedViewController  *multipyVC = [[LWMultipyBeInvitedViewController alloc] init];
                         multipyVC.contentModel = model;
                         [LogicHandle pushViewController:multipyVC animate:YES];
                        return;
                    }
               }
           }else if ([type isEqualToString:@"otherCreateTransaction"]){
                NSInteger walletID = [[userinfo objectForKey:@"walletID"] integerValue];
                NSString *personalStr = [[NSUserDefaults standardUserDefaults] objectForKey:kMultipyWallet_userdefault];
                    
               NSDictionary *personalDic = [NSJSONSerialization JSONObjectWithData:[personalStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
               NSArray *personalArray =[NSArray modelArrayWithClass:[LWHomeWalletModel class] json:[personalDic objectForKey:@"data"]];

                for (NSInteger i = 0; i<personalArray.count; i++) {
                   LWHomeWalletModel *model = [personalArray objectAtIndex:i];
                   if (model.walletId == walletID) {
                       LWMultipyWalletDetailViewController *multipyWallet = [[LWMultipyWalletDetailViewController alloc] init];
                       multipyWallet.contentModel = model;
                       [LogicHandle pushViewController:multipyWallet];
                       return;
                   }
                }
           }else if ([type isEqualToString:@"webView"]){
               LWBaseWebViewController *webVC = [[LWBaseWebViewController alloc] init];
               NSString *urlStr = [userinfo objectForKey:@"url"];
               if (urlStr && urlStr.length > 0) {
                   webVC.url = urlStr;
                   [LogicHandle pushViewController:webVC];
               }
           }
       }
    }else{
           
    }
    

    
}


@end
