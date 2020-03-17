//
//  LWUserVefifyViewController.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/9.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWUserVefifyViewController.h"

#import "LivenessViewController.h"
#import "DetectionViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "LWCommonBottomBtn.h"

@interface LWUserVefifyViewController ()

@end

@implementation LWUserVefifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI{

    LWCommonBottomBtn *bottom1 = [[LWCommonBottomBtn alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 50)];
    [bottom1 setBackgroundColor:lwColorNormal];
    [bottom1 setTitle:@"采集人脸" forState:UIControlStateNormal];
    [bottom1 addTarget:self action:@selector(bottom1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom1];
    
    
    LWCommonBottomBtn *bottom2 = [[LWCommonBottomBtn alloc] initWithFrame:CGRectMake(0, 250, kScreenWidth, 50)];
    [bottom2 setBackgroundColor:lwColorNormal];
    [bottom2 setTitle:@"活体检测" forState:UIControlStateNormal];
    [bottom2 addTarget:self action:@selector(bottom2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom2];
}

- (void)bottom1Click{
    if ([[FaceSDKManager sharedInstance] canWork]) {
         NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
         [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
     }
     
     DetectionViewController* dvc = [[DetectionViewController alloc] init];
     dvc.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:dvc animated:YES completion:nil];
    
    dvc.successBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [dvc dismissViewControllerAnimated:YES completion:nil];
            [self bottom2Click];
        });
    };
}

- (void)bottom2Click{
     if ([[FaceSDKManager sharedInstance] canWork]) {
         NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
         [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
     }
     LivenessViewController* lvc = [[LivenessViewController alloc] init];
     LivingConfigModel* model = [LivingConfigModel sharedInstance];
     [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
//     UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
//     navi.navigationBarHidden = true;
    lvc.modalPresentationStyle = UIModalPresentationFullScreen;

     [self presentViewController:lvc animated:YES completion:nil];
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
