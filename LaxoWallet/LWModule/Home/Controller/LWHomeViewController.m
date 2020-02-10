//
//  LWHomeViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/5.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWHomeViewController.h"
#import "LWHomeListView.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface LWHomeViewController ()

@end

@implementation LWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    // Do any additional setup after loading the view.
    [self returnDesValueWithStr];
}

- (void)createUI{
    LWHomeListView *listView = [[LWHomeListView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:listView];
}

-(NSString*)returnDesValueWithStr
{
    NSString *calcPath = [[NSBundle mainBundle] pathForResource:@"turbo" ofType:@"js"];

    NSString *calcJS= [NSString stringWithContentsOfFile:calcPath encoding:NSUTF8StringEncoding error:nil];

    JSContext *context = [JSContext new];

    [context evaluateScript:calcJS];

    JSValue *value = [context evaluateScript:@"getPublicKey()"];//js的调用方法
    NSLog(@"jsreturn:%@",value.toString);
        return value.toString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
