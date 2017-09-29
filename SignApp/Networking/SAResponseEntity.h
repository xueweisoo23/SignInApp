//
//  SAResponseEntity.h
//  SignApp
//
//  Created by Genius on 2017/9/27.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAResponseEntity : NSObject

@property (nonatomic, assign) BOOL  success;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) id    data;
//@property (nonatomic) NSInteger pointNum;
//@property (nonatomic, strong) NSString *pointMess;

@end
