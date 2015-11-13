//
//  MXURLSessionDownloadTask.m
//  LaneTrip
//
//  Created by antsmen on 15-4-30.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MXURLSessionDownloadTask.h"

@implementation MXURLSessionDownloadTask
@synthesize task;
@synthesize isCancelled;

- (void)cancel
{
    [task cancel];
    isCancelled = YES;
}

@end
