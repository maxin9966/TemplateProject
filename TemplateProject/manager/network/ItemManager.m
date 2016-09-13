//
//  ItemManager.m
//  YanMo
//
//  Created by 蚁众 on 15/12/15.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import "ItemManager.h"

@implementation ItemManager

+ (instancetype)shareInstance{
    static ItemManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSOperation *)SureOverWithJobId:(NSInteger)jobId completion:(BooleanBlock)completion{
    NSString *api = @"project/sumbitLine.action";
    NSDictionary *dic = @{@"lineId":@(jobId)};
    return [HttpRequest postWithAPI:api parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = [MyCommon getErrorWithResponse:responseObject];
        if (!error) {
            if (completion) {
                completion(YES,nil);
            }
        }else{
            if (completion) {
                completion(NO,error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO,error);
        }
    }];
}

@end
