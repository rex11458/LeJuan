//
//  PYManagedUser.h
//  
//
//  Created by LiuRex on 16/1/31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PYQuestionnaireManager.h"
#import "PYUserProtocol.h"
@class PYManagedQuestionnaire;

NS_ASSUME_NONNULL_BEGIN

@interface PYManagedUser : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END


@interface PYManagedUser (Conversion)

+ (PYManagedUser *)managerUserWithLoginUser:(PYLoginUser *)user inContext:(NSManagedObjectContext *)context;
@end

@interface PYQuestionnaireManager (InsertUser)

- (void)insertManagerUser:(PYLoginUser *)user inContext:(NSManagedObjectContext *)context;

@end


@interface PYLoginUser (Conversion)

+ (PYLoginUser *)conversionFromManagedUser:(PYManagedUser *)user;


@end


#import "PYManagedUser+CoreDataProperties.h"
