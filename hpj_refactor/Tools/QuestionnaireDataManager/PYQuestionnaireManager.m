//
//  PYQuestionnaireManager.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYQuestionnaireManager.h"
#import "PYLoginUserManager.h"
#import "PYManagedUser.h"
#import "PYManagedQuestionnaire.h"
#import "PYManagedQuestion.h"
#import "PYHistoryRecord.h"
static id shared = nil;

@implementation PYQuestionnaireManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (instancetype)alloc
{
    @synchronized(self)
    {
        if (shared == nil)
        {
            shared = [super alloc];
            return shared;
        }
    }
    return nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        //创建数据库
        [self createDB];

    }
    return self;
}

- (void)createDB
{
    //1.实例化数据模型
    NSManagedObjectModel *objectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //2.实例化持久化存储调度
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
    
    //建立数据库保存在沙盒的URL
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"PYQuestionnaire.sqlite"]];
    
    // 3 打开或者新建数据库文件
    //   如果文件不存在，则新建之后打开
    //   否者直接打开数据库
    NSError *error  = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
    //
    if (error) {
        NSLog(@"打开数据库出错--%@",error.localizedDescription);
    }else{
        NSLog(@"打开数据库成功--%@",docs);
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
}

//初始化Core Data使用的数据库
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"PYQuestionnaire.sqlite"]];
    NSError *error  = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error])
    {
        NSLog(@"Error:%@ %@",error,[error description]);
    }
    
    return _persistentStoreCoordinator;
}

//查找所有用户
- (NSArray *)getAllUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PYManagedUser class])];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"loginName" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    return [self.managedObjectContext executeFetchRequest:request error:nil];
}

/*
 *添加用户
 */
- (void)insertUser:(PYLoginUser *)user
{
    //判断用户是否已经存在
    if ([self selectUserWithLoginName:user.loginName] != nil)
    {
        
        return;
    }
    [self insertManagerUser:user inContext:self.managedObjectContext];
     NSError *error = nil;
    [self.managedObjectContext save:&error];
}


/*
 *删除用户
 */
- (void)deleteUserWithLoginName:(NSString *)loginName
{
    PYManagedUser *user = [self selectUserWithLoginName:loginName];
    
    [self.managedObjectContext deleteObject:user];
}

/*
 * 修改用户
 */
- (void)alterUserWithLoginName:(NSString *)loginName newUser:(PYLoginUser *)user;
{
    PYManagedUser *m_usr = [self selectUserWithLoginName:loginName];
    m_usr.userCity = user.userCity;
    m_usr.userRealname = user.userRealname;
    m_usr.userPhoneNumber = user.userPhoneNumber;
    [self.managedObjectContext save:nil];
}

/*
 *根据loginName查找指定用户
 */
- (PYManagedUser *)selectUserWithLoginName:(NSString *)loginName
{
    if (loginName == nil) return nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PYManagedUser class])];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"loginName=%@", loginName];
    request.predicate = predicate;
    

    
    return [[self.managedObjectContext executeFetchRequest:request error:NULL] firstObject];
}

/*
 * 为指定用户添加问卷
 */
- (void)insertQuestionnaire:(PYTask *)task relationloginName:(NSString *)loginName;
{
    PYManagedUser *user = [self selectUserWithLoginName:loginName];
    PYManagedQuestionnaire *questionnaire = [PYManagedQuestionnaire managedQuestionnaireWithTask:task inContext:self.managedObjectContext];
    
    questionnaire.user = user;
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}


/*
 *删除指定用户的问卷
 */
- (void)deleteQuestaionnaire:(PYTask *)task relationLoginName:(NSString *)loginName
{
    
#warning --删除问卷时，要将问卷对应的qusiton表删除，（将沙盒下对应的图片和html页面删除，后续处理）
    
    PYManagedQuestionnaire *questionnaire = [self selectQuestionnaireWithId:task.resultId relationLoginName:loginName];

    [questionnaire.questions enumerateObjectsUsingBlock:^(PYManagedQuestion * _Nonnull obj, BOOL * _Nonnull stop) {
    
        [self.managedObjectContext deleteObject:obj];

    }];
    
    [questionnaire removeQuestions:questionnaire.questions];
    
    [questionnaire.user removeQuestionnairesObject:questionnaire];

    [self.managedObjectContext deleteObject:questionnaire];
    
    [self.managedObjectContext save:nil];
}

/*
 *  修改指定用户问卷信息
 */
- (void)alertQuestionnaire:(PYTask *)task relationLoginName:(NSString *)loginName
{
    PYManagedQuestionnaire *questionnaire = [self selectQuestionnaireWithId:task.resultId relationLoginName:loginName];
    questionnaire.isArrival = task.isArrival;
    questionnaire.isDeparture = task.isDeparture;
    questionnaire.arrivalTime = task.arrivalTime;
    questionnaire.departureTime = task.departureTime;
    questionnaire.progress = task.progress;
    questionnaire.leaveRemark = task.leaveRemark;
    
    questionnaire.addrx = task.addrx;
    questionnaire.addry = task.addry;
//    PYManagedQuestionnaire *n_questionnaire = [PYManagedQuestionnaire managedQuestionnaireWithTask:task inContext:self.managedObjectContext];
//    n_questionnaire.user = questionnaire.user;
//    [n_questionnaire addQuestions:questionnaire.questions];
//    
//    //删除旧问卷
//    [self deleteQuestaionnaire:task relationLoginName:loginName];
//    //添加新问卷
    [self.managedObjectContext save:nil];
}

/*
 * 查找用户问卷
 */
- (NSArray<PYTask *> *)selectQuestionnairesWithUserLoginName:(NSString *)loginName
{
    PYManagedUser *user = [self selectUserWithLoginName:loginName];
    return  [PYTask conversionFromSet:user.questionnaires];
}

/*
 *  查找指定问卷
 */
- (PYManagedQuestionnaire *)selectQuestionnaireWithId:(NSString *)resultId relationLoginName:(NSString *)loginName
{
    if (resultId == nil) return nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PYManagedQuestionnaire class])];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"resultId=%@ AND user.loginName=%@", resultId,loginName];
    request.predicate = predicate;
    
    
    return [[self.managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

/*!
 *  搜索问卷
 *
 *  @return
 */
- (NSSet<PYManagedQuestionnaire *> *)selectQuestionnaireWithRecord:(PYHistoryRecord *)record relationLoginName:(NSString *)loginName
{

    NSString *searchKey = record.searchKey;
    NSInteger searchType = record.searchType;
    
    if (searchKey.length == 0) {
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PYManagedQuestionnaire class])];
    
    NSString * typeName = varname_to_string(objCode);
    if (searchType == 1) {
        typeName = varname_to_string(objName);
    }
    
    NSString *sql = [NSString stringWithFormat:@"%@ like '*%@*' AND user.loginName='%@'",typeName, searchKey,[NSString checkString:loginName]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    request.predicate = predicate;
    
    
    return [NSSet setWithArray:[self.managedObjectContext executeFetchRequest:request error:nil]];
    
}

/*
 *  保存Questions
 */
 - (void)saveQuestions:(NSArray<NSDictionary *> *)questions questionnaireId:(NSString *)resultId relationLoginName:(NSString *)loginName
{
    if (questions == nil) return;
    
    PYManagedQuestionnaire *questionnaire = [self selectQuestionnaireWithId:resultId relationLoginName:loginName];
    
    [questionnaire.questions enumerateObjectsUsingBlock:^(PYManagedQuestion * _Nonnull obj, BOOL * _Nonnull stop) {
       
        [self.managedObjectContext deleteObject:obj];
    }];
    
    [questionnaire removeQuestions:questionnaire.questions];
    
    NSArray *m_questions = [PYManagedQuestion questionWithKeyValues:questions context:self.managedObjectContext];
    


    [questionnaire addQuestions:[NSSet setWithArray:m_questions]];
    
    [self.managedObjectContext save:nil];
}


/*
 *  查找Questions
 */
- (NSArray<NSDictionary *> *)selectQuestionsByQuestionnaireId:(NSString *)resultId relationLoginName:(NSString *)loginName
{
   PYManagedQuestionnaire *questionnaire = [self selectQuestionnaireWithId:resultId relationLoginName:loginName];
    
    NSArray *array = [PYQuestion conversionFromSet:questionnaire.questions];

   return [[NSObject mj_keyValuesArrayWithObjectArray:array] copy];
}


- (PYManagedQuestion *)selectQuestionWithId:(NSString *)questionId questionnaireId:(NSString *)resultId relationLoginName:(NSString *)loginName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PYManagedQuestion class])];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questionId=%@ AND questionnaire.resultId=%@ AND questionnaire.user.loginName=%@ AND ",questionId, resultId,loginName];
    request.predicate = predicate;

    return [[self.managedObjectContext executeFetchRequest:request error:nil] firstObject];
}


@end
