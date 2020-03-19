//
//  LWPersoanlReceiveView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersoanlReceiveView.h"

@interface LWPersoanlReceiveView ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodelImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymailLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneLabel;

@end

@implementation LWPersoanlReceiveView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.doneLabel.layer.borderColor = [UIColor hex:@"D8D8D8"].CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
