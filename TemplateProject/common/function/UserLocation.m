//
//  UserLocation.m
//  MeiMei_Practice
//
//  Created by 马鑫 on 14-9-1.
//  Copyright (c) 2014年 马鑫. All rights reserved.
//

#import "UserLocation.h"
#import "MyCommon.h"

@interface UserLocation()
<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    MyTimer *timer;
}

@end

@implementation UserLocation
@synthesize currentCoordinate;

+ (UserLocation*)sharedInstance
{
    static UserLocation *userLocation = nil;
    @synchronized(userLocation){
        if(!userLocation){
            userLocation = [[self alloc]init];
        }
        return userLocation;
    }
}

- (id)init
{
    self = [super init];
    if(self){
        // 判断定位操作是否被允许
        if([CLLocationManager locationServicesEnabled]) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.distanceFilter = 10;//每10m更新一次
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                //是否具有定位权限
                if(!([CLLocationManager authorizationStatus]>kCLAuthorizationStatusDenied)){
                    [locationManager requestWhenInUseAuthorization];
                }
            }
        }
        timer = [MyTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(showTips) userInfo:nil repeats:YES];
        [self showTips];
    }
    return self;
}

+ (BOOL)locationServicesEnabled
{
    return [CLLocationManager authorizationStatus]>kCLAuthorizationStatusDenied;
}

//开始定位
- (void)startUpdate
{
    [locationManager startUpdatingLocation];
}

//结束定位
- (void)stopUpdate
{
    [locationManager stopUpdatingLocation];
}

//提示用户打开定位
- (void)showTips
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status != kCLAuthorizationStatusNotDetermined){
        [timer invalidate];
    }
    if(status != kCLAuthorizationStatusNotDetermined && status <= kCLAuthorizationStatusDenied){
        static NSString *locationDeniedNoRepeatTips = @"locationDeniedNoRepeatTips";
        //不会重复提醒
        [MyCommon showTips:@"请在iPhone的“设置-隐私-定位服务”选项中，允许我们使用定位服务，否则部分功能将无法使用。" key:locationDeniedNoRepeatTips noRepeatInterval:0];
    }
}

#pragma mark - CLLocationManagerDelegate
//坐标更新回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    currentCoordinate = currentLocation.coordinate;
    NSLog(@"___latitude:%f longitude:%f",currentCoordinate.latitude,currentCoordinate.longitude);
}

@end
