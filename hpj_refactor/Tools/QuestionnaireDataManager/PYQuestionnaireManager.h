//
//  PYQuestionnaireManager.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PYHistoryRecord;
@class PYLoginUser;
@class PYManagedUser;
@class PYManagedQuestionnaire;
@class PYTask;
@interface PYQuestionnaireManager : NSObject

@property (nonatomic, strong) NSManagedObjectModel   *managedObjectModel;   //数据模型对象
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext; //上下文对象
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator; //持久性存储区

+ (instancetype)sharedInstance;

//查找所有用户
- (NSArray *)getAllUser;

/*
 *添加用户
 */
- (void)insertUser:(PYLoginUser *)user;

/*
 *删除用户
 */
- (void)deleteUserWithLoginName:(NSString *)loginName;

/*
 * 修改用户
 */
- (void)alterUserWithLoginName:(NSString *)loginName newUser:(PYLoginUser *)user;

/*
 *根据loginName查找指定用户
 */
- (PYManagedUser *)selectUserWithLoginName:(NSString *)loginName;

///*
// * 为指定用户添加问卷
// */
- (void)insertQuestionnaire:(PYTask *)task relationloginName:(NSString *)loginName;

/*
 *删除指定用户的问卷
 */
- (void)deleteQuestaionnaire:(PYTask *)task relationLoginName:(NSString *)loginName;

/*
 *  修改指定用户问卷信息 (是否进店，是否离店)
 */
- (void)alertQuestionnaire:(PYTask *)task relationLoginName:(NSString *)loginName;

/*
 *  查找用户问卷
 */
- (NSArray<PYTask *> *)selectQuestionnairesWithUserLoginName:(NSString *)loginName;

/*
 *  查找指定问卷
 */
- (PYManagedQuestionnaire *)selectQuestionnaireWithId:(NSString *)resultId relationLoginName:(NSString *)loginName;

/*!
 *  搜索问卷
 *
 *  @return
 */
- (NSSet<PYManagedQuestionnaire *> *)selectQuestionnaireWithRecord:(PYHistoryRecord *)record relationLoginName:(NSString *)loginName;



//保存Questions
- (void)saveQuestions:(NSArray<NSDictionary *> *)questions questionnaireId:(NSString *)resultId relationLoginName:(NSString *)loginName;;

//查找Questions
- (NSArray<NSDictionary *> *)selectQuestionsByQuestionnaireId:(NSString *)resultId relationLoginName:(NSString *)loginName;

@end
