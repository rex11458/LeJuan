//
//  PYManagedQuestion.h
//  
//
//  Created by LiuRex on 16/2/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PYQuestion.h"
@class PYManagedQuestionnaire;

NS_ASSUME_NONNULL_BEGIN

@interface PYManagedQuestion : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

@interface PYManagedQuestion (JSON)

+ (NSArray<NSDictionary *> *)jsonArrayWithQuestions:(NSSet<PYManagedQuestion *> *)questions;

+ (NSArray<PYManagedQuestion *> *)questionWithKeyValues:(NSArray<NSDictionary *> *)keyValues context:(nonnull NSManagedObjectContext *)context;

@end


@interface PYQuestion (Conversion)

+ (NSArray<PYQuestion *> *)conversionFromSet:(NSSet<PYManagedQuestion *> *)questionnaires;

+ (PYQuestion *)conversionFromManagedQuestionnaire:(PYManagedQuestion *)questionnaire;

@end



NS_ASSUME_NONNULL_END

#import "PYManagedQuestion+CoreDataProperties.h"
