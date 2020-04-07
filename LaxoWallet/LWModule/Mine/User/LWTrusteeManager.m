//
//  LWTrusteeManager.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/2/9.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWTrusteeManager.h"

static NSString * const kTrusteeInfo_key = @"kTrusteeInfo_key";
static NSString * const kTrusteerInfo_File_Name = @"kTrusteeInfo.data";

@interface LWTrusteeManager ()<NSCoding>

@property (nonatomic, strong) NSArray *trusteeArr;

@end


@implementation LWTrusteeManager

static LWTrusteeManager *instance = nil;
+ (LWTrusteeManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LWTrusteeManager alloc]init];
    });
    return instance;
}


- (void)trusteeInfoArchieve:(NSArray *)model{
    [self clearTrustee];
    self.trusteeArr = model;
    NSString *path = [[self class] obtainDeviceDataPath];

    if(@available(iOS 11,*)){
        NSData *archiverdata = [NSKeyedArchiver archivedDataWithRootObject:self.trusteeArr requiringSecureCoding:NO error:nil];
        [archiverdata writeToFile:path atomically:YES];
    }else{
        [NSKeyedArchiver archiveRootObject:self.trusteeArr toFile:path];
    }
}

- (NSArray *)trusteeInfoUnArchieve{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[[self class] obtainDeviceDataPath]];
    NSArray *model = [NSKeyedUnarchiver unarchiveObjectWithData:data exception:nil];
    return model;
}

/**
 path
 @return data path
 */
+ (NSString *)obtainDeviceDataPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *deviceDataPath = [path stringByAppendingPathComponent:kTrusteerInfo_File_Name];
    return deviceDataPath;
}

- (void)setTrustee:(NSArray *)trusteeArray{
    [self trusteeInfoArchieve:trusteeArray];
}

- (void)clearTrustee{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[[self class] obtainDeviceDataPath]]) {
        [defaultManager removeItemAtPath:[[self class] obtainDeviceDataPath] error:nil];
    }
}

- (LWTrusteeModel *)getFirstModel{
    NSArray *trusteeArr = [self getTrusteeArray];
    if (trusteeArr.count>0) {
        return trusteeArr.firstObject;
    }
    return nil;
}

- (NSArray<LWTrusteeModel *> *)getTrusteeArray{
    NSArray *trusteeArr = [self trusteeInfoUnArchieve];
    
    NSMutableArray *trusteeArrMut = [NSMutableArray array];
    NSArray *trusthold = [[LWUserManager shareInstance] getUserModel].trusthold;
    if (trusthold && trusthold.count > 0) {
        for (NSInteger i = 0; i<trusteeArr.count; i++) {
            NSDictionary *trustholdItem = trusteeArr[i];
            
            for (NSInteger j = 0; j<trusthold.count; j++) {
                NSString *trustholdItemId = [trustholdItem objectForKey:@"id"];
                if (trustholdItemId.integerValue == [trusthold[j] integerValue]){
                    [trusteeArrMut addObj:trustholdItem];
                    break;
                }
            }
        }
        return [NSArray modelArrayWithClass:[LWTrusteeModel class] json:trusteeArrMut];
    }else{
        return [NSArray modelArrayWithClass:[LWTrusteeModel class] json:trusteeArr];
    }

}

@end
