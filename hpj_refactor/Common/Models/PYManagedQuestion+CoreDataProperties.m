//
//  PYManagedQuestion+CoreDataProperties.m
//  
//
//  Created by LiuRex on 16/2/3.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PYManagedQuestion+CoreDataProperties.h"
#import "PYManagedQuestionnaire.h"
@implementation PYManagedQuestion (CoreDataProperties)

@dynamic questionId;
@dynamic answerId;
@dynamic subQuestionId;
@dynamic result;
@dynamic questionnaire;
@dynamic remark;

@end
