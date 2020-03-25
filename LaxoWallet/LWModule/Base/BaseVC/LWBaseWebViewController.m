//
//  LWBaseWebViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/25.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWBaseWebViewController.h"
#import "IMYWebView.h"
@interface LWBaseWebViewController ()

@property(strong,nonatomic)IMYWebView* webView;

@end

@implementation LWBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[IMYWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
       
   [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    // Do any additional setup after loading the view.
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
