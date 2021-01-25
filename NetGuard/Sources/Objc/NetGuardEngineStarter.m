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
    SEL implementNetfoxSelector = NSSelectorFromString(methodName);
    if ([NSURLSessionConfiguration respondsToSelector:implementNetfoxSelector]){
        [NSURLSessionConfiguration performSelector:implementNetfoxSelector];
    }
}
@end
