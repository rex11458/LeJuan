//
//  PYAppNetWorkClient.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum : NSUInteger {
    PYRequestSuccessType,  //请求成功
    PYRequestErroredType,        //请求出错
    PYRequestUnavailableType     //网络出错
} PYRequestStatusType;

typedef enum : NSUInteger {
    
    PYRequestPOSTMethod,
    PYRequestGETMethod

} PYRequestMethod;

@interface PYAppNetWorkClient : AFHTTPSessionManager

+  (nonnull PYAppNetWorkClient *)sharedNetWorkClient;

- (nullable NSURLSessionDataTask *)py_requstWithMethod:(PYRequestMethod)method
                                               url:(nonnull NSString *)url
                                        parameters:(nullable NSDictionary *)parameters
                                           isCache:(BOOL)isCache
                                        completion:(nullable void (^)(id _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork))completion;

//下载
- (nullable NSURLSessionDataTask *)py_downloadWithMethod:(PYRequestMethod)method
                                                     url:(nonnull NSString *)url
                                              parameters:(nullable NSDictionary *)parameters
                                                progress:(nullable void (^)(NSProgress * _Nullable))downloadProgress
                                              completion:(nullable void (^)(id _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork))completion;

//上传
- (nullable NSURLSessionDataTask *)py_uploadWithMethod:(PYRequestMethod)method
                                                     url:(nonnull NSString *)url
                                              parameters:(nullable NSDictionary *)parameters
                                                progress:(nullable void (^)(NSProgress * _Nullable))uploadProgress
                                              completion:(nullable void (^)(id _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork))completion;

+ (void)cancelTask:(nullable NSURLSessionTask *)task;


@end
