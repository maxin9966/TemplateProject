//
//  TouchDetector.h
//  ASTouchVisualizer
//
//  Created by antsmen on 15-1-23.
//  Copyright (c) 2015年 AutreSphere. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 触摸检测
 
 */

//触摸事件通知
extern NSString *const kTouchDetectorDidReceiveEvent;

@interface TouchDetector : NSObject

//安装之后可以注册kTouchDetectorDidReceiveEvent通知来获取检测到的触摸事件
+ (void)install;

@end
