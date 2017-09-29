//
//  SANetworkingRequest.m
//  SignApp
//
//  Created by Genius on 2017/9/27.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import "SANetworkingRequest.h"

@implementation SANetworkingRequest

+ (instancetype)request {
    return [[[self class] alloc] init];
}

- (NSString *)baseUrl
{
    return BASE_URL;
}

- (NSString *)requestFullUrl {
    NSString *fullUrl = nil;
    NSString *requestPath = [self requestPath];
    if ([requestPath hasPrefix:@"/"]) {
        fullUrl = [[self baseUrl] stringByAppendingString:requestPath];
    }else {
        fullUrl = [[self baseUrl] stringByAppendingFormat:@"/%@", requestPath];
    }
    
    return fullUrl;
}

- (NSString *)requestPath {
    return nil;
}

- (NSDictionary *)parametes {
    return nil;
}

- (id)parsingData:(id)data {
    return nil;
}

- (void)sendRequestWithRequestType:(SANetworkingRequestType)requestType finishBlock:(AFCallBackBlock)finishBlock {
    self.operation = [[SANetworking sharedInstance] callAPIWithRequestType:requestType requestPath:[self requestFullUrl] paraments:[self parametes] finishBlock:^(NSURLSessionDataTask *task, SAResponseEntity *responseObject) {
        
        finishBlock(task, responseObject);
    }];
}

- (void)cancelAllRequest {
    [[SANetworking sharedInstance] cancelAllRequest];
}

- (void)cancelHttpRequestWithRequestType:(SANetworkingRequestType)requestType requestPath:(NSString *)requestPath {
    [[SANetworking sharedInstance] cancelHttpRequestWithRequestType:requestType == SANetworkingRequestTypeGet ? @"GET" : @"POST" requestPath:requestPath];
}

- (void)cancelHttpRequestWithRequestArray:(NSArray *)requestArray {
    for (NSArray *cancelRequestArray in requestArray) {
        if ([cancelRequestArray valueForKey:@"requestType"] && [cancelRequestArray valueForKey:@"requestPath"]) {
            NSString *requestType = [cancelRequestArray valueForKey:@"requestType"];
            NSString *requestPath = [cancelRequestArray valueForKey:@"requestPath"];
            
            [[SANetworking sharedInstance] cancelHttpRequestWithRequestType:requestType requestPath:requestPath];
        }
    }
}

@end
