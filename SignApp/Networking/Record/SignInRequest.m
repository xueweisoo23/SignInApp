//
//  SignInRequest.m
//  SignApp
//
//  Created by Genius on 2017/9/28.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import "SignInRequest.h"

@implementation SignInRequest

- (NSString *)requestPath {
    return @"Design_Time_Addresses/LeaveAndOverServiceImp/restful/signinrecord/signinrecord-add";
}

- (NSArray *)parametes {
    NSDictionary *dic = @{@"UserId" : self.userID,
                          @"StationName" : self.stationName,
                          @"Longitude" : self.longitude,
                          @"Dimensions" : self.dimensions,
                          @"SigninTime" : self.signinTime,
                          @"Type" : self.type};
    
    NSArray *arr = [NSArray arrayWithObject:dic];
    
    return arr;
}

@end
