//
//  RangeDatePicker.h
//  MeiYue
//
//  Created by antsmen on 15/6/10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RangeDatePicker;

@protocol RangeDatePickerDelegate <NSObject>

- (void)rangeDatePicker:(RangeDatePicker*)picker didPickerStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end

@interface RangeDatePicker : UIControl

@property (nonatomic,weak) id<RangeDatePickerDelegate>delegate;

- (void)showPicker;

- (void)hidePicker;

@end
