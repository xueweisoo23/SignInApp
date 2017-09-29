//
//  DailyRecordRequest.m
//  SignApp
//
//  Created by Genius on 2017/9/29.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import "DailyRecordRequest.h"

@implementation DailyRecordRequest

- (NSString *)requestPath {
    return [NSString stringWithFormat:@"Design_Time_Addresses/LeaveAndOverServiceImp/restful/signinrecord/usersigninrecord/today/%@", self.userId];
}

@end
