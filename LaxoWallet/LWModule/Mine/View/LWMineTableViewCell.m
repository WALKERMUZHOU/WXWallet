//
//  LWMineTableViewCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/24.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMineTableViewCell.h"
#import "PublicKeyView.h"
#import "LBXScanNative.h"

@interface LWMineTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UILabel *contentdesLabel;
@end

@implementation LWMineTableViewCell

- (void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    self.titleDesLabel.text = [_infoDic objectForKey:@"title"];
    NSInteger type = [[_infoDic objectForKey:@"type"] integerValue];
    if (type == 1) {
        self.downLoadBtn.hidden = YES;
        self.rightArrow.hidden = NO;
        self.contentdesLabel.hidden = YES;
    }else if(type == 2){
        self.downLoadBtn.hidden = NO;
        self.rightArrow.hidden = YES;
        self.contentdesLabel.hidden = YES;
    }else if (type == 3){
        self.downLoadBtn.hidden = YES;
        self.rightArrow.hidden = NO;
        self.contentdesLabel.hidden = NO;
        self.contentdesLabel.text = [_infoDic objectForKey:@"content"];
    }
}
- (IBAction)downLoadClick:(UIButton *)sender {
    [SVProgressHUD show];
    NSString *seed = [[LWUserManager shareInstance] getUserModel].jiZhuCi;
    NSString *secret = [[LWUserManager shareInstance] getUserModel].secret;
    
    NSString *jsStr = [NSString stringWithFormat:@"encryptWithKey('%@','%@',0)",[secret md5String],seed];
    PublicKeyView *pbView = [PublicKeyView shareInstance];
    [pbView getOtherData:jsStr andBlock:^(id  _Nonnull dicData) {
        if (dicData) {
            UIImage *qrImage = [LBXScanNative createQRWithString:dicData QRSize:CGSizeMake(400, 400)];
            UIImageWriteToSavedPhotosAlbum(qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }else{

        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [SVProgressHUD dismiss];
        NSString *msg = nil ;
        if(error){
            msg = @"保存图片失败" ;
        }else{
            msg = @"保存图片成功" ;
        }
    [WMHUDUntil showMessageToWindow:msg];
    
}

//UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//#pragma mark -- <保存到相册>
//-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    NSString *msg = nil ;
//    if(error){
//        msg = @"保存图片失败" ;
//    }else{
//        msg = @"保存图片成功" ;
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
