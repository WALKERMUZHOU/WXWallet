//
//  LWRecoveryTrustholdsView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/7.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWRecoveryTrustholdsView.h"
#import "LogicHandle.h"
#import "LWLoginCoordinator.h"

@interface LWRecoveryTrustholdsView ()
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation LWRecoveryTrustholdsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (IBAction)getCodeClick:(UIButton *)sender {
//    [LWLoginCoordinator getRecoverySMSCodeWithEmail:<#(nonnull NSString *)#> WithSuccessBlock:<#^(id  _Nonnull data)successBlock#> WithFailBlock:<#^(id  _Nonnull data)FailBlock#>]
    
    
}

- (IBAction)recoveryClick:(UIButton *)sender {
    
    
    
    [LogicHandle showTabbarVC];
    
}
@end
