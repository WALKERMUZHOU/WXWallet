//
//  LWPersoanlReceiveView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/18.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWPersoanlReceiveView.h"
#import "LBXScanNative.h"

@interface LWPersoanlReceiveView ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodelImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymailLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) LWHomeWalletModel *model;
@end

@implementation LWPersoanlReceiveView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.doneLabel.layer.borderColor = [UIColor hex:@"DBDBDB"].CGColor;
    [WMZDialogTool setView:self.backView Radii:CGSizeMake(20,20) RoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.backView.layer.cornerRadius = 20;
}

- (void)setContentModel:(LWHomeWalletModel *)model{
    self.model = model;
    NSString *address = model.address;
    UIImage *qrImage = [LBXScanNative createQRWithString:address QRSize:CGSizeMake(400, 400)];
    [self.qrcodelImgView setImage:qrImage];
    
    if (model.name && model.name.length >0) {
        self.namelabel.text = model.name;
    }else{
        self.namelabel.text = @"BSV";
    }
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@",address];

}
- (IBAction)doneClick:(UIButton *)sender {
    if (self.block) {
         self.block();
     }
}
- (IBAction)addressCopy:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:self.addressLabel.text];
    [WMHUDUntil showMessageToWindow:@"Copy Success"];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
