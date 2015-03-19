//
//  UserLocation.h
//  MeiMei_Practice
//
//  Created by 马鑫 on 14-9-1.
//  Copyright (c) 2014年 马鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocation : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D currentCoordinate;//当前用户坐标

+ (UserLocation*)sharedInstance;

//是否允许定位
+ (BOOL)locationServicesEnabled;

//更新坐标
- (void)startUpdate;

//停止更新坐标
- (void)stopUpdate;

@end
