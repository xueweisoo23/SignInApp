//
//  SANetworkingRequest.h
//  SignApp
//
//  Created by Genius on 2017/9/27.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SANetworking.h"

@interface SANetworkingRequest : NSObject

/** 定义请求和响应的序列化方式 */
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> *responseSerializer;

@property (nonatomic,strong) NSURLSessionDataTask *operation;

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)request;

/**
 *  服务器地址，用于继承
 */
- (NSString *)requestPath;

/**
 *  接口地址，用于继承
 */
- (NSString *)requestFullUrl;

/**
 *  接口参数，用于继承
 */
- (NSDictionary *)parametes;

/**
 *  数据处理，用于继承
 */
- (id)parsingData:(id)data;

/**
 *  发送接口请求
 */
- (void)sendRequestWithRequestType:(SANetworkingRequestType)requestType finishBlock:(AFCallBackBlock)finishBlock;

@end
