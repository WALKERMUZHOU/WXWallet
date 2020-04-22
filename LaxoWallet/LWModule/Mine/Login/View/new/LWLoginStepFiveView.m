//
//  LWLoginStepFiveView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/15.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWLoginStepFiveView.h"

@interface LWLoginStepFiveView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end

@implementation LWLoginStepFiveView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.text = kLocalizable(@"login_face_create");
    NSString *allstring = [kLocalizable(@"login_face_tobe") stringByAppendingString:kLocalizable(@"login_face_learnMore")];

    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:allstring attributes:@{NSFontAttributeName:kFont(16)}];
    [attribute addAttributes:@{NSFontAttributeName:kMediumFont(16),NSForegroundColorAttributeName:lwColorNormal} range:[allstring rangeOfString:kLocalizable(@"login_face_learnMore")]];
    self.describeLabel.attributedText = attribute;
}

- (IBAction)nextClick:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}
- (IBAction)learnMore:(UIButton *)sender {
    [LWAlertTool alertloginLaeanMoreFace];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
