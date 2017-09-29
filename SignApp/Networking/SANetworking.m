//
//  SANetworking.m
//  SignApp
//
//  Created by Genius on 2017/9/27.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import "SANetworking.h"

@interface SANetworking()

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation SANetworking

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return _sessionManager;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SANetworking *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SANetworking alloc] init];
    });
    return sharedInstance;
}

- (NSURLSessionDataTask *)callAPIWithRequestType:(SANetworkingRequestType)requestType requestPath:(NSString *)requestPath paraments:(NSArray *)paraments finishBlock:(AFCallBackBlock)finishBlock {
    NSURLSessionDataTask *dataTask;
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = 30;
    if (self.responseSerializer) {
        self.sessionManager.responseSerializer = self.responseSerializer;
    } else {
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves];
    }
    
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    
    switch (requestType) {
        case SANetworkingRequestTypeGet:
        {
            dataTask = [self.sessionManager GET:requestPath parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
                        {
                            [self successCallBackForTask:task responseObject:responseObject finishedBlock:finishBlock];
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                        {
                            [self failedCallBackForTask:task error:error finishedBlock:finishBlock];
                        }];
            break;
        }
            
        case SANetworkingRequestTypePost:
        {
            dataTask = [self.sessionManager POST:requestPath parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                [self successCallBackForTask:task responseObject:responseObject finishedBlock:finishBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self failedCallBackForTask:task error:error finishedBlock:finishBlock];
            }];
            break;
        }
            
        default:
            break;
    }
    return dataTask;
}

/** 请求成功 */
- (void)successCallBackForTask:(NSURLSessionDataTask *)task responseObject:(id)responseObj finishedBlock:(AFCallBackBlock)finishedBlock
{
    SAResponseEntity *entity = [[SAResponseEntity alloc] init];
    
    // 判断是否有数据传回
    id data = [responseObj valueForKey:@"data"];
    if (data) {
        entity.success = YES;
        entity.data = data;
        entity.msg = [responseObj valueForKey:@"msg"];
    }
    
    finishedBlock(task, entity);
}

/** 请求失败 */
- (void)failedCallBackForTask:(NSURLSessionDataTask *)task error:(NSError *)err finishedBlock:(AFCallBackBlock)finishedBlock
{
    NSLog(@"请求失败");
    
    SAResponseEntity *entity = [[SAResponseEntity alloc] init];
    
    finishedBlock(task, entity);
}

- (void)cancelAllRequest {
    [self.sessionManager.operationQueue cancelAllOperations];
}

- (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestPath:(NSString *)requestPath {
    NSError *error;
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    NSString *requestToBeCanceled = [[[self.sessionManager.requestSerializer requestWithMethod:requestType URLString:requestPath parameters:nil error:&error] URL] path];
    
    for (NSOperation *operation in self.sessionManager.operationQueue.operations) {
        // 是否位于请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            // 请求类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            // 请求地址匹配
            BOOL hasMatchRequestPath = [requestToBeCanceled isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            // 若两项都匹配成功，取消请求
            if (hasMatchRequestType && hasMatchRequestPath) {
                [operation cancel];
            }
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
