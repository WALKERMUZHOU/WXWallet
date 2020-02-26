//
//  LWMessageDeleteTableViewCell.h
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/26.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellSelectBlock)(BOOL isSelect);
@interface LWMessageDeleteTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) CellSelectBlock cellSelectBlock;

@end

NS_ASSUME_NONNULL_END
