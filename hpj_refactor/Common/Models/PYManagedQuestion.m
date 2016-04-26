//
//  PYManagedQuestion.m
//  
//
//  Created by LiuRex on 16/2/3.
//
//

#import "PYManagedQuestion.h"
#import "PYManagedQuestionnaire.h"

@implementation PYManagedQuestion

// Insert code here to add functionality to your managed object subclass
- (void)setValue:(id)value forKey:(NSString *)key
{
#warning -- iOS 8 以后app在每次启动运行的时候沙盒目录会改变，所以数据库只存图片名
    if ([key isEqualToString:@"result"] && [value hasPrefix:@"/"] && [value hasSuffix:@"PNG"])
    {
        value = [value lastPathComponent];
    }
    
    [super setValue:value forKey:key];
}


@end

@implementation PYManagedQuestion (JSON)

+ (NSArray *)jsonArrayWithQuestions:(NSSet<PYManagedQuestion *> *)questions
{
    return [self mj_keyValuesArrayWithObjectArray:[questions allObjects]];
}

+ (NSArray<PYManagedQuestion *> *)questionWithKeyValues:(NSArray<NSDictionary *> *)keyValues context:(nonnull NSManagedObjectContext *)context
{
    return [self mj_objectArrayWithKeyValuesArray:keyValues context:context];
}

@end

@implementation PYQuestion (Conversion)

+ (NSArray<PYQuestion *> *)conversionFromSet:(NSSet<PYManagedQuestion *> *)questionnaires
{
    NSArray *jsonArray = [PYManagedQuestion jsonArrayWithQuestions:questionnaires];
    
    return  [PYQuestion mj_objectArrayWithKeyValuesArray:jsonArray];
}

+ (PYQuestion *)conversionFromManagedQuestionnaire:(PYManagedQuestion *)questionnaire
{
   return [PYQuestion mj_objectWithKeyValues:[questionnaire mj_keyValues]];
}

@end
