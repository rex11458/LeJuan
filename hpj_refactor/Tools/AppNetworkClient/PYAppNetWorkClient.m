//
//  PYAppNetWorkClient.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYAppNetWorkClient.h"
#define HTTP_CONTENT @"text/html"

@implementation PYAppNetWorkClient

+  (nonnull PYAppNetWorkClient *)sharedNetWorkClient
{
    static PYAppNetWorkClient *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[PYAppNetWorkClient alloc] initWithBaseURL:[NSURL URLWithString:PYBaseURL]];
    });
    
    return shared;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        
        [self config];
        
    }
    return self;
}


- (void)config
{
    AFHTTPResponseSerializer *respSerializer = [AFHTTPResponseSerializer serializer];
//    respSerializer.removesKeysWithNullValues = YES;
//    respSerializer.acceptableContentTypes = [NSSet setWithObjects:HTTP_CONTENT, nil];
    self.responseSerializer = respSerializer;
}

- (nullable NSURLSessionDataTask *)py_requstWithMethod:(PYRequestMethod)method
                                               url:(nonnull NSString *)url
                                        parameters:(nullable NSDictionary *)parameters
                                           isCache:(BOOL)isCache
                                        completion:(nullable void (^)(id _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork))completion;
{
    PYNetworkActivityIndicatorVisiable(YES);
   NSURLSessionDataTask *task = [self handleWithMethod:method url:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id resposeObj) {
    
        if (completion) {
            completion(resposeObj,nil,NO,NO);
        }
       PYNetworkActivityIndicatorVisiable(NO);

    } failure:^(id task, NSError *error) {
        if (completion) {
            completion(nil,error,YES,YES);
        }
        PYNetworkActivityIndicatorVisiable(NO);
    }];
    
    return task;
}


//下载
- (nullable NSURLSessionDataTask *)py_downloadWithMethod:(PYRequestMethod)method
                                                     url:(nonnull NSString *)url
                                              parameters:(nullable NSDictionary *)parameters
                                                progress:(nullable void (^)(NSProgress * _Nullable))downloadProgress
                                              completion:(nullable void (^)(id _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork))completion
{
    PYNetworkActivityIndicatorVisiable(YES);
    NSURLSessionDataTask *task = [self handleWithMethod:method url:url parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask *task, id resposeObj) {
        
        if (completion) {
            completion(resposeObj,nil,NO,NO);
        }
        PYNetworkActivityIndicatorVisiable(NO);
        
    } failure:^(id task, NSError *error) {
        if (completion) {
            completion(nil,error,YES,YES);
        }
        PYNetworkActivityIndicatorVisiable(NO);
    }];
    
    return task;
}

//上传
- (nullable NSURLSessionDataTask *)py_uploadWithMethod:(PYRequestMethod)method
                                                   url:(nonnull NSString *)url
                                            parameters:(nullable NSDictionary *)parameters
                                              progress:(nullable void (^)(NSProgress * _Nullable))uploadProgress
                                            completion:(nullable void (^)(id _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork))completion
{
    PYNetworkActivityIndicatorVisiable(YES);
    NSURLSessionDataTask *task = [self handleWithMethod:method url:url parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask *task, id resposeObj) {
        
        if (completion) {
            completion(resposeObj,nil,NO,NO);
        }
        PYNetworkActivityIndicatorVisiable(NO);
        
    } failure:^(id task, NSError *error) {
        if (completion) {
            completion(nil,error,YES,YES);
        }
        PYNetworkActivityIndicatorVisiable(NO);
    }];
    
    return task;
}

- (NSURLSessionDataTask *)handleWithMethod:(PYRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters progress:(nullable void (^)(NSProgress * _Nullable))progress success:(void(^)(id task,id resposeObj))success failure:(void(^)(id task,NSError *error))failue
{
    NSURLSessionDataTask *task = nil;
    if (method == PYRequestGETMethod)
    {
       task = [self GET:url parameters:nil progress:progress success:success failure:failue];
    }
    else if(method == PYRequestPOSTMethod)
    {
        task = [self POST:url parameters:parameters progress:progress success:success failure:failue];
    }
    return task;
}

+ (void)cancelTask:(nullable NSURLSessionTask *)task
{
    [task cancel];
}
@end
