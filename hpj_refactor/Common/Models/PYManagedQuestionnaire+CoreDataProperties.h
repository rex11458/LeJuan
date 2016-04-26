//
//  PYManagedQuestionnaire+CoreDataProperties.h
//  
//
//  Created by LiuRex on 16/1/31.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PYManagedQuestionnaire.h"
@class PYManagedQuestion;
NS_ASSUME_NONNULL_BEGIN

@interface PYManagedQuestionnaire (CoreDataProperties)<PYQuestionnaireProtocol>

@property (nullable, nonatomic, retain) PYManagedUser *user;

@property (nullable, nonatomic, retain) NSSet<PYManagedQuestion *> *questions;


@end

@interface PYManagedQuestionnaire (CoreDataGeneratedAccessors)

- (void)addQuestions:(NSSet<PYManagedQuestion *> *)objects;
- (void)addQuestionsObject:(PYManagedQuestion *)object;
- (void)removeQuestions:(NSSet<PYManagedQuestion *> *)objects;
- (void)removeQuestionsObject:(PYManagedQuestion *)object;
- (void)removeQuestionsAtIndexes:(NSIndexSet *)indexes;

@end


NS_ASSUME_NONNULL_END

