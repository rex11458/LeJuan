//
//  NSObject+Swizzling.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/1.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "NSObject+Swizzling.h"

@implementation NSObject (Swizzling)


+ (void)py_swizzleClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector
{
    py_swizzleClassMethod([self class], originalSelector, [self class], replacementSelector);
}
+ (void)py_swizzleInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector
{
    py_swizzleInstanceMethod([self class], originalSelector, [self class], replacementSelector);
}

void py_swizzleClassMethod(Class cls1,SEL originalSelector,Class cls2 ,SEL replacementSelector)
{
    Method originalMethod = class_getClassMethod(cls1, originalSelector);
    Method replacementMethod = class_getClassMethod(cls2, replacementSelector);
    method_exchangeImplementations(replacementMethod, originalMethod);
}

void py_swizzleInstanceMethod(Class cls1,SEL originalSelector,Class cls2 ,SEL replacementSelector)
{
    Method originalMethod = class_getInstanceMethod(cls1, originalSelector);
    Method replacementMethod = class_getInstanceMethod(cls2, replacementSelector);
    method_exchangeImplementations(replacementMethod, originalMethod);
}

@end
