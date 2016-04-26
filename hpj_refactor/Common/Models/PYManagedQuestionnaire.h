//
//  PYManagedQuestionnaire.h
//  
//
//  Created by LiuRex on 16/1/31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PYQuestionnaireManager.h"
#import "PYTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYManagedQuestionnaire : NSManagedObject

// Insert code here to declare functionality of your managed object subclass


@end

NS_ASSUME_NONNULL_END


@interface PYTask (Conversion)

+ (NSArray<PYTask *> *)conversionFromSet:(NSSet<PYManagedQuestionnaire *> *)questionnaires;

+ (PYTask *)conversionFromManagedQuestionnaire:(PYManagedQuestionnaire *)questionnaire;

@end


@interface PYManagedQuestionnaire (Conversion)

+ (PYManagedQuestionnaire *)managedQuestionnaireWithTask:(PYTask *)task inContext:(NSManagedObjectContext *)context;

@end



#import "PYManagedQuestionnaire+CoreDataProperties.h"


