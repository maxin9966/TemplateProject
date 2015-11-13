//
//  SizeFitLabel.h
//  LaneTrip
//
//  Created by antsmen on 15/5/19.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 自适应控件
 
 */

typedef NS_ENUM(NSInteger, SizeFitLabelAlignment) {
    SizeFitLabelAlignmentLeft      = 0,    // Visually left aligned
    SizeFitLabelAlignmentCenter    = 1,    // Visually centered
    SizeFitLabelAlignmentRight     = 2,    // Visually right aligned
};

@interface SizeFitLabel : UILabel

//默认0（0代表无限制）
@property (nonatomic,assign) CGFloat widthLimit;

//对齐方式 默认左对齐
@property (nonatomic,assign) SizeFitLabelAlignment alignment;

@end
