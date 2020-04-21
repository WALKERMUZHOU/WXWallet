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
            self.typeLabel.text = kLocalizable(@"common_Sent");
            self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
            self.statueLabel.text = kLocalizable(@"common_success");
            self.statueBackView.backgroundColor = lwColorNormal;
            self.statueDescribeLabel.text = [NSString stringWithFormat:@"%@. %ld/%ld %@",kLocalizable(@"wallet_detail_transSuccess"),(long)( approve.count),(long)(_cotentmodel.share),kLocalizable(@"wallet_detail_signed")];
        }
    }else if(_model.status == 1){//未完成
        
        NSDictionary *userStatues = _model.user_status;
        NSArray *approve = [userStatues objectForKey:@"approve"];
        NSArray *reject = [userStatues objectForKey:@"reject"];
        
        if (_model.isMineCreateTrans) {
            if (approve.count == 0) {//outgoing
                self.typeLabel.text = kLocalizable(@"wallet_detail_OUTGOING");
                self.iconImageView.image = [UIImage imageNamed:@"home_wallet_waiting"];

                self.statueBackView.backgroundColor = lwColorRedLight;
                self.statueLabel.text = kLocalizable(@"wallet_detail_RECALL");
                self.statueDescribeLabel.text = kLocalizable(@"wallet_detail_untilyousigned");
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
                    self.typeLabel.text = kLocalizable(@"wallet_detail_OUTGOING");
                    self.iconImageView.image = [UIImage imageNamed:@"home_wallet_waiting"];

                    self.statueBackView.backgroundColor = lwColorRedLight;
                    self.statueLabel.text = kLocalizable(@"wallet_detail_RECALL");
                    self.statueDescribeLabel.text = kLocalizable(@"wallet_detail_untilyousigned");
       
                }else if(ismineSigned==1){
                
                    self.typeLabel.text = kLocalizable(@"common_Sent");
                    self.iconImageView.image = [UIImage imageNamed:@"home_wallet_send"];
                    self.statueBackView.backgroundColor = lwColorNormalDeep;
                    self.statueLabel.text = kLocalizable(@"wallet_detail_signed_uppercase");
                    self.statueDescribeLabel.text = [NSString stringWithFormat:@"%@ (%ld / %ld)",kLocalizable(@"wallet_detail_Awaitingothers"),(long)(_cotentmodel.threshold - approve.count),(long)(_cotentmodel.threshold)];
                    
                }else{//
                    self.iconImageView.image = [UIImage imageNamed:@"home_wallet_pending"];
                    self.typeLabel.text = kLocalizable(@"wallet_detail_PENDING");

                    self.statueBackView.backgroundColor = lwColorOrange;
                     self.statueLabel.text = kLocalizable(@"wallet_detail_unsigned_uppercase");
                     self.statueDescribeLabel.text = kLocalizable(@"wallet_detail_Awaitingyoutosign");
                }
                
            }
        }else{
            if (approve.count == 0) {//outgoing
                self.iconImageView.image = [UIImage imageNamed:@"home_wallet_pending"];

                 self.typeLabel.text = kLocalizable(@"wallet_detail_PENDING");
                 self.statueBackView.backgroundColor = lwColorOrange;
                 self.statueLabel.text = kLocalizable(@"wallet_detail_unsigned_uppercase");
                 self.statueDescribeLabel.text = kLocalizable(@"wallet_detail_Awaitingyoutosign");
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
                     self.statueLabel.text = kLocalizable(@"wallet_detail_signed_uppercase");
                     self.statueDescribeLabel.text = [NSString stringWithFormat:@"%@ (%ld / %ld)",kLocalizable(@"wallet_detail_Awaitingothers"),(long)(_cotentmodel.threshold - approve.count),(long)(_cotentmodel.threshold)];
                 }else{//
                     self.iconImageView.image = [UIImage imageNamed:@"home_wallet_pending"];

                     self.statueBackView.backgroundColor = lwColorOrange;
                      self.statueLabel.text = kLocalizable(@"wallet_detail_unsigned_uppercase");
                      self.statueDescribeLabel.text = kLocalizable(@"wallet_detail_Awaitingyoutosign");
                 }
                 
             }
        }

    }else{
        self.typeLabel.text = kLocalizable(@"common_cancel");
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
