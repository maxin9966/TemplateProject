//
//  DatePicker.h
//  MeiMei
//
//  Created by Admin on 14-4-15.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatePicker : NSObject{
    UIView           *_maskView;
}

+ (DatePicker *)sharedInstance;

- (void)show;

- (void)dissMiss;

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) UIDatePickerMode datePickerMode;
@property (nonatomic,assign) NSDate *minimumDate;
@property (nonatomic,strong) NSDate *date;

@property (nonatomic,strong) UIDatePicker *datePicker;

@end

@protocol DatePickerDelegate <NSObject>
@optional
- (void)chooseDate:(NSDate *)date;

@end