//
//  PYManagedUser+CoreDataProperties.h
//  
//
//  Created by LiuRex on 16/1/31.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PYManagedUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYManagedUser (CoreDataProperties)<PYUserProtocol>

@property (nullable, nonatomic, retain) NSSet<PYManagedQuestionnaire *> *questionnaires;


@end

@interface PYManagedUser (CoreDataGeneratedAccessors)

- (void)addQuestionnaires:(NSSet<PYManagedQuestionnaire *> *)objects;
- (void)addQuestionnairesObject:(PYManagedQuestionnaire *)object;
- (void)removeQuestionnaires:(NSSet<PYManagedQuestionnaire *> *)objects;
- (void)removeQuestionnairesObject:(PYManagedQuestionnaire *)object;

@end

NS_ASSUME_NONNULL_END
