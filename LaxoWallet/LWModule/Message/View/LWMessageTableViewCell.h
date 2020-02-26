//
//  LWMessageTableViewCell.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWHomeWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) LWHomeWalletModel *model;

@end

NS_ASSUME_NONNULL_END
