//
//  LWEmailTool.m
//  LaxoWallet
//
//  Created by walkermuzhou on 2020/3/23.
//  Copyright © 2020 LaxoWallet. All rights reserved.
//

#import "LWEmailTool.h"

@implementation LWEmailTool

+ (BOOL)isEmail:(NSString*)email{
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSArray *)isInputMutipyEmail:(NSString *)emailStr{
    //1判断空格
    emailStr = [emailStr stringByReplacingOccurrencesOfString:@" " withString:@","];
    emailStr = [emailStr stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    NSArray *emailArray = [emailStr componentsSeparatedByString:@","];
    
    NSMutableArray *mutalEmailArray = [NSMutableArray array];
    if (emailArray.count > 1) {
        for (NSInteger i = 0; i<emailArray.count; i++) {
            NSString *objecti = [emailArray objectAtIndex:i];
            if (objecti && ![objecti isEqualToString:@""]) {
                [mutalEmailArray addObj:objecti];
            }
        }
    }
    if (mutalEmailArray.count == 0) {
        return emailArray;
    }
    
    return mutalEmailArray;
}
@end
