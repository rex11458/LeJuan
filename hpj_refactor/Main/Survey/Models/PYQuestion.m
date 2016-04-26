//
//  PYQuestion.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/3.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYQuestion.h"

@implementation PYQuestion

@synthesize questionId;
@synthesize answerId;
@synthesize subQuestionId;
@synthesize remark;
static const char PYQuestionResultKey = '\0';


- (void)setResult:(NSString *)result
{
#warning -- 在回填数据的时候将图片名改为图片绝对路径
    if (![result hasPrefix:DocumentDir] && [result hasSuffix:@"PNG"])
    {
        result = [PYPictureSadboxPath stringByAppendingPathComponent:result];
        
    }
    objc_setAssociatedObject(self, &PYQuestionResultKey,
                             result, OBJC_ASSOCIATION_COPY);
}

- (NSString *)result
{
    return objc_getAssociatedObject(self, &PYQuestionResultKey);
}

- (BOOL)isImage
{
    if ( [self.result hasSuffix:@"PNG"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (int)imageCountFromArray:(NSArray<PYQuestion *> *)questions
{
   __block int count = 0;
    
    [questions enumerateObjectsUsingBlock:^(PYQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isImage) {
            count++;
        }
    }];
    
    
    return count;
}

@end
