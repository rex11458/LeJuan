//
//  PYManagedQuestionnaire.m
//  
//
//  Created by LiuRex on 16/1/31.
//
//

#import "PYManagedQuestionnaire.h"
#import "PYManagedUser.h"
#import "PYTask.h"
@implementation PYManagedQuestionnaire

// Insert code here to add functionality to your managed object subclass

@end

@implementation PYTask (Conversion)

+ (NSArray<PYTask *> *)conversionFromSet:(NSSet<PYManagedQuestionnaire *> *)questionnaires
{
//    + (NSMutableArray *)mj_keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys;

    NSArray *jsonArray = [PYManagedQuestionnaire mj_keyValuesArrayWithObjectArray:[questionnaires allObjects]];
    NSArray *taskArray = [PYTask mj_objectArrayWithKeyValuesArray:jsonArray];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"objCode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];

   return [taskArray sortedArrayUsingDescriptors:sortDescriptors];
}

+ (PYTask *)conversionFromManagedQuestionnaire:(PYManagedQuestionnaire *)questionnaire
{
   return  [PYTask mj_objectWithKeyValues:[questionnaire mj_keyValues]];
}

@end


@implementation PYManagedQuestionnaire (Conversion)


+ (PYManagedQuestionnaire *)managedQuestionnaireWithTask:(PYTask *)task inContext:(NSManagedObjectContext *)context
{
    return [PYManagedQuestionnaire mj_objectWithKeyValues:[task mj_keyValues] context:context];
}

@end










