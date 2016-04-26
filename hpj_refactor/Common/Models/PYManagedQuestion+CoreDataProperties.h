//
//  PYManagedQuestion+CoreDataProperties.h
//  
//
//  Created by LiuRex on 16/2/3.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PYManagedQuestion.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYManagedQuestion (CoreDataProperties)<PYQuestionProtocol>


@property (nullable, nonatomic, retain) PYManagedQuestionnaire *questionnaire;

@end

NS_ASSUME_NONNULL_END
