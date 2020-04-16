//
//  LWSendHistoryPaymailView.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/4/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HistoryPaymailBlock)(NSString *selectPaymail);
@interface LWSendHistoryPaymailView : LWBaseTableView

@property (nonatomic, copy) HistoryPaymailBlock block;

- (void)addpayMail:(NSString *)paymail;

@end

NS_ASSUME_NONNULL_END
