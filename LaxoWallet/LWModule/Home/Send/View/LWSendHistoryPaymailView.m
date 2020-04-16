//
//  LWSendHistoryPaymailView.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/22.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWSendHistoryPaymailView.h"
#import "LWHistoryPaymailCell.h"
#import "LWHistoryPaymailModel.h"


@implementation LWSendHistoryPaymailView{

}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self setRefreshHeaderAndFooterNeeded:NO];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib1 = [UINib nibWithNibName:@"LWHistoryPaymailCell" bundle: nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"LWHistoryPaymailCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:kHistoryPaymail_userdefault];
    if (historyArray && historyArray.count >0) {
        for (NSInteger i = 0; i< historyArray.count; i++) {
            LWHistoryPaymailModel *model = [LWHistoryPaymailModel modelWithJSON:historyArray[i]];
            if(!model.paymail || [model.paymail isEqualToString:@""]){
                continue;
            }
            [self.dataSource addObj:model];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - uitableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSource.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWHistoryPaymailModel *messageModel = [self.dataSource objectAtIndex:indexPath.row];
    LWHistoryPaymailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWHistoryPaymailCell"];
    cell.model = messageModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.00001)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (NSInteger i = 0; i<self.dataSource.count; i++) {
        LWHistoryPaymailModel  *model = [self.dataSource objectAtIndex:i];
        if (i == indexPath.row) {
            model.isSelect = YES;
            if (self.block) {
                self.block(model.paymail);
            }
        }else{
            model.isSelect = NO;
        }
    }
    [self.tableView reloadData];

}

- (void)addpayMail:(NSString *)paymail{
    
    for (NSInteger i = 0; i<self.dataSource.count; i++) {
        LWHistoryPaymailModel *model = [self.dataSource objectAtIndex:i];
        if ([model.paymail isEqualToString:paymail]) {
            return;
        }
    }
    
    LWHistoryPaymailModel *model = [[LWHistoryPaymailModel alloc] init];
    model.paymail = paymail;
    model.isSelect = YES;
    [self.dataSource insertObject:model atIndex:0];
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSInteger i = 0; i< self.dataSource.count;i++){
        LWHistoryPaymailModel *model = [self.dataSource objectAtIndex:i];
        model.isSelect = NO;
        NSString *jsonString = [model modelToJSONString];
        [array addObj:jsonString];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kHistoryPaymail_userdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
