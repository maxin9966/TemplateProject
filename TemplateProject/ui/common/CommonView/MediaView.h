//
//  MediaView.h
//  LaneTrip
//
//  Created by antsmen on 15-4-10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Media.h"

/**
 
 多媒体
 
 */

@interface MediaView : UIView

@property (nonatomic,strong) NSArray *dataList;

- (void)stopVideoPlay;

@end
