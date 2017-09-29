//
//  SignInRequest.h
//  SignApp
//
//  Created by Genius on 2017/9/28.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import "SANetworkingRequest.h"

@interface SignInRequest : SANetworkingRequest

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *stationName;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *dimensions;
@property (nonatomic,strong) NSString *signinTime;
@property (nonatomic, assign) NSString *type;

@end
