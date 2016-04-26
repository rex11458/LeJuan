//
//  PYManagedUser.m
//  
//
//  Created by LiuRex on 16/1/31.
//
//

#import "PYManagedUser.h"
#import "PYManagedQuestionnaire.h"
#import "PYLoginUserManager.h"
@implementation PYManagedUser

// Insert code here to add functionality to your managed object subclass


@end

@implementation PYManagedUser (Conversion)


+ (PYManagedUser *)managerUserWithLoginUser:(PYLoginUser *)user inContext:(NSManagedObjectContext *)context
{
    return [PYManagedUser mj_objectWithKeyValues:[user mj_keyValues] context:context];
}

@end

@implementation PYQuestionnaireManager (InsertUser)

- (void)insertManagerUser:(PYLoginUser *)user inContext:(NSManagedObjectContext *)context
{
    [PYManagedUser managerUserWithLoginUser:user inContext:context];
}

@end

@implementation PYLoginUser (Conversion)

+ (PYLoginUser *)conversionFromManagedUser:(PYManagedUser *)user
{
    return  [PYLoginUser mj_objectWithKeyValues:[user mj_keyValues]];
}

@end