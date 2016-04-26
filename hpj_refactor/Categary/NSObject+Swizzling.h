//
//  NSObject+Swizzling.h
//  hpj_refactor
//
//  Created by LiuRex on 16/2/1.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)py_swizzleClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector;
+ (void)py_swizzleInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector;

void py_swizzleClassMethod(Class cls1,SEL method,Class cls2 ,SEL replacementMethod);
void py_swizzleInstanceMethod(Class cls1,SEL method,Class cls2 ,SEL replacementMethod);


@end
