//
//  LWPersonalListTableViewCell.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/19.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWPersonalListTableViewCell : UITableViewCell
@property (nonatomic, strong) LWMessageModel *model;

@end

NS_ASSUME_NONNULL_END
