//
//  FaceBaseViewController.m
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "FaceBaseViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "VideoCaptureDevice.h"
#import "ImageUtils.h"
#import "RemindView.h"
#import "LWCommonBottomBtn.h"
#define scaleValue 0.8

#define ScreenRect [UIScreen mainScreen].bounds
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FaceBaseViewController () <CaptureDataOutputProtocol>
@property (nonatomic, readwrite, retain) VideoCaptureDevice *videoCapture;
@property (nonatomic, readwrite, retain) UILabel *remindLabel;
@property (nonatomic, readwrite, retain) RemindView * remindView;
@property (nonatomic, readwrite, retain) UILabel * remindDetailLabel;
@property (nonatomic, readwrite, retain) UIImageView * successImage;

@property (nonatomic, readwrite, retain) UILabel * processingStatueLabel;
@property (nonatomic, readwrite, retain) UILabel * processingContentLabel;
@property (nonatomic, readwrite, retain) UILabel * completeContentLabel;
@property (nonatomic, readwrite, retain) UILabel * completeContentLabel1;
@property (nonatomic, readwrite, retain) LWCommonBottomBtn * bottomBtn;

@end

@implementation FaceBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setHasFinished:(BOOL)hasFinished {
    _hasFinished = hasFinished;
    if (hasFinished) {
        [self.videoCapture stopSession];
        self.videoCapture.delegate = nil;
    }
}

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == PoseStatus) {
            [weakSelf.remindLabel setHidden:true];
       //     [weakSelf.remindView setHidden:false];
            [weakSelf.remindDetailLabel setHidden:false];
            weakSelf.remindDetailLabel.text = warning;
        }else if (status == occlusionStatus) {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:true];
            [weakSelf.remindDetailLabel setHidden:false];
            weakSelf.remindDetailLabel.text = warning;
            weakSelf.remindLabel.text = @"脸部有遮挡";
        }else {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:true];
            [weakSelf.remindDetailLabel setHidden:true];
            weakSelf.remindLabel.text = warning;
        }
    });
}

- (void)processingStatue{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.remindLabel setHidden:true];
        self.processingStatueLabel.hidden = NO;
        self.processingContentLabel.hidden = NO;
        self.circleView.detectCompelet = YES;
        self.completeContentLabel.hidden = YES;
         self.completeContentLabel1.hidden = YES;
        self.bottomBtn.hidden = YES;
    });
}

- (void)completeSuccessStatue{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.remindLabel setHidden:true];
        self.processingStatueLabel.hidden = NO;
        self.processingContentLabel.hidden = YES;
        self.completeContentLabel.hidden = NO;
        self.completeContentLabel1.hidden = NO;
        self.bottomBtn.hidden = NO;
        self.processingStatueLabel.text = @"Great, facial scan complete!";
        self.completeContentLabel.text = @"Your 3D facial map data has been securely stored and encrypted and is now linked to your Volt account. ";
        self.completeContentLabel1.text = @"It will not be shared with anyone and you are the owner of this 3D facial map data.";
        
        [self.bottomBtn setTitle:@"Create my Volt ID, Wallet and Account" forState:UIControlStateNormal];

    });
}

- (void)failStatue{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.remindLabel setHidden:true];
        self.processingStatueLabel.hidden = NO;
        self.processingContentLabel.hidden = YES;
        self.completeContentLabel.hidden = NO;
          self.completeContentLabel1.hidden = NO;
        self.bottomBtn.hidden = NO;

          self.processingStatueLabel.text = @"Sorry, your facial scan failed";
          self.completeContentLabel.text = @"";
          self.completeContentLabel1.text = @"Ensure you’re in a well lit room, are standing in front of a solid color background and try again";
        [self.bottomBtn setTitle:@"Restart facial recognition scan" forState:UIControlStateNormal];

    });
}

- (void)reFace{
    dispatch_async(dispatch_get_main_queue(), ^{
           [self.remindLabel setHidden:true];
           self.processingStatueLabel.hidden = YES;
           self.processingContentLabel.hidden = YES;
           self.completeContentLabel.hidden = YES;
             self.completeContentLabel1.hidden = YES;
        self.bottomBtn.hidden = YES;
        self->_hasFinished = NO;
       });
}

- (void)singleActionSuccess:(BOOL)success
{
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (success) {
//            [weakSelf.successImage setHidden:false];
//        }else {
//            [weakSelf.successImage setHidden:true];
//        }
//    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化相机处理类
    self.videoCapture = [[VideoCaptureDevice alloc] init];
    self.videoCapture.delegate = self;
    
    // 用于播放视频流
    self.detectRect = CGRectMake(ScreenWidth*(1-scaleValue)/2.0, ScreenHeight*(1-scaleValue)/2.0 - 20, ScreenWidth*scaleValue, ScreenHeight*scaleValue);
    self.displayImageView = [[UIImageView alloc] initWithFrame:self.detectRect];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.displayImageView];
    
    self.coverImage = [ImageUtils getImageResourceForName:@"facecover"];
    CGRect circleRect = [ImageUtils convertRectFrom:CGRectMake(125, 304, 500, 500) imageSize:self.coverImage.size detectRect:ScreenRect];
    self.previewRect = CGRectMake(circleRect.origin.x - circleRect.size.width*(1/scaleValue-1)/2.0, circleRect.origin.y - circleRect.size.height*(1/scaleValue-1)/2.0 - 60, circleRect.size.width/scaleValue, circleRect.size.height/scaleValue);
  
    // 遮罩
    UIImageView* coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight)];
    coverImageView.image = [ImageUtils getImageResourceForName:@"facecover"];
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:coverImageView];
    
    //画圈
    self.circleView = [[CircleView alloc] initWithFrame:ScreenRect];
    self.circleView.circleRect = circleRect;
    [self.view addSubview:self.circleView];

    //successImage
    self.successImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(circleRect)+CGRectGetWidth(circleRect)/2.0-57/2.0, CGRectGetMinY(circleRect)-57/2.0, 57, 57)];
    self.successImage.image = [ImageUtils getImageResourceForName:@"success"];
//    [self.view addSubview:self.successImage];
    [self.successImage setHidden:true];
    
    // 关闭
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[ImageUtils getImageResourceForName:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(20, 30, 30, 30);
    [self.view addSubview:closeButton];
    
    self.processingStatueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight*(1-scaleValue)/2.0 + 20, kScreenWidth, 30)];
    self.processingStatueLabel.textColor = lwColorBlack;
    self.processingStatueLabel.font = kBoldFont(22);
    self.processingStatueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.processingStatueLabel];
    self.processingStatueLabel.text = @"We’re processing your data";
    self.processingStatueLabel.hidden = YES;
    
    self.processingContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight/2+105, ScreenWidth - 40, 30)];
     self.processingContentLabel.textColor = lwColorBlack;
    self.processingContentLabel.numberOfLines = 0;
     self.processingContentLabel.font = kFont(16);
     self.processingContentLabel.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:self.processingContentLabel];
     self.processingContentLabel.text = @"Please wait while we confirm your 3D facial map data meets the requirements and is stored securely.";
    [self.processingContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(ScreenHeight/2+105);
    }];
    self.processingContentLabel.hidden = YES;

    self.completeContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight/2+105, ScreenWidth - 40, 30)];
     self.completeContentLabel.textColor = lwColorBlack;
    self.completeContentLabel.numberOfLines = 0;
     self.completeContentLabel.font = kMediumFont(16);
     self.completeContentLabel.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:self.completeContentLabel];
     self.completeContentLabel.text = @"Your 3D facial map data has been securely stored and encrypted and is now linked to your Volt account.";
    [self.completeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(ScreenHeight/2+105);
    }];
    self.completeContentLabel.hidden = YES;

    
    self.completeContentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight/2+105, ScreenWidth - 40, 30)];
     self.completeContentLabel1.textColor = lwColorBlack;
    self.completeContentLabel1.numberOfLines = 0;
     self.completeContentLabel1.font = kFont(16);
     self.completeContentLabel1.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:self.completeContentLabel1];
     self.completeContentLabel1.text = @"It will not be shared with anyone and you are the owner of this 3D facial map data.";
    [self.completeContentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.completeContentLabel.mas_bottom).offset(10);
    }];
    self.completeContentLabel1.hidden = YES;

    self.bottomBtn = [[LWCommonBottomBtn alloc] init];
    self.bottomBtn.selected = YES;
    [self.bottomBtn setTitle:@"Create my Volt ID, Wallet and Account" forState:UIControlStateNormal];
    self.bottomBtn.layer.cornerRadius = 25;
    [self.bottomBtn.titleLabel setFont:kFont(14)];
    self.bottomBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.completeContentLabel1.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    self.bottomBtn.hidden = YES;

    // 提示框
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight/2+105, ScreenWidth, 30)];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.textColor = lwColorBlack;
    self.remindLabel.font = kMediumFont(18);
    [self.view addSubview:self.remindLabel];
    
    self.remindView = [[RemindView alloc]initWithFrame:CGRectMake((ScreenWidth-200)/2.0, CGRectGetMinY(self.remindLabel.frame), 200, 45)];
    [self.view addSubview:self.remindView];
    [self.remindView setHidden:YES];
    
    self.remindDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight/2+135, ScreenWidth, 30)];
    self.remindDetailLabel.font = [UIFont systemFontOfSize:18.0];
    self.remindDetailLabel.textColor = lwColorBlack;
    self.remindDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.remindDetailLabel.text = @"建议略微抬头";
    [self.view addSubview:self.remindDetailLabel];
    [self.remindDetailLabel setHidden:true];
    
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:200];
    
    // 设置截取人脸图片大小
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:400];
    
    // 设置人脸遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluThreshold:0.5];
    
    // 设置亮度阀值
    [[FaceSDKManager sharedInstance] setIllumThreshold:40];
    
    // 设置图像模糊阀值
    [[FaceSDKManager sharedInstance] setBlurThreshold:0.7];
    
    // 设置头部姿态角度
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:10 yaw:10 roll:10];
    
    // 设置是否进行人脸图片质量检测
    [[FaceSDKManager sharedInstance] setIsCheckQuality:YES];
    
    // 设置超时时间
    [[FaceSDKManager sharedInstance] setConditionTimeout:10];
    
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:0.6];
    
    // 设置照片采集张数
    [[FaceSDKManager sharedInstance] setMaxCropImageNum:1];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hasFinished = YES;
    self.videoCapture.runningStatus = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasFinished = NO;
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)faceProcesss:(UIImage *)image {
}


- (void)closeAction {
    _hasFinished = YES;
    self.videoCapture.runningStatus = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)restartAction{
    [self.videoCapture resetSession];
}

#pragma mark - Notification

- (void)onAppWillResignAction {
    _hasFinished = YES;
}

- (void)onAppBecomeActive {
    _hasFinished = NO;
}

#pragma mark - CaptureDataOutputProtocol

- (void)captureOutputSampleBuffer:(UIImage *)image {
    if (_hasFinished) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.displayImageView.image = image;
    });
    [self faceProcesss:image];
}

- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        [alert addAction:action];
        UIViewController* fatherViewController = weakSelf.presentingViewController;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [fatherViewController presentViewController:alert animated:YES completion:nil];
        }];
    });
}
@end
