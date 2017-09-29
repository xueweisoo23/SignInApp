//
//  SANetworking.h
//  SignApp
//
//  Created by Genius on 2017/9/27.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SAResponseEntity.h"

/** 定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, SANetworkingRequestType)
{
    SANetworkingRequestTypeGet,
    SANetworkingRequestTypePost
};

/** 定义请求完成的block回调 */
typedef void (^AFCallBackBlock)(NSURLSessionDataTask *task, SAResponseEntity *responseObject);

@interface SANetworking : NSObject

/** 定义响应的序列化方式 */
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> *responseSerializer;

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)sharedInstance;

/**
 *  网络请求的实例方法
 *
 *  @param requestType    get / post
 *  @param requestPath    请求的地址
 *  @param paraments      请求的参数
 *  @param finishBlock    请求完成的回调
 */
- (NSURLSessionDataTask *)callAPIWithRequestType:(SANetworkingRequestType)requestType requestPath:(NSString *)requestPath paraments:(NSDictionary *)paraments finishBlock:(AFCallBackBlock)finishBlock;

/**
 *  取消所有的网络请求
 */
- (void)cancelAllRequest;

/**
 *  取消指定的单个请求
 *
 *  @param requestType     该请求的请求类型
 *  @param requestPath     该请求的地址
 */
- (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestPath:(NSString *)requestPath;

@end
