//
//  LivenessViewController.m
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "LivenessViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "libthresholdsig.h"
#import "LWAddressTool.h"
#import "LWLoginCoordinator.h"

@interface LivenessViewController ()
{
}
@property (nonatomic, strong) NSArray * livenessArray;
@property (nonatomic, assign) BOOL order;
@property (nonatomic, assign) NSInteger numberOfLiveness;

@end

@implementation LivenessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IDLFaceLivenessManager sharedInstance].enableSound = NO;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IDLFaceLivenessManager sharedInstance] startInitial];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)onAppBecomeActive {
    [super onAppBecomeActive];
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
}

- (void)onAppWillResignAction {
    [super onAppWillResignAction];
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness {
    _livenessArray = [NSArray arrayWithArray:livenessArray];
    _order = order;
    _numberOfLiveness = numberOfLiveness;
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:livenessArray order:order numberOfLiveness:numberOfLiveness];
}

- (void)faceProcesss:(UIImage *)image {
    if (self.hasFinished) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        
            __weak typeof(self) weakSelf = self;
            [[IDLFaceLivenessManager sharedInstance] livenessStratrgyWithImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(NSDictionary *images, LivenessRemindCode remindCode) {
                switch (remindCode) {
                    case LivenessRemindCodeOK: {
                        NSLog(@"remindOK");
                        weakSelf.hasFinished = YES;
                        [self warningStatus:CommonStatus warning:@"Good"];

                        if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
                            
                            NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                            UIImage* bestImage = [UIImage imageWithData:data];
                            NSLog(@"bestImage = %@",bestImage);
                            NSLog(@"face success");

                            [self verfiyImage:[images[@"bestImage"] lastObject] ];
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                               [WMHUDUntil showMessageToWindow:@"face verify fail,please try again"];
                                [self dismissViewControllerAnimated:YES completion:nil];
                            });
                        }
//                        if (images[@"liveEye"] != nil) {
//                            NSData* data = [[NSData alloc] initWithBase64EncodedString:images[@"liveEye"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                            UIImage* liveEye = [UIImage imageWithData:data];
//                            NSLog(@"liveEye = %@",liveEye);
//                            [imageArray addObj:liveEye];
//
//                        }
//                        if (images[@"liveMouth"] != nil) {
//                            NSData* data = [[NSData alloc] initWithBase64EncodedString:images[@"liveMouth"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                            UIImage* liveMouth = [UIImage imageWithData:data];
//                            NSLog(@"liveMouth = %@",liveMouth);
//                            [imageArray addObj:liveMouth];
//
//                        }
//                        if (images[@"yawRight"] != nil) {
//                            NSData* data = [[NSData alloc] initWithBase64EncodedString:images[@"yawRight"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                            UIImage* yawRight = [UIImage imageWithData:data];
//                            NSLog(@"yawRight = %@",yawRight);
//                            [imageArray addObj:yawRight];
//
//                        }
//                        if (images[@"yawLeft"] != nil) {
//                            NSData* data = [[NSData alloc] initWithBase64EncodedString:images[@"yawLeft"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                            UIImage* yawLeft = [UIImage imageWithData:data];
//                            NSLog(@"yawLeft = %@",yawLeft);
//                            [imageArray addObj:yawLeft];
//
//                        }
//                        if (images[@"pitchUp"] != nil) {
//                            NSData* data = [[NSData alloc] initWithBase64EncodedString:images[@"pitchUp"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                            UIImage* pitchUp = [UIImage imageWithData:data];
//                            NSLog(@"pitchUp = %@",pitchUp);
//                            [imageArray addObj:pitchUp];
//
//                        }
//                        if (images[@"pitchDown"] != nil) {
//                            NSData* data = [[NSData alloc] initWithBase64EncodedString:images[@"pitchDown"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                            UIImage* pitchDown = [UIImage imageWithData:data];
//                            NSLog(@"pitchDown = %@",pitchDown);
//                            [imageArray addObj:pitchDown];
//
//                        }

        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    [weakSelf closeAction];
        //                });
//                        self.circleView.conditionStatusFit = true;
//                        [self singleActionSuccess:true];
                        break;
                    }
                    case LivenessRemindCodePitchOutofDownRange:
                        [self warningStatus:PoseStatus warning:@"Suggested slightly higher" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodePitchOutofUpRange:
                        [self warningStatus:PoseStatus warning:@"Suggest bending slightly" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeYawOutofLeftRange:
                        [self warningStatus:PoseStatus warning:@"Turn your head slightly to the right" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeYawOutofRightRange:
                        [self warningStatus:PoseStatus warning:@"Suggest turning your head slightly to the left" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodePoorIllumination:
                        [self warningStatus:CommonStatus warning:@"The light is too dim" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeNoFaceDetected:
                        [self warningStatus:CommonStatus warning:@"Move the face into the frame" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeImageBlured:
                        [self warningStatus:CommonStatus warning:@"Please keep still" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeOcclusionLeftEye:
                        [self warningStatus:occlusionStatus warning:@"The left eye is shaded" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeOcclusionRightEye:
                        [self warningStatus:occlusionStatus warning:@"The right eye is shaded" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeOcclusionNose:
                        [self warningStatus:occlusionStatus warning:@"Nose covered" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeOcclusionMouth:
                        [self warningStatus:occlusionStatus warning:@"Mouth covered" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeOcclusionLeftContour:
                        [self warningStatus:occlusionStatus warning:@"The left cheek is shaded" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeOcclusionRightContour:
                        [self warningStatus:occlusionStatus warning:@"Her right cheek is shaded" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeOcclusionChinCoutour:
                        [self warningStatus:occlusionStatus warning:@"The chin is shaded" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeTooClose:
                        [self warningStatus:CommonStatus warning:@"Keep your phone away" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeTooFar:
                        [self warningStatus:CommonStatus warning:@"Hold your phone closer" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeBeyondPreviewFrame:
                        [self warningStatus:CommonStatus warning:@"Move the face into the frame" conditionMeet:false];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeLiveEye:
                        [self warningStatus:CommonStatus warning:@"Blink eyes" conditionMeet:true];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeLiveMouth:
                        [self warningStatus:CommonStatus warning:@"Open mouth" conditionMeet:true];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeLiveYawRight:
                        [self warningStatus:CommonStatus warning:@"Turn your head slowly to the right" conditionMeet:true];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeLiveYawLeft:
                        [self warningStatus:CommonStatus warning:@"Turn your head slowly to the left" conditionMeet:true];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeLivePitchUp:
                        [self warningStatus:CommonStatus warning:@"rise your head slowly" conditionMeet:true];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeLivePitchDown:
                        [self warningStatus:CommonStatus warning:@"lower your head slowly" conditionMeet:true];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeLiveYaw:
                        [self warningStatus:CommonStatus warning:@"shake your head" conditionMeet:true];
                        [self singleActionSuccess:false];
                        break;
                    case LivenessRemindCodeSingleLivenessFinished:
                    {
                        [self warningStatus:CommonStatus warning:@"Good" conditionMeet:true];
                        [self singleActionSuccess:true];
                    }
                        break;
                    
        //            case LivenessRemindCodePitchOutofDownRange:
        //                [self warningStatus:PoseStatus warning:@"建议略微抬头" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodePitchOutofUpRange:
        //                [self warningStatus:PoseStatus warning:@"建议略微低头" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeYawOutofLeftRange:
        //                [self warningStatus:PoseStatus warning:@"建议略微向右转头" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeYawOutofRightRange:
        //                [self warningStatus:PoseStatus warning:@"建议略微向左转头" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodePoorIllumination:
        //                [self warningStatus:CommonStatus warning:@"光线再亮些" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeNoFaceDetected:
        //                [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeImageBlured:
        //                [self warningStatus:CommonStatus warning:@"请保持不动" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeOcclusionLeftEye:
        //                [self warningStatus:occlusionStatus warning:@"左眼有遮挡" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeOcclusionRightEye:
        //                [self warningStatus:occlusionStatus warning:@"右眼有遮挡" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeOcclusionNose:
        //                [self warningStatus:occlusionStatus warning:@"鼻子有遮挡" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeOcclusionMouth:
        //                [self warningStatus:occlusionStatus warning:@"嘴巴有遮挡" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeOcclusionLeftContour:
        //                [self warningStatus:occlusionStatus warning:@"左脸颊有遮挡" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeOcclusionRightContour:
        //                [self warningStatus:occlusionStatus warning:@"右脸颊有遮挡" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeOcclusionChinCoutour:
        //                [self warningStatus:occlusionStatus warning:@"下颚有遮挡" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeTooClose:
        //                [self warningStatus:CommonStatus warning:@"手机拿远一点" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeTooFar:
        //                [self warningStatus:CommonStatus warning:@"手机拿近一点" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeBeyondPreviewFrame:
        //                [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeLiveEye:
        //                [self warningStatus:CommonStatus warning:@"眨眨眼" conditionMeet:true];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeLiveMouth:
        //                [self warningStatus:CommonStatus warning:@"张张嘴" conditionMeet:true];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeLiveYawRight:
        //                [self warningStatus:CommonStatus warning:@"向右缓慢转头" conditionMeet:true];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeLiveYawLeft:
        //                [self warningStatus:CommonStatus warning:@"向左缓慢转头" conditionMeet:true];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeLivePitchUp:
        //                [self warningStatus:CommonStatus warning:@"缓慢抬头" conditionMeet:true];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeLivePitchDown:
        //                [self warningStatus:CommonStatus warning:@"缓慢低头" conditionMeet:true];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeLiveYaw:
        //                [self warningStatus:CommonStatus warning:@"摇摇头" conditionMeet:true];
        //                [self singleActionSuccess:false];
        //                break;
        //            case LivenessRemindCodeSingleLivenessFinished:
        //            {
        //                [self warningStatus:CommonStatus warning:@"非常好" conditionMeet:true];
        //                [self singleActionSuccess:true];
        //            }
        //                break;
                    case LivenessRemindCodeVerifyInitError:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeVerifyDecryptError:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeVerifyInfoFormatError:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeVerifyExpired:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeVerifyMissRequiredInfo:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeVerifyInfoCheckError:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeVerifyLocalFileError:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeVerifyRemoteDataError:
                        [self warningStatus:CommonStatus warning:@"验证失败"];
                        break;
                    case LivenessRemindCodeTimeout: {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"remind" message:@"over time" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction* action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                NSLog(@"知道啦");
                            }];
                            [alert addAction:action];
                            UIViewController* fatherViewController = weakSelf.presentingViewController;
                            [weakSelf dismissViewControllerAnimated:YES completion:^{
                                [fatherViewController presentViewController:alert animated:YES completion:nil];
                            }];
                        });
                        break;
                    }
                    case LivenessRemindCodeConditionMeet: {
                        self.circleView.conditionStatusFit = true;
                    }
                        break;
                    default:
                        break;
                }
            }];
        });

}

- (void)verfiyImage:(NSString *)image{
    NSLog(@"startverfiyImage");
    [self.circleView setDetectCompelet:YES];
    [self processingStatue];

    NSString *token = [[LWUserManager shareInstance] getUserModel].login_token;
    NSString *imagedata = image;
    NSString *imagename = @"imageName.png";
    char *sig_data =  sign_data([LWAddressTool stringToChar:image]);
    NSString *imagesig = [LWAddressTool charToString:sig_data];

    [LWLoginCoordinator checkUserFaceWithParams:@{@"token":token,@"imgdata":imagedata,@"imgname":imagename,@"sig":imagesig} WithSuccessBlock:^(id  _Nonnull data) {

        if (self.livenessBlock) {
            self.livenessBlock([data objectForKey:@"face_token"]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];

    } WithFailBlock:^(id  _Nonnull data) {
        [WMHUDUntil showMessageToWindow:@"face verify fail"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (void)verifyFail{
    self.circleView.livenessFail = YES;
    self.circleView.livenessCompelet = NO;
    [self.circleView setNeedsDisplay];
    [self failStatue];
}

- (void)verifySuccss{
    self.circleView.livenessFail = NO;
    self.circleView.livenessCompelet = YES;
    [self.circleView setNeedsDisplay];
    [self completeSuccessStatue];

}

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning conditionMeet:(BOOL)meet
{
    [self warningStatus:status warning:warning];
    self.circleView.conditionStatusFit = meet;
}

- (void)dealloc
{
    
}
@end
