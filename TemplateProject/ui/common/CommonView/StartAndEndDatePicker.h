//
//  StartAndEndDatePicker.h
//  MeiYue
//
//  Created by antsmen on 15/6/10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartAndEndDatePicker;

@protocol StartAndEndDatePickerDelegate <NSObject>

- (void)startAndEndDatePicker:(StartAndEndDatePicker*)picker didPickerStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end

@interface StartAndEndDatePicker : NSObject

@property (nonatomic,weak) id<StartAndEndDatePickerDelegate>delegate;

- (void)showPicker;

- (void)hidePicker;

@end
