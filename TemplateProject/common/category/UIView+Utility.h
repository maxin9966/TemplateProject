//
//  UIView+Utility.h
//  FansKit
//
//  Created by MA on 14/12/19.
//  Copyright (c) 2014年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

- (CGFloat)zoomRatio;

//等比缩放
- (void)zoomWithRatio:(CGFloat)ratio;

//缩放所有subview 非递归 subview的subview让其自行管理
- (void)zoomSubviewsWithRatio:(CGFloat)ratio;

- (void)zoomSubviewsWithRatio:(CGFloat)ratio except:(NSArray*)exceptList;

//画线
- (UIView*)drawLineInRect:(CGRect)rect color:(UIColor *)color;

//坐标
- (CGFloat)bottomY;
- (CGFloat)topY;
- (CGFloat)leftX;
- (CGFloat)rightX;

- (void)setFrameWidth:(CGFloat)newWidth;
- (void)setFrameHeight:(CGFloat)newHeight;
- (void)setFrameOriginX:(CGFloat)newX;
- (void)setFrameOriginY:(CGFloat)newY;

@end
