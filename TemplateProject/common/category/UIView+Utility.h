//
//  UIView+Utility.h
//  FansKit
//
//  Created by MA on 14/12/19.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

//等比缩放
- (void)zoomWithRatio:(CGFloat)ratio;

//缩放所有subview 非递归 subview的subview让其自行管理
- (void)zoomSubviewsWithRatio:(CGFloat)ratio;

@end
