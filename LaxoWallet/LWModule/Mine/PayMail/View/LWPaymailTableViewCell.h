//
//  LWPaymailTableViewCell.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWPaymailModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PaymailCellBlock)(NSString *paymailID);
@interface LWPaymailTableViewCell : UITableViewCell

@property (nonatomic, strong) LWPaymailModel *model;
@property (nonatomic, copy) PaymailCellBlock block;

@end

NS_ASSUME_NONNULL_END
