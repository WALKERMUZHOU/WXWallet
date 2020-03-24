//
//  LWMultipyWalletDetailCell.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/20.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWMultipyWalletDetailCell.h"

@interface LWMultipyWalletDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bitCountLabel;

@property (weak, nonatomic) IBOutlet UIView *statueBackView;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueDescribeLabel;

@end

@implementation LWMultipyWalletDetailCell

- (void)setCotentmodel:(LWHomeWalletModel *)cotentmodel{
    _cotentmodel = cotentmodel;
}

- (void)setModel:(LWMessageModel *)model{
    _model = model;
    
    NSDateFormatter *dateStringFormatter = [[NSDateFormatter alloc] init];
    [dateStringFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.createtime.integerValue/1000];
    NSString *time = [dateStringFormatter stringFromDate:date];

    self.timeLabel.text = [LWTimeTool subStingOfYMD:time abbreviations:YES EnglishShortNameForDate:NO];;
    NSString *biCountStr = [LWNumberTool formatSSSFloat:_model.value/1e8];
    if (_model.status == 2){
        if (_model.type == 2) {//转出
            
            NSDictionary *userStatues = _model.user_status;
            NSArray *approve = [userStatues objectForKey:@"approve"];
            NSArray *reject = [userStatues objectForKey:@"reject"];
            
            self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",biCountStr];
            self.typeLabel.text = @"Sent";
            self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
            self.statueLabel.text = @"Success";
            self.statueBackView.backgroundColor = lwColorNormal;
            self.statueDescribeLabel.text = [NSString stringWithFormat:@"Transaction success.\n%ld of %ld members signed",(long)( approve.count),(long)(_cotentmodel.share)];
        }
    }else if(_model.status == 1){//未完成
        
        NSDictionary *userStatues = _model.user_status;
        NSArray *approve = [userStatues objectForKey:@"approve"];
        NSArray *reject = [userStatues objectForKey:@"reject"];
        
        if (_model.isMineCreateTrans) {
            if (approve.count == 0) {//outgoing
                self.typeLabel.text = @"OUTGOING";
                self.iconImageView.image = [UIImage imageNamed:@"home_wallet_waiting"];

                self.statueBackView.backgroundColor = lwColorRedLight;
                self.statueLabel.text = @"RECALL TX?";
                self.statueDescribeLabel.text = @"Until the first sign you can cancel this transaction";
            }else{// you unSigned / you signed

                NSInteger ismineSigned = 0;
                for (NSInteger i = 0; i<approve.count; i++) {
                    NSString *approveID = [NSString stringWithFormat:@"%@",approve[i]];
                    if ([approveID isEqualToString:[[LWUserManager shareInstance] getUserModel].uid]) {
                        ismineSigned = 1;
                        break;
                    }
                }
                
                if (ismineSigned == 1 && approve.count == 1) {
                    self.typeLabel.text = @"OUTGOING";
                    self.iconImageView.image = [UIImage imageNamed:@"home_wallet_waiting"];

                    self.statueBackView.backgroundColor = lwColorRedLight;
                    self.statueLabel.text = @"RECALL TX?";
                    self.statueDescribeLabel.text = @"Until the first sign you can cancel this transaction";
       
                }else if(ismineSigned==1){
                
                    self.typeLabel.text = @"SENT";
                    self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
                    self.statueBackView.backgroundColor = lwColorNormalDeep;
                    self.statueLabel.text = @"Signed";
                    self.statueDescribeLabel.text = [NSString stringWithFormat:@"You’ve signed.\nAwaiting others to sign (%ld of %ld)",(long)(_cotentmodel.threshold - approve.count),(long)(_cotentmodel.threshold)];
                    
                }else{//
                    self.iconImageView.image = [UIImage imageNamed:@"home_wallet_pending"];
                    self.typeLabel.text = @"PENDING";

                    self.statueBackView.backgroundColor = lwColorOrange;
                     self.statueLabel.text = @"UNSIGNED";
                     self.statueDescribeLabel.text = [NSString stringWithFormat:@"Awaiting you to sign"];
                }
                
            }
        }else{
            if (approve.count == 0) {//outgoing
                self.iconImageView.image = [UIImage imageNamed:@"home_wallet_pending"];

                 self.typeLabel.text = @"PENDING";
                 self.statueBackView.backgroundColor = lwColorOrange;
                 self.statueLabel.text = @"UNSIGNED";
                 self.statueDescribeLabel.text = @"Awaiting you to sign";
             }else{// you unSigned / you signed
                 
                 NSInteger ismineSigned = 0;
                 for (NSInteger i = 0; i<approve.count; i++) {
                     NSString *approveID = [NSString stringWithFormat:@"%@",approve[i]];
                     if ([approveID isEqualToString:[[LWUserManager shareInstance] getUserModel].uid]) {
                         ismineSigned = 1;
                         break;
                     }
                 }
                 
                 if (ismineSigned == 1) {
                     self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
                     self.statueBackView.backgroundColor = lwColorNormalDeep;
                     self.statueLabel.text = @"Signed";
                     self.statueDescribeLabel.text = [NSString stringWithFormat:@"You’ve signed.\n Awaiting others to sign (%ld of %ld)",(long)(_cotentmodel.threshold - approve.count),(long)(_cotentmodel.threshold)];
                 }else{//
                     self.iconImageView.image = [UIImage imageNamed:@"home_wallet_pending"];

                     self.statueBackView.backgroundColor = lwColorOrange;
                      self.statueLabel.text = @"UnSigned";
                      self.statueDescribeLabel.text = [NSString stringWithFormat:@"Awaiting you to sign"];
                 }
                 
             }
        }

    }else{
        self.typeLabel.text = @"Cancel";
        self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
    }
    self.bitCountLabel.text = [NSString stringWithFormat:@"-%@",biCountStr];

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
