//
//  NetGuardEngineStarter.m
//  NetGuard
//
//  Created by Batıkan SOSUN on 25.01.2021.
//

#import "NetGuardEngineStarter.h"

@implementation NetGuardEngineStarter
+ (void)load{
    NSString *methodName = @"netGuardEngineStarter";
    SEL implementNetGuardSelector = NSSelectorFromString(methodName);
    if ([NSURLSessionConfiguration respondsToSelector:implementNetGuardSelector]){
        [NSURLSessionConfiguration performSelector:implementNetGuardSelector];
    }
}
@end
