//
//  AFRequest.h
//  FansKit
//
//  Created by MA on 14/12/4.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//#define RequestTimeout 30.f
#define kResponseData @"data"

/**
 
 HTTP请求
 
 */

@interface HttpRequest : AFHTTPRequestOperationManager

+ (AFHTTPRequestOperation *)getWithAPI:(NSString*)api
        parameters:(NSDictionary*)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)postWithAPI:(NSString*)api
         parameters:(NSDictionary*)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
